// If the order number is null it will update the order in cart
function update_quantity_cart(variant_id, quantity, order_number = null, item_text = null, type_text = null) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id+"&order_number="+order_number,
    type:"post",
    success:function( data ) {
      if (item_text && type_text) {
        $('[data-toggle="item-cart"]').attr('data-content', '<div class="content-popover"><div class="quantity col-md-2">'+Math.abs(quantity)+'</div><div class="col-md-6">'+item_text +' '+type_text+'</div></div>');
        $('[data-toggle="item-cart"]').popover('show');
      }
    },
    error:function( err ){
      $('[data-toggle="item-cart"]').attr('data-content', '<div class="content-popover">Error adding to cart</div>');
      $('[data-toggle="item-cart"]').popover('show');
    },
    complete:function(){
      refresh_cart_partial();
    }
  });
}

function refresh_cart_partial() {
  $.ajax({
    url: "/cart_partial"
  })
}

$(document).on('mouseleave','.popover-content',function(){
  $('[data-toggle="item-cart"]').popover('hide');
});

$(document).ready(function (){
  var update_data;
  var order_number = $('#order_number').val();
  function start_timer_function(type, variant_id, quantity) {
    $('[data-toggle="item-cart"]').popover('destroy');
    update_data = setTimeout(function(){
      var item_text = quantity <= 1 ? "item" : "items";
      var type_text = type=='increase' ? "added" : "removed";
      update_quantity_cart(variant_id, type=='increase' ? quantity : -(quantity), order_number, item_text, type_text);

      $('.decrease-quantity').data("click_count", 0)
      $('.increase-quantity').data("click_count", 0)


      $('[data-toggle="item-cart"]').popover({
        html: true,
        content: '<div class="content-popover"><div class="quantity col-md-2">'+quantity+'</div><div class="col-md-6">'+item_text +' '+type_text+'</div></div>',
      });

    }, 1000);
  }

  function stop_timer_function() {
    clearTimeout(update_data);
  }

  $(document).on('click', '.delete_line_item', function() {
    var variant = $(this).closest('tr').find('.variant').val();
    var quantity = $(this).closest('tr').find('.line_item_quantity');
    var order_number = $('#order_number').val();
    update_quantity_cart(variant, -(quantity.val()), order_number);
    quantity.val(0);
  })

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