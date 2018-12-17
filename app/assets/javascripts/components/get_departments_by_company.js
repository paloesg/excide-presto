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
  $("#user_company_id").on('change', function () {
    var val = this.value;
    if (val){
      getDepartments(val);
    }
    else {
      $('#user_department_id').empty();
      $("#user_department_id").select2({
        include_blank: false
      });
    }
  });
})