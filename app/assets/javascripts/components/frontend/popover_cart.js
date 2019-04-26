function popoverContent(content){
  $("[data-toggle='item-cart']").popover({
    html: true,
    content
  });
  $("[data-toggle='item-cart']").popover("show");
  setTimeout(function () {
    $("[data-toggle='item-cart']").popover("hide");
    $("[data-toggle='item-cart']").popover("destroy");
  }, 5000);
}