function showProduct(url) {
  // Load Product Content
  $("#modalContent").load(window.location.origin +'/'+ url, function(response, status, xhr) {
    if (status == "success") {
      $('.loader').hide();
      $('.modal-content').show();
    }
    // Load Js for switching the product main image by hovering the thumbnails
    var thumbnails = $("#product-images").next();
    ($("#main-image")).data("selectedThumb", ($("#main-image img")).attr("src"));
    thumbnails.find("li").eq(0).addClass("selected");
    thumbnails.find("a").on("click", function (event) {
      ($("#main-image")).data("selectedThumb", ($(event.currentTarget)).attr("href"));
      ($("#main-image")).data("selectedThumbId", ($(event.currentTarget)).parent().attr("id"));
      thumbnails.find("li").removeClass("selected");
      ($(event.currentTarget)).parent("li").addClass("selected");
      return false;
    });
    thumbnails.find("li").on("mouseenter", function (event) {
      return ($("#main-image img")).attr("src", ($(event.currentTarget)).find("a").attr("href"));
    });
    thumbnails.find("li").on("mouseleave", function (event) {
      return ($("#main-image img")).attr("src", ($("#main-image")).data("selectedThumb"));
    });
  });
  $('#productContent').on('hidden.bs.modal', function (e) {
    $('.loader').show();
    $('.modal-content').hide();
    $('#productContent').find('.modal-body').html('<div class="col-xs-offset-5"><div class="loader"></div></div>');
  })
}
