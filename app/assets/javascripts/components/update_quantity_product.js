function update_quantity(variantId, quantity) {
  SpreeAPI.Storefront.addToCart(
    variantId,
    quantity,
    {}, // options hash - you can pass additional parameters here, your backend
    function () {
      Spree.fetch_cart().done(function(data) {
        // update navbar cart, get total items in cart from 'data'
        $('[data-toggle="item-cart"]').popover('show');
        return $('#link-to-cart').html(data)
      });
      refresh_remaining_budget_partial();
    },
    function (error) {
      alert(error);
      location.reload();
    } // failure callback for 422 and 50x errors
  )
}

function refresh_remaining_budget_partial() {
  $.ajax({
    url: "/remaining_budget_partial"
  })
}

$(document).on('mouseleave','.popover-content',function(){
  $('[data-toggle="item-cart"]').popover('hide');
});

$(document).on('click', function(e) {
  $('[data-toggle="item-cart"]').each(function() {
    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
      $(this).popover('hide');
    }
  });
});

$(document).ready(function (){
  var update_data;
  function start_timer_function(type, variant_id, quantity) {
    $('[data-toggle="item-cart"]').popover('destroy');
    update_data = setTimeout(function(){
      var item_text = quantity <= 1 ? "item" : "items";
      var type_text = type=='increase' ? "added" : "removed";
      update_quantity(variant_id, type=='increase' ? quantity : -(quantity));

      $('.decrease').data("click_count", 0)
      $('.increase').data("click_count", 0)
      $('.addcart').data("click_add", 0)

      $('[data-toggle="item-cart"]').popover({
        html: true,
        content: '<div class="content-popover"><div class="quantity col-md-2">'+quantity+'</div><div class="col-md-6">'+item_text +' '+type_text+'</div></div>',
      });
    }, 500);
  }

  function stop_timer_function() {
    clearTimeout(update_data);
  }

  $(document).on('click', '.decrease,.increase', function() {
    stop_timer_function();
    var btn = $(this);
    var count = (btn.data("click_count") || 0) + 1;
    btn.data("click_count", count);

    var variant = $(this).closest('.quantity-input').find('.variant');
    var qty = $(this).closest('.quantity-input').find('.quantity'),
      current_val = parseInt(qty.val()),
      is_add = $(this).hasClass('increase');
    if(is_add){
      $('.'+qty.attr('id')).val(current_val + 1)
      start_timer_function('increase', variant.val(), count);
    }
    else {
      $('.'+qty.attr('id')).val(current_val - 1)
      start_timer_function('decrease', variant.val(), count);
    }

    if(qty.val() == 0){
      $('.increase_decrease[variant='+variant.val()+']').hide();
      $('.add_to_cart[variant='+variant.val()+']').show();
      add_to_cart_button = $(this).parents().siblings('.add_to_cart').find('.addcart');
      add_to_cart_button.prop('disabled', true);
      setTimeout(function(){
        add_to_cart_button.prop('disabled', false);
      }, 1000);
      add_to_cart_button.prop('disabled', true);
    }
  });

  $(document).on('click', '.addcart', function() {
    $(this).parents(".add_to_cart").siblings(".increase_decrease").find(".increase").click();
    var variant = $(this).closest('.add-cart').find('.variant');
    $('.add_to_cart[variant='+variant.val()+']').hide();
    $('.increase_decrease[variant='+variant.val()+']').show();
  });
})