$(document).on('turbolinks:load', function(){
  $('[data-toggle="sub-categories"]').popover({
    trigger: "manual",
    html: true,
    container: 'body',
    animation: false,
    template: '<div class="popover sub-categories row"><h3 class="col-md-12"></h3><div class="popover-content row col-md-12"></div></div>'
  }).on('shown.bs.popover', function() {
    var this_popover = $($($(this).data("bs.popover").$tip).first());
    var currentTop = parseInt(this_popover.css('top'));
    var currentLeft = parseInt(this_popover.css('left'));
    var currentHeight = this_popover.height();
    this_popover.find('h3').text($(this).text());
    $('.sub-categories').css({
      top: (currentTop + (currentHeight / 2)) + 'px',
      left: (currentLeft - 10) + 'px',
      width: '450px',
      maxWidth: '450px',
      minHeight: '150px'
    });
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
    }, 500)
  })
})