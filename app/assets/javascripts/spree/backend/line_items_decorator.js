function adjustLineItem (lineItemId, quantity) {
  $.ajax({
    type: 'PUT',
    url: Spree.url(lineItemURL(lineItemId)),
    data: {
      line_item: {
        quantity: quantity
      },
      token: Spree.api_key
    },
    error: function(xhr, status, error){
      var errorMessage = xhr.responseJSON.errors ? xhr.responseJSON.errors.quantity[0] : xhr.responseJSON.error
      alert(errorMessage);
    }
  }).done(function () {
    window.Spree.advanceOrder()
  })
}