function getDepartments(company){
  $.ajax({
    url : "/admin/companies/"+company+"/get_departments",
    type:'GET',
    success:function( data ) {
      var departments = data; // assuming list object
      if ( typeof(data) == "string"){ // but if string
        departments = JSON.parse( data );
      }
      $("select[department]").empty();
      $("select[department]").select2({
        include_blank: "None"
      });
      $("select[department]").append($("<option></option>", {"text": "None"}));
      $.each(departments, function(index, department){
        $("select[department]").append($("<option></option>", {"value": department.id, "text": department.name}));
      })
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function(){
  departments = $("select[department]").html()
  company_id = $("select[company]").val()
  if(company_id){
    $(".checkbox_input[company="+company_id+"]").show()
  }
  else {
    $("#role").hide();
  }
  $("select[company]").on('change', function () {
    var val = this.value;
    if (val){
      getDepartments(val);
      $("#role").show();
      $(".checkbox_input[company="+val+"]").show()
      $(".checkbox_input:not([company="+val+"])").hide()
    }
    else {
      $("select[department]").empty();
      $("select[department]").select2({
        include_blank: false
      });
    }
  });
})