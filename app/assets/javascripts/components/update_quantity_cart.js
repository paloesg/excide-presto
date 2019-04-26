function refreshCartPartial() {
  $.ajax({
    url: "/cart_partial"
  })
}

function refreshReorderPartial(orderId, orderNumber) {
  $.ajax({
    url: "/reorder_partial/"+orderId+"/"+orderNumber
  })
}

// If the order number is null it will update the order in cart
function updateQuantityCart(bodyId, variantId, quantity, itemText = null, typeText = null) {
  var orderNumber = $("#order_number").val();
  var orderId = $("#order_id").val();
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variantId+"&order_number="+orderNumber,
    type: "post",
    success: ( data ) => {
      if (bodyId === "cart") {
        if (itemText && typeText) {
          var popover = new popoverContent("<div class='content-popover'><div class='quantity col-md-2'>"+Math.abs(quantity)+"</div><div class='col-md-6'>"+itemText +" "+typeText+"</div></div>");
          popover();
        }
        refreshCartPartial();
      }
      else {
        refreshReorderPartial(orderId, orderNumber);
      }
    },
    error: ( err ) => {
      if (bodyId === "cart"){
        var popover = new popoverContent("<div class='content-popover'>Error adding to cart</div>");
        popover();
        refreshCartPartial();
      }
      else {
        refreshReorderPartial(orderId, orderNumber);
      }
    }
  });
}

$(document).ready(function (){
  var updateData;
  function startTimerFunction(type, variantId, quantity) {
    $("[data-toggle='item-cart']").popover("destroy");
    updateData = setTimeout(function(){
      var itemText = quantity <= 1 ? "item" : "items";
      var typeText = type === "increase" ? "added" : "removed";
      var bodyId = $("#body_id").val();
      updateQuantityCart(bodyId, variantId, type === "increase" ? quantity : -(quantity), itemText, typeText);

      $(".decrease-quantity").data("click_count", 0);
      $(".increase-quantity").data("click_count", 0);

    }, 500);
  }

  function stopTimerFunction() {
    clearTimeout(updateData);
  }

  $(document).on("click", ".delete_line_item", function() {
    var variant = $(this).closest("tr").find(".variant").val();
    var quantity = $(this).closest("tr").find(".line_item_quantity");
    var bodyId = $("#body_id").val();
    updateQuantityCart(bodyId, variant, -(quantity.val()));
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
    if(isAdd){
      qty.val(currentValue + 1);
      startTimerFunction("increase", variant.val(), count);
    }
    else {
      if (currentValue - 1 !== -1) {
        qty.val(currentValue - 1);
      }
      else {
        $(this).closest(".number-quantity").find("decrease-quantity").prop("disabled", true);
      }
      startTimerFunction("decrease", variant.val(), count);
    }
  });
});