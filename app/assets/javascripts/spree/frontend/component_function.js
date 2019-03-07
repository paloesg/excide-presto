function set_datetimepicker_format(){
  $('.datetime-picker').datetimepicker( {
    format: 'DD-MM-YYYY HH:mm',
    minDate: moment()
  });
  $('.datetime-picker').attr("placeholder","DD-MM-YYYY HH:mm");

  $('.time-picker').datetimepicker( {
    format: 'HH:mm',
    minDate: moment()
  });
  $('.time-picker').attr("placeholder","HH:mm");

  $('.date-picker').datetimepicker( {
    format: 'DD-MM-YYYY',
    minDate: moment()
  });
  $('.date-picker').attr("placeholder","DD-MM-YYYY");
}