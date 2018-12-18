function getDepartments(company){
  $.ajax({
    url : "/admin/companies/"+company+"/get_departments",
    type:'GET',
    success:function( data ) {
      var departments = data; // assuming list object
      if ( typeof(data) == "string"){ // but if string
        departments = JSON.parse( data );
      }
      $("#user_department_id").empty();
      $("#user_department_id").select2({
        include_blank: false
      });
      $.each(departments, function(index,department){
        $("#user_department_id").append($("<option></option>", {"value":department.id, "text":department.name}));
      })
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function(){
  departments = $('#user_department_id').html()
  company_id = $("#company_id").val()
  if(company_id){
    $(".checkbox_input[company="+company_id+"]").show()
  }
  else {
    $("#role").hide();
  }
  $("#user_company_id").on('change', function () {
    var val = this.value;
    var user_id = $("#user_id").val();
    if (val){
      getDepartments(val);
      $("#role").show();
      $(".checkbox_input[company="+val+"]").show()
      $(".checkbox_input:not([company="+val+"])").hide()
    }
    else {
      $('#user_department_id').empty();
      $("#user_department_id").select2({
        include_blank: false
      });
    }
  });
})