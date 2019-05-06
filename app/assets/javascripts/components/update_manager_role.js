function update_role(user_id, company_id, department_id, is_manager) {
  $.ajax({
    url: "/admin/users/"+user_id+"/update/role",
    data: "company_id="+company_id+"&department_id="+department_id+"&type_manager="+is_manager,
    type:"put",
    success:function( data ) {

    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function(){
  $('.role-check').on("change", function() {
    var $user_id = $(this).closest('.role-form').find('.user-id');
    var $company_id = $(this).closest('.role-form').find('.company-id');
    var $department_id = $(this).closest('.role-form').find('.department-id');
    if($(this).is(":checked")) {
      update_role($user_id.val(), $company_id.val(), $department_id.val(), "set_manager");
    } else {
      update_role($user_id.val(), $company_id.val(), $department_id.val(), "unset_manager");
    }
  })
})