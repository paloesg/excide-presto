function new_service(name, fields, taxon_ids) {
  $.ajax({
    url: "/admin/services",
    data: "name="+name+"&fields="+fields+"&taxon_ids="+taxon_ids,
    type:"post",
    success:function( data ) {
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

function edit_service(id, name, fields, taxon_ids) {
  $.ajax({
    url: "/admin/services/"+id,
    data: "name="+name+"&fields="+fields+"&taxon_ids="+taxon_ids,
    type:"put",
    success:function( data ) {
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

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

  $(document).on('click', '.btn-save-service', function() {
    var fields_service = service_formbuilder.actions.getData('json', true);
    var name_service = $('#service_name').val();
    var taxon_ids = $(".taxon_ids").select2('val');
    new_service(name_service, fields_service, taxon_ids);
  });

   $(document).on('click', '.btn-edit-service', function() {
    var fields_service = service_formbuilder.actions.getData('json', true);
    var id_service = $('.id-edit-service').val();
    var name_service = $('#service_name').val();
    var taxon_ids = $(".taxon_ids").select2('val');
    edit_service(id_service, name_service, fields_service, taxon_ids);
  });
})