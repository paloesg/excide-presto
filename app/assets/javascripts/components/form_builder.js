$(document).ready(function() {
  var service_fields = $('.service-fields').val();
  if (service_fields){
    var options = {
      formData: service_fields,
      dataType: 'json'
    };
    var service_formbuilder = $('.service-formbuilder').formBuilder(options);
  }
  else {
    var service_formbuilder = $('.service-formbuilder').formBuilder();
  }

  $(".edit_form_service").submit( function() {
    $('<input />').attr('type', 'hidden')
        .attr('name', "service[fields]")
        .attr('value', service_formbuilder.actions.getData('json', true))
        .appendTo('.edit_form_service');
    return true;
  });

  $(".new_form_service").submit( function() {
    $('<input />').attr('type', 'hidden')
        .attr('name', "service[fields]")
        .attr('value', service_formbuilder.actions.getData('json', true))
        .appendTo('.new_form_service');
    return true;
  });
});