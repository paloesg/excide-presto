$(document).on('turbolinks:load', function () {
  $('select#sort-by').on('change', function() {
    Turbolinks.visit('//' + location.host + location.pathname + this.value);
  })
})