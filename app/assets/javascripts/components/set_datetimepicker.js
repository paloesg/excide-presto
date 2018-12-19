$(function () {
  var date = new Date();
  date.setDate(date.getDate()+1);
  $('.cart-datetime-picker').datetimepicker( {
    stepping: 60,
    enabledHours: [9, 10, 11, 12, 13, 14, 15, 16, 17],
    format: 'DD-MM-YYYY HH:mm',
    minDate: date
  });
  $('.cart-datetime-picker').val('');
  $('.cart-datetime-picker').attr("placeholder","DD-MM-YYYY HH:MM");
});