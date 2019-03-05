function new_service(data) {
  $.ajax({
    url: "/admin/services",
    enctype: 'multipart/form-data',
    data: data,
    processData: false,
    contentType: false,
    type:"post",
    success:function() {
      window.location.replace("/admin/services");
    },
    error:function( error ){ console.log(["error", error]); }
  });
}

function edit_service(id, data) {
  $.ajax({
    url: "/admin/services/"+id,
    enctype: 'multipart/form-data',
    data: data,
    processData: false,
    contentType: false,
    type:"put",
    success:function() {
      window.location.replace("/admin/services");
    },
    error:function( error ){ console.log(["error", error]); }
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
    form_data = new FormData();
    service_icon = $('#service_icon')[0].files[0];
    if (service_icon){
      form_data.append( 'icon', service_icon );
    }
    form_data.append( 'name', $('#service_name').val() );
    form_data.append( 'description', $('#service_description').val() );
    form_data.append( 'taxon_ids', $(".taxon_ids").select2('val') );
    form_data.append( 'fields', service_formbuilder.actions.getData('json', true) );
    form_data.append( 'meta_title', $('#service_meta_title').val() );
    form_data.append( 'meta_keywords', $('#service_meta_keywords').val() );
    form_data.append( 'meta_description', $('#service_meta_description').val() );

    new_service(form_data);
  });

   $(document).on('click', '.btn-edit-service', function() {
    form_data = new FormData();
    service_icon = $('#service_icon')[0].files[0];
    if (service_icon){
      form_data.append( 'icon', service_icon );
    }
    form_data.append( 'name', $('#service_name').val() );
    form_data.append( 'description', $('#service_description').val() );
    form_data.append( 'taxon_ids', $(".taxon_ids").select2('val') );
    form_data.append( 'fields', service_formbuilder.actions.getData('json', true) );
    form_data.append( 'meta_title', $('#service_meta_title').val() );
    form_data.append( 'meta_keywords', $('#service_meta_keywords').val() );
    form_data.append( 'meta_description', $('#service_meta_description').val() );

    edit_service($('.id-edit-service').val(), form_data);
  });
})