function update_role(userId, companyId, departmentId, isManager) {
  $.ajax({
    url: "/admin/users/"+userId+"/update/role",
    data: "company_id="+companyId+"&department_id="+departmentId+"&type_manager="+isManager,
    type:"put",
    success:function( data ) {

    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).ready(function(){
  $('.role-check').on("change", function() {
    var $userId = $(this).closest(".role-form").find(".user-id");
    var $companyId = $(this).closest(".role-form").find(".company-id");
    var $departmentId = $(this).closest(".role-form").find(".department-id");
    if($(this).is(":checked")) {
      update_role($userId.val(), $companyId.val(), $departmentId.val(), "set_manager");
    } else {
      update_role($userId.val(), $companyId.val(), $departmentId.val(), "unset_manager");
    }
  })
})