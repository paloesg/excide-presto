$(document).on('turbolinks:load', function () {
  var tomorrow = new Date();
  var nextWeek = new Date();
  tomorrow.setDate(tomorrow.getDate()+1);
  nextWeek.setDate(nextWeek.getDate()+7);

  $('.cart-datetime-picker').datetimepicker( {
    stepping: 60,
    enabledHours: [9, 10, 11, 12, 13, 14, 15, 16, 17],
    format: 'DD-MM-YYYY',
    minDate: nextWeek
  });
  $('.cart-datetime-picker').val('');
  $('.cart-datetime-picker').attr("placeholder","DD-MM-YYYY");
  $('.weekday-datetime-picker').datetimepicker( {
    minDate: tomorrow,
    format: 'DD-MM-YYYY HH:mm',
    daysOfWeekDisabled: [0, 6],
    enabledHours: [9, 10, 11, 12, 13, 14, 15, 16, 17],
  })

  $('.datetime-picker').datetimepicker( {
    format: 'DD-MM-YYYY',
    minDate: moment()
  });
  $('.datetime-picker').attr("placeholder","DD-MM-YYYY");
});