function update_quantity(variant_id, quantity) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id,
    type:"post",
    success:function( data ) {
      console.log("success");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

var update_data;

function start_timer_function(variant_id, quantity) {
  update_data = setTimeout(function(){
    update_quantity(variant_id, quantity);
  }, 1000);
}

function stop_timer_function() {
  clearTimeout(update_data);
}

$(document).ready(function (){
  $(document).on('click', '.decrease,.increase', function() {
    var $btn = $(this);
    var count = ($btn.data("click_count") || 0) + 1;
    $btn.data("click_count", count);
    stop_timer_function();

    var $variant = $(this).closest('.quantity-input').find('.variant');
    var $qty = $(this).closest('.quantity-input').find('.quantity'),
      current_val = parseInt($qty.val()),
      is_add = $(this).hasClass('increase');
    if(is_add){
      $qty.val(current_val + 1);
      start_timer_function($variant.val(), count);
    }
    else {
      $qty.val(current_val - 1);
      start_timer_function($variant.val(), -(count));
    }

    if($qty.val() == 0){
      $('.inscrease_decrease[variant='+$variant.val()+']').hide();
      $('.add_to_cart[variant='+$variant.val()+']').show();
    }
  });

  $(document).on('click', '.addcart', function() {
    var $variant = $(this).closest('.add-cart').find('.variant');
    update_quantity($variant.val(), 1);
    var $qty = $('.quantity-input[id='+$variant.val()+']').find('.quantity');
    $qty.val(1);
    $('.add_to_cart[variant='+$variant.val()+']').hide();
    $('.inscrease_decrease[variant='+$variant.val()+']').show();
  });
})