var reloadWithTurbolinks = (function () {
  var scrollPosition

  document.addEventListener('turbolinks:load', function () {
    if (scrollPosition) {
      window.scrollTo.apply(window, scrollPosition)
      scrollPosition = null
    }
  }, false)

  function reload () {
    scrollPosition = [window.scrollX, window.scrollY]
    Turbolinks.visit(window.location, { action: 'replace' })
  }

  return reload
})()

function update_quantity(variant_id, quantity) {
  $.ajax({
    url: "/orders/populate",
    data: "quantity="+quantity+"&variant_id="+variant_id,
    type:"post",
    success:function( data ) {
      console.log("success");
      reloadWithTurbolinks();
    },
    error:function( result ){ console.log(["error", result]); }
  });
}

$(document).on('turbolinks:load', function (){
  $(".plus").click(function(){
    var variant = $(this).attr('id').replace('button_plus', 'variant');
    var variant_id = $('#'+variant).val();
    update_quantity(variant_id, 1);
  })

  $(".min").click(function(){
    var variant = $(this).attr('id').replace('button_min', 'variant');
    var variant_id = $('#'+variant).val();
    update_quantity(variant_id, -1);
  })
})