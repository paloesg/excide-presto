// Shipments AJAX API, refer from spree backend/shipments.js
$(document).ready(function () {
  // handle delivery click
  $('[data-hook=admin_shipment_form] a.delivered').on('click', function () {
    var link = $(this);
    var shipment_number = link.data('shipment-number');
    var url = Spree.url(Spree.routes.shipments_api + '/' + shipment_number + '/delivery.json');
    $.ajax({
      type: 'PUT',
      url: url,
      data: {
        token: Spree.api_key
      }
    }).done(function () {
      window.location.reload();
    }).error(function (msg) {
      console.log(msg);
    });
  });
})