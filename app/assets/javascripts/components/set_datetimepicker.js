$(document).on('turbolinks:load', function () {
  var date = new Date();
  date.setDate(date.getDate()+7);
  $('.cart-datetime-picker').datetimepicker( {
    stepping: 60,
    enabledHours: [9, 10, 11, 12, 13, 14, 15, 16, 17],
    format: 'DD-MM-YYYY',
    minDate: date
  });
  $('.cart-datetime-picker').val('');
  $('.cart-datetime-picker').attr("placeholder","DD-MM-YYYY");
  $('.weekday-datetime-picker').datetimepicker( {
    format: 'DD-MM-YYYY',
    daysOfWeekDisabled: [0, 6]
  })
});