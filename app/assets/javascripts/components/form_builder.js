function new_service(name, fields) {
  $.ajax({
    url: "/admin/services",
    data: "name="+name+"&fields="+fields,
    type:"post",
    success:function( data ) {
      console.log("success")
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

function edit_service(id, name, fields) {
  $.ajax({
    url: "/admin/services/"+id,
    data: "name="+name+"&fields="+fields,
    type:"put",
    success:function( data ) {
      console.log("success")
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function() {
  var new_service_form = $('.new-field-service-form').formBuilder();

  //form edit service
  var service_fields = $('.service-fields').val();
  if (service_fields){
    var options = {
      formData: service_fields,
      dataType: 'json'
    };
    var edit_service_form = $('.edit-field-service-form').formBuilder(options);
  }

  $(document).on('click', '.btn-save-service', function() {
    var fields_service = new_service_form.actions.getData('json', true);
    var name_service = $('.name-service').val();
    new_service(name_service, fields_service);
  });

  $(document).on('click', '.btn-edit-service', function() {
    var fields_service = edit_service_form.actions.getData('json', true);
    var id_service = $('.id-edit-service').val();
    var name_service = $('.name-edit-service').val();
    edit_service(id_service, name_service, fields_service);
  });
})

