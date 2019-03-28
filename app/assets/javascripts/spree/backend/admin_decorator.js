$(document).ready(function(){
  window.Spree.advanceOrder = function() {
    $.ajax({
      type: 'PUT',
      async: false,
      data: {
        token: Spree.api_key
      },
      url: Spree.url(Spree.routes.checkouts_api + '/' + order_number + '/advance'),
      error: function(xhr, status, error){
        var errorMessage = xhr.responseJSON.error
        alert(errorMessage);
      }
    }).done(function() {
      window.location.reload()
    })
  }
})