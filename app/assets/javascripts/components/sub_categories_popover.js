$(document).on('turbolinks:load', function(){
  $('[data-toggle="sub-categories"]').popover({
    trigger: "manual",
    html: true,
    container: 'body',
    animation: false,
    template: '<div class="popover sub-categories row"><h3 class="col-md-12 title p-l-0 p-b-10"></h3><div class="popover-content row col-md-12"></div></div>'
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
  }).on('show.bs.popover', function () {
    // Close all others popover before current popover show
    $('.popover').popover('hide');
    // Clear timeout to prevent delay on mouseleave from closing new popover
    if (typeof closeOnLeave !== 'undefined') {
      clearTimeout(closeOnLeave)
    }
  }).on("mouseenter", function () {
    // Show current popover
    $(this).popover("show");
    $('.popover').on('mouseleave', function() {
      $(this).popover("hide");
    })
  }).on("mouseleave", function () {
    // Close popover if not mouse hovering the trigger (Categories) or popover after delay
    closeOnLeave = setTimeout(function () {
      if (!$(".popover:hover").length) {
        $('.popover').popover("hide");
      }
    }, 500)
  })
})