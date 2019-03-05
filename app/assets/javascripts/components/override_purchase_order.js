function overridePurchaseOrder(this_element){
  console.log($(this_element)[0].files[0]);
  if (confirm('Are you sure you want to overwrite this purchase order file?')) {
    var formData = new FormData();
    formData.append('attachment', $(this_element)[0].files[0]); 
    console.log("formData", formData)
    $.ajax({
      url: '/orders/'+$(this_element).attr('order-number')+'/override_purchase_order',
      data: formData,
      type:'POST',
      contentType: false,
      processData: false,
      success:function( data ) {
        console.log(data)
      },
      error:function( result ){ console.log(["error", result]); }
    })
  } 
} 