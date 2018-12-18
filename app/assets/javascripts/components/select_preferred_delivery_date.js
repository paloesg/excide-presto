$(function () {
  $('input[type=radio]').click(function () {
    $(this).closest('.preferred-delivery-date').addClass('active').siblings().removeClass('active');
  })
})