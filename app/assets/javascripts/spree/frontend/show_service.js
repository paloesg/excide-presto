function showServiceForm(url, fields) {
  //Render form
  formData = fields;
  //Change field name
  for (var i in formData) {
    if (formData[i].type == "file") {
      formData[i].name = "fields[file]["+formData[i].label+"]";
    }
    else {
      formData[i].name = "fields[text]["+formData[i].label+"]";
    }
  }

  addLineBreaks = html => html.replace(new RegExp("><", "g"), ">\n<");
  markup = $("<div/>");
  markup.formRender({ formData });
  form_service = markup.formRender("html");

  $( ".form-service" ).empty();
  $( ".form-service" ).append( form_service );
  set_datetimepicker_format();
}