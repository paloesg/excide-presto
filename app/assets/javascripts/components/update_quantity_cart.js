function update_quantity_cart(variant_id, quantity) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id,
    type:"post",
    success:function( data ) {
      location.reload();
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).on('mouseleave','.popover-content',function(){
  $('[data-toggle="item-cart"]').popover('hide');
});

$(document).ready(function (){
  var update_data;
  function start_timer_function(type, variant_id, quantity) {
    $('[data-toggle="item-cart"]').popover('destroy');
    update_data = setTimeout(function(){
      var item_text = quantity <= 1 ? "item" : "items";
      var type_text = type=='increase' ? "added" : "removed";
      update_quantity_cart(variant_id, type=='increase' ? quantity : -(quantity));

      $('.decrease-quantity').data("click_count", 0)
      $('.increase-quantity').data("click_count", 0)

    }, 1000);
  }

  function stop_timer_function() {
    clearTimeout(update_data);
  }

  $(document).on('click', '.decrease-quantity,.increase-quantity', function() {
    stop_timer_function();
    var $btn = $(this);
    var count = ($btn.data("click_count") || 0) + 1;
    $btn.data("click_count", count);

    var $variant = $(this).closest('.number-quantity').find('.variant');
    var qty = $(this).closest('.number-quantity').find('.line_item_quantity'),
      current_val = parseInt(qty.val()),
      is_add = $(this).hasClass('increase-quantity');
    if(is_add){
      qty.val(current_val + 1);
      start_timer_function('increase', $variant.val(), count);
    }
    else {
      if (current_val - 1 != -1) {
        qty.val(current_val - 1);
      }
      else {
        $(this).closest('.number-quantity').find('decrease-quantity').prop('disabled', true);
      }
      start_timer_function('decrease', $variant.val(), count);
    }
  });
});