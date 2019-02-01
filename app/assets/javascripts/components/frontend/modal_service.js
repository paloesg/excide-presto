function showServiceForm(url, fields) {
  //Render form
  formData = fields;
  //Change field name
  for (var i in formData) {
    if (formData[i].type == "file") {
      formData[i].name = "fields[file]["+formData[i].name+"]";
    }
    else {
      formData[i].name = "fields[text]["+formData[i].name+"]";
    }
  }

  addLineBreaks = html => html.replace(new RegExp("><", "g"), ">\n<");
  markup = $("<div/>");
  markup.formRender({ formData });
  form_service = markup.formRender("html");

  // Load Product Content
  $("#modalContent").load(window.location.origin +'/'+ url, function() {
    // Load Js for switching the service main image by hovering the thumbnails
    var thumbnails = $("#service-images").next();
    ($("#main-image")).data("selectedThumb", ($("#main-image img")).attr("src"));
    thumbnails.find("li").eq(0).addClass("selected");
    thumbnails.find("a").on("click", function (event) {
      ($("#main-image")).data("selectedThumb", ($(event.currentTarget)).attr("href"));
      ($("#main-image")).data("selectedThumbId", ($(event.currentTarget)).parent().attr("id"));
      thumbnails.find("li").removeClass("selected");
      ($(event.currentTarget)).parent("li").addClass("selected");
      return false;
    });
    thumbnails.find("li").on("mouseenter", function (event) {
      return ($("#main-image img")).attr("src", ($(event.currentTarget)).find("a").attr("href"));
    });
    thumbnails.find("li").on("mouseleave", function (event) {
      return ($("#main-image img")).attr("src", ($("#main-image")).data("selectedThumb"));
    });
    $( ".form_service" ).append( form_service );
  });
  $('#serviceContent').on('hidden.bs.modal', function (e) {
    $('#serviceContent').find('.modal-body').html('<div class="col-xs-offset-5"><div class="loader"></div></div>');
  })
}
