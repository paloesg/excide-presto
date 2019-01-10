$(document).on('click', '.decrease-quantity,.increase-quantity', function() {
  var qty = $(this).closest('.number-quantity').find('.line_item_quantity'),
    current_val = parseInt(qty.val()),
    is_add = $(this).hasClass('increase-quantity');
  if(is_add){
    qty.val(current_val + 1);
  }
  else {
    if (current_val - 1 != -1) {
      qty.val(current_val - 1);
    }
  }
});