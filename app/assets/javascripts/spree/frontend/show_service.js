/*global setDatetimepickerFormat*/
/*eslint no-undef: "error"*/

function showServiceForm(url, fields) {
  //Render form
  var formData = fields;
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
  var markup = $("<div/>");
  markup.formRender({ formData });
  var formService = markup.formRender("html");

  $( ".form-service" ).empty();
  $( ".form-service" ).append( formService );
  setDatetimepickerFormat();
}