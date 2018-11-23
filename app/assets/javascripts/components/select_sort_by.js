$(document).on('turbolinks:load', function () {
  $('select#sort_by').on('change', function() {
    Turbolinks.visit('//' + location.host + location.pathname + this.value);
  })
})