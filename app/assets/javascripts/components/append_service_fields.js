function add_service(name, fields) {
  $.ajax({
    url: "/admin/services",
    data: "name="+name+"&fields=["+fields+"]",
    type:"post",
    success:function( data ) {
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

function edit_service(id, name, fields) {
  $.ajax({
    url: "/admin/services/"+id,
    data: "name="+name+"&fields=["+fields+"]",
    type:"put",
    success:function( data ) {
      window.location.replace("/admin/services");
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function() {
  $("#add").click(function() {
    var last_field = $("#service_form div:last");
    var intId = (last_field && last_field.length && last_field.data("idx") + 1) || 1;
    var field_wrapper = $('<div class= "field_wrapper" id="field'+intId+'">');
    field_wrapper.data("idx", intId);
    var field_name = $('<input type="text" class="fieldname form-service">')
    var field_type = $('<select class="fieldtype form-service"><option value="text">text</option><option value="number">number</option><option value="file">file</option></select>')
    var remove_button = $('<input type="button" class="remove btn btn-danger" value="x">')
    remove_button.click(function() {
      $(this).parent().remove();
    });
    field_wrapper.append(field_name);
    field_wrapper.append(field_type);
    field_wrapper.append(remove_button);
    $("#service_form").append(field_wrapper);
  });

  $('#save_service').click(function() {
    var field_arr = [];
    $("#service_form div").each(function() {
      var type_field = $(this).find("select.fieldtype").first().val();
      var name_field = $(this).find("input.fieldname").first().val();
      var field = '{"input_type":"'+type_field+'", "input_name":"'+name_field+'"}';
      field_arr.push(field);
    });
    var service_name = $("#name").val();
    var service_field = field_arr;
    add_service(service_name, service_field);
  });

  $('#save_edit_service').click(function() {
    var field_arr = [];
    $("#service_form div").each(function() {
      var type_field = $(this).find("select.fieldtype").first().val();
      var name_field = $(this).find("input.fieldname").first().val();
      var field = '{"input_type":"'+type_field+'", "input_name":"'+name_field+'"}';
      field_arr.push(field);
    });
    var service_id = $("#service_id").val();
    var service_name = $("#name").val();
    var service_field = field_arr;
    edit_service(service_id, service_name, service_field);
  });
});