// If the order number is null it will update the order in cart
function update_quantity_cart(variant_id, quantity, order_number = null, order_id = null, body_id, item_text = null, type_text = null) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id+"&order_number="+order_number,
    type:"post",
    success:function( data ) {
      if (body_id == 'cart'){
        if (item_text && type_text) {
          popover_content('<div class="content-popover"><div class="quantity col-md-2">'+Math.abs(quantity)+'</div><div class="col-md-6">'+item_text +' '+type_text+'</div></div>')
        }
        refresh_cart_partial();
      }
      else {
        refresh_reorder_partial(data.order.id, order_number);
      }
    },
    error:function( err ){
      if (body_id == 'cart'){
        popover_content('<div class="content-popover">Error adding to cart</div>');
        refresh_cart_partial();
      }
      else {
        refresh_reorder_partial(order_id, order_number);
      }
    }
  });
}

function refresh_cart_partial() {
  $.ajax({
    url: "/cart_partial"
  })
}

function refresh_reorder_partial(order_id, order_number) {
  $.ajax({
    url: "/reorder_partial/"+order_id+"/"+order_number
  })
}

function popover_content(content){
  $('[data-toggle="item-cart"]').popover({
    html: true,
    content: content
  });
  $('[data-toggle="item-cart"]').popover('show')
  setTimeout(function () {
    if (!$(".popover:hover").length) {
        $('[data-toggle="item-cart"]').popover('hide');
        $('[data-toggle="item-cart"]').popover('destroy');
    }
  }, 5000);
}

$(document).on('mouseleave','.popover-content',function(){
  setTimeout(function () {
    if (!$(".popover:hover").length) {
        $('[data-toggle="item-cart"]').popover('hide');
        $('[data-toggle="item-cart"]').popover('destroy');
    }
  }, 1000);
});

$(document).on('click', function(e) {
  $('[data-toggle="item-cart"]').each(function() {
    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
      $(this).popover('hide');
      $(this).popover('destroy');
    }
  });
});

$(document).ready(function (){
  var update_data;
  var order_number = $('#order_number').val();
  var order_id = $('#order_id').val();
  var body_id = $('#body_id').val();

  function start_timer_function(type, variant_id, quantity) {
    $('[data-toggle="item-cart"]').popover('destroy');
    update_data = setTimeout(function(){
      var item_text = quantity <= 1 ? "item" : "items";
      var type_text = type=='increase' ? "added" : "removed";
      update_quantity_cart(variant_id, type=='increase' ? quantity : -(quantity), order_number, order_id, body_id, item_text, type_text);

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
    update_quantity_cart(variant, -(quantity.val()), order_number, order_id, body_id);
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