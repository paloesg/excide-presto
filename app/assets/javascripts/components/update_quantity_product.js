/*global popoverContent SpreeAPI Spree*/
/*eslint no-undef: "error"*/

var getUrlParameter = (paramName) => {
  let sPageURL = window.location.search.substring(1),
      sURLVariables = sPageURL.split("&");

  let param = sURLVariables.map((q) => q.split("=")).filter((q) => q[0] === paramName)[0];

  if (!param) {
    return "undefined";
  }
  if (param && !param[1]) {
     return true;
  }
  else {
    return decodeURIComponent(param[1]);
  }
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

function updateQuantity(variantId, quantity) {
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
      refreshRemainingBudgetPartial();
    },
    function (error) {
      refreshProductPartial();
      refreshTaxonProductPartial(taxonId);
      $("#productContent").modal("hide");
      if (error === "Department budget is exceeded.") {
        popoverContent("<div class='content-popover'><div class='col-md-3'><div class='error-badge'>!</div></div><div class='col-md-9 content-error'><div class='error-text'>"+ error +"</div></div></div>");
      }
      else {
        popoverContent("<div class='content-popover'><div class='col-md-3'><div class='error-badge'>!</div></div><div class='col-md-9 content-error'><div class='error-text'>Error adding to cart</div></div></div>");
      }
    }
  );
}

function showPopoverCart(quantity){
  var typeText = quantity > 0 ? "added" : "removed";
  var itemText = Math.abs(quantity) <= 1 ? "item" : "items";
  popoverContent("<div class='content-popover'><div class='col-md-4 col-md-offset-1'><div class='quantity-badge'>"+Math.abs(quantity)+"</div></div><div class='col-md-6'>"+itemText+" "+typeText+"</div></div>");
}

$(document).ready(function (){
  var line_items = [];
  var updateData;
  function startTimerFunction(items) {
    $("[data-toggle='item-cart']").popover("destroy");
    updateData = setTimeout(function(){
      var time = 0;
      var quantity_update = 0;
      // Add delay every add to cart
      $.each(items, function(index, item) {
        setTimeout( function(){ updateQuantity(item.variant, item.quantity); }, time);
        quantity_update += item.quantity;
        time += 3000;        
      })
      // Show popover cart
      if (quantity_update != 0) {
        setTimeout( function(){ showPopoverCart(quantity_update); }, 3000);
      }

      line_items = [];

      $(".decrease").data("click_count", 0);
      $(".increase").data("click_count", 0);
      $(".addcart").data("click_add", 0);
    }, 2000);
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
    
    var data = {};

    if(isAdd){
      $("."+qty.attr("id")).val(currentValue + 1);
      data.variant = variant.val();
      data.quantity = 1;      
    }
    else {
      $("."+qty.attr("id")).val(currentValue - 1);
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
    
    startTimerFunction(line_items);
    if(qty.val() === "0"){
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
    $(this).parents(".add_to_cart").siblings(".increase_decrease").find(".increase").click();
    var variant = $(this).closest(".add-cart").find(".variant")
    $(".add_to_cart[variant="+variant.val()+"]").hide();
    $(".increase_decrease[variant="+variant.val()+"]").show()
  });
});