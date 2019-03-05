function showService() {
  $('.loader').hide();
  $('.modal-content').show();

  $('#formContent').on('hidden.bs.modal', function (e) {
    $('.loader').show();
    $('.modal-content').hide();
  })
}