function update_quantity(variant_id, quantity) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id,
    type:"post",
    success:function( data ) {

    },
    error:function( result ){ console.log(["error", result]); }
  });
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
      }).popover('show');
    }, 1000);
  }

  function stop_timer_function() {
    clearTimeout(update_data);
  }

  $(document).on('click', '.decrease,.increase', function() {
    stop_timer_function();
    var $btn = $(this);
    var count = ($btn.data("click_count") || 0) + 1;
    $btn.data("click_count", count);

    var $variant = $(this).closest('.quantity-input').find('.variant');
    var $qty = $(this).closest('.quantity-input').find('.quantity'),
      current_val = parseInt($qty.val()),
      is_add = $(this).hasClass('increase');
    if(is_add){
      $qty.val(current_val + 1);
      start_timer_function('increase', $variant.val(), count);
    }
    else {
      $qty.val(current_val - 1);
      start_timer_function('decrease', $variant.val(), count);
    }

    if($qty.val() == 0){
      $('.inscrease_decrease[variant='+$variant.val()+']').hide();
      $('.add_to_cart[variant='+$variant.val()+']').show();
    }
  });

  $(document).on('click', '.addcart', function() {
    stop_timer_function();
    var $variant = $(this).closest('.add-cart').find('.variant');
    var $btn = $(this);
    var count = ($btn.data("click_add") || 0) + 1;
    $btn.data("click_add", count);
    start_timer_function('increase', $variant.val(), count);

    var $qty = $('.quantity-input[id='+$variant.val()+']').find('.quantity');
    $qty.val(1);
    $('.add_to_cart[variant='+$variant.val()+']').hide();
    $('.inscrease_decrease[variant='+$variant.val()+']').show();
  });
})