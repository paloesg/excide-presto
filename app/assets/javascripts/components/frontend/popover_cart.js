function popoverContent(content){
  $("[data-toggle='item-cart']").popover({
    html: true,
    content: content
  });
  $("[data-toggle='item-cart']").popover("show")
  setTimeout(function () {
    if (!$(".popover:hover").length) {
        $("[data-toggle='item-cart']").popover("hide");
        $("[data-toggle='item-cart']").popover("destroy");
    }
  }, 5000);
}

$(document).on("mouseleave",".popover-content",function(){
  setTimeout(function () {
    if (!$(".popover:hover").length) {
        $("[data-toggle='item-cart']").popover("hide");
        $("[data-toggle='item-cart']").popover("destroy");
    }
  }, 1000);
});

$(document).on("click", function(e) {
  $("[data-toggle='item-cart']").each(function() {
    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $(".popover").has(e.target).length === 0) {
      $(this).popover("hide");
      $(this).popover("destroy");
    }
  });
});