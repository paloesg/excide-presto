function new_service(data) {
  $.ajax({
    url: "/admin/services",
    data: "name="+data.name+"&fields="+data.fields+"&taxon_ids="+data.taxon_ids+"&description="+data.description+"&meta_title="+data.meta_title+"&meta_keywords="+data.meta_keywords+"&meta_description="+data.meta_description,
    type:"post",
    success:function() {
      window.location.replace("/admin/services");
    },
    error:function( error ){ console.log(["error", error]); }
  });
}

function edit_service(data) {
  $.ajax({
    url: "/admin/services/"+data.id,
    data: "name="+data.name+"&fields="+data.fields+"&taxon_ids="+data.taxon_ids+"&description="+data.description+"&meta_title="+data.meta_title+"&meta_keywords="+data.meta_keywords+"&meta_description="+data.meta_description,
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
    data = {
      "name": $('#service_name').val(),
      "description": $('#service_description').val(),
      "taxon_ids": $(".taxon_ids").select2('val'),
      "fields": service_formbuilder.actions.getData('json', true),
      "meta_title": $('#service_meta_title').val(),
      "meta_keywords": $('#service_meta_keywords').val(),
      "meta_description": $('#service_meta_description').val(),
    }
    new_service(data);
  });

   $(document).on('click', '.btn-edit-service', function() {
    data = {
      "id": $('.id-edit-service').val(),
      "name": $('#service_name').val(),
      "description": $('#service_description').val(),
      "taxon_ids": $(".taxon_ids").select2('val'),
      "fields": service_formbuilder.actions.getData('json', true),
      "meta_title": $('#service_meta_title').val(),
      "meta_keywords": $('#service_meta_keywords').val(),
      "meta_description": $('#service_meta_description').val(),
    }
    edit_service(data);
  });
})