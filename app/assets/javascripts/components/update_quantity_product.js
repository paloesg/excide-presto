/*global popoverContent SpreeAPI Spree*/
/*eslint no-undef: "error"*/

var getUrlParameter = (paramName) => {
  let sPageURL = window.location.search.substring(1),
      sURLVariables = sPageURL.split("&");

  let param = sURLVariables.map((q) => q.split("=")).filter((q) => q[0] === paramName)[0];

  if (!param) {
    return undefined;
  }
  if (param && !param[1]) {
     return true;
  }
  else {
    return decodeURIComponent(param[1]);
  };
};

function refreshRemainingBudgetPartial() {
  $.ajax({
    url: "/remaining_budget_partial"
  });
}

function refreshProductPartial() {
  let sort = getUrlParameter("sort");
  let page = getUrlParameter("page");
  $.ajax({
    url: "/product_partial?sort="+sort+"&page="+page
  });
}

function refreshTaxonProductPartial(taxonId) {
  let sort = getUrlParameter("sort");
  let page = getUrlParameter("page");
  $.ajax({
    url: "/taxon_product_partial?id="+taxonId+"&sort="+sort+"&page="+page
  });
}

function updateQuantity(variantId, quantity, itemText = null, typeText = null) {
  var taxonId = $(".taxon-id").val();
  SpreeAPI.Storefront.addToCart(
    variantId,
    quantity,
    {}, // options hash - you can pass additional parameters here, your backend
    function () {
      Spree.fetch_cart().done(function(data) {
        // update navbar cart, get total items in cart from 'data'
        return $("#link-to-cart").html(data);
      });
      popoverContent("<div class='content-popover'><div class='col-md-4 col-md-offset-1'><div class='quantity-badge'>"+Math.abs(quantity)+"</div></div><div class='col-md-6'>"+itemText+" "+typeText+"</div></div>");
      refreshRemainingBudgetPartial();
    },
    function (error) {
      refreshProductPartial();
      refreshTaxonProductPartial(taxonId);
      $("#productContent").modal("hide");
      popoverContent("<div class='content-popover'><div class='col-md-3'><div class='error-badge'>!</div></div><div class='col-md-9 error-text'>Error adding to cart</div></div>");
    } // failure callback for 422 and 50x errors
  );
}

$(document).ready(function (){
  var updateData;
  function startTimerFunction(type, variantId, quantity) {
    $("[data-toggle='item-cart']").popover("destroy");
    updateData = setTimeout(function(){
      var itemText = quantity <= 1 ? "item" : "items";
      var typeText = type === "increase" ? "added" : "removed";
      updateQuantity(variantId, type === "increase" ? quantity : -(quantity), itemText, typeText);

      $(".decrease").data("click_count", 0);
      $(".increase").data("click_count", 0);
      $(".addcart").data("click_add", 0);
    }, 500);
  }

  function stopTimerFunction() {
    clearTimeout(updateData);
  }

  $(document).on("click", ".decrease,.increase", function() {
    stopTimerFunction();
    var btn = $(this);
    var count = (btn.data("click_count") || 0) + 1;
    btn.data("click_count", count);

    var variant = $(this).closest(".quantity-input").find(".variant");
    var qty = $(this).closest(".quantity-input").find(".quantity"),
      currentValue = parseInt(qty.val()),
      isAdd = $(this).hasClass("increase");
    if(isAdd){
      $("."+qty.attr("id")).val(currentValue + 1);
      startTimerFunction("increase", variant.val(), count);
    }
    else {
      $("."+qty.attr("id")).val(currentValue - 1);
      startTimerFunction("decrease", variant.val(), count);
    }
    if(qty.val() === "0"){
      $("."+qty.attr("id")).val(currentValue + 1);
      $(".increase_decrease[variant="+variant.val()+"]").hide();
      $(".add_to_cart[variant="+variant.val()+"]").show();
      var addToCartButton = $(this).parents().siblings(".add_to_cart").find(".addcart");
      addToCartButton.prop("disabled", true);
      setTimeout(function(){
        addToCartButton.prop("disabled", false);
      }, 1000);
      addToCartButton.prop("disabled", true);
    }
  });

  $(document).on("click", ".addcart", function() {
    stopTimerFunction();
    var variant = $(this).closest(".add-cart").find(".variant");
    var btn = $(this);
    var count = (btn.data("click_add") || 0) + 1;
    btn.data("click_add", count);
    startTimerFunction("increase", variant.val(), count);

    var qty = $(".quantity-input[id="+variant.val()+"]").find(".quantity");
    $("."+qty.attr("id")).val(1);
    $(".add_to_cart[variant="+variant.val()+"]").hide();
    $(".increase_decrease[variant="+variant.val()+"]").show();
  });
});