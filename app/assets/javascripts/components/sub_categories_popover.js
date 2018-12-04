$(document).on('turbolinks:load', function(){
  $('[data-toggle="popover"]').popover({
    trigger: "manual",
    html: true,
    container: 'body',
    animation: false,
    template: '<div class="popover sub-categories"><div class="popover-content"></div></div>'
  }).on("mouseenter", function () {
    var _this = this;
    $(this).popover("show");
    $(".popover").on("mouseleave", function () {
      $(_this).popover('hide');
    });
  }).on("mouseleave", function () {
    var _this = this;
    setTimeout(function () {
      if (!$(".popover:hover").length) {
        $(_this).popover("hide");
      }
    }, 30)
  })
})