/*global popoverContent*/
/*eslint no-undef: "error"*/

function refreshCartPartial() {
  $.ajax({
    url: "/cart_partial"
  });
}

function refreshReorderPartial(orderId, orderNumber) {
  $.ajax({
    url: "/reorder_partial/"+orderId+"/"+orderNumber
  });
}

// If the order number is null it will update the order in cart
function updateQuantityCart(bodyId, variantId, quantity) {
  var orderNumber = $("#order_number").val();
  var orderId = $("#order_id").val();
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variantId+"&order_number="+orderNumber,
    type: "post",
    success: ( data ) => {
      if (bodyId === "cart") {
        // Enabled button when process update cart finish
        $('.decrease-quantity').prop("disabled", false);
        $('.increase-quantity').prop("disabled", false);
        $('.delete_line_item').prop("disabled", false); 
        refreshCartPartial();
      }
      else {
        refreshReorderPartial(orderId, orderNumber);
      }
    },
    error: ( error ) => {
      if (bodyId === "cart"){
        if (error.responseText === "Department budget is exceeded.") {
          popoverContent("<div class='content-popover'><div class='col-md-3'><div class='error-badge'>!</div></div><div class='col-md-9 content-error'><div class='error-text'>"+ error.responseText +"</div></div></div>");
        }
        else {
          popoverContent("<div class='content-popover'><div class='col-md-3'><div class='error-badge'>!</div></div><div class='col-md-9 content-error'><div class='error-text'>Error adding to cart</div></div></div>");
        }
        refreshCartPartial();
      }
      else {
        refreshReorderPartial(orderId, orderNumber);
      }
    }
  });
}

function showPopoverCart(quantity){
  var typeText = quantity > 0 ? "added" : "removed";
  var itemText = Math.abs(quantity) <= 1 ? "item" : "items";
  popoverContent("<div class='content-popover'><div class='col-md-4 col-md-offset-1'><div class='quantity-badge'>"+Math.abs(quantity)+"</div></div><div class='col-md-6'>"+itemText+" "+typeText+"</div></div>");
}

$(document).ready(function (){
  $('.loader').hide();
  var line_items = [];
  var updateData;

  function startTimerFunction(items) {
    $("[data-toggle='item-cart']").popover("destroy");
    updateData = setTimeout(function(){
      var time = 0;
      var quantity_update = 0;
      // Add delay every add to cart
      $.each(items, function(index, item) {
        var bodyId = $("#body_id").val();
        setTimeout( function(){ 
          // Disabled button when process update cart run          
          $('.decrease-quantity').prop("disabled", true);
          $('.increase-quantity').prop("disabled", true);
          $('.delete_line_item').prop("disabled", true); 
          updateQuantityCart(bodyId, item.variant, item.quantity);
        }, time);
        quantity_update += item.quantity;
        time += 5000;        
      })
      // Show popover cart
      if (quantity_update != 0) {
        setTimeout( function(){ showPopoverCart(quantity_update); }, 3000);
      }

      line_items = [];

      $(".decrease").data("click_count", 0);
      $(".increase").data("click_count", 0);
      $(".addcart").data("click_add", 0);
    }, 5000);
  }

  function stopTimerFunction() {
    clearTimeout(updateData);
  }

  $(document).on("click", ".delete_line_item", function() {
    var variant = $(this).closest("tr").find(".variant").val();
    var quantity = $(this).closest("tr").find(".line_item_quantity");
    var bodyId = $("#body_id").val();
    var quantity_value = quantity.val();
    setTimeout( function(){ showPopoverCart(-(quantity_value)); }, 3000);
    updateQuantityCart(bodyId, variant, -(quantity_value));
    quantity.val(0);
  });

  $(document).on("click", ".decrease-quantity,.increase-quantity", function() {
    stopTimerFunction();
    var btn = $(this);
    var count = (btn.data("click_count") || 0) + 1;
    btn.data("click_count", count);

    var variant = $(this).closest(".number-quantity").find(".variant");
    var qty = $(this).closest(".number-quantity").find(".line_item_quantity"),
      currentValue = parseInt(qty.val()),
      isAdd = $(this).hasClass("increase-quantity");
    
    var data = {};
    if(isAdd){
      qty.val(currentValue + 1);
      data.variant = variant.val();
      data.quantity = 1;    
    }
    else {
      if (currentValue - 1 !== -1) {
        qty.val(currentValue - 1);
      }
      else {
        $(this).closest(".number-quantity").find("decrease-quantity").prop("disabled", true);
      }
      data.variant = variant.val();
      data.quantity = - 1;  
    }

    //update line items array
    if (line_items.length > 0) {
      var added = false;
      $.map(line_items, function(line_item) {
        if (line_item.variant == data.variant) {
          line_item.quantity = line_item.quantity + data.quantity;
          added = true;
        }
      })
      if (!added) {
        line_items.push(data);
      } 
    } else {
      line_items.push(data);
    }  

    // Update Cart
    startTimerFunction(line_items);
  });
});