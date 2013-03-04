function updateOutput() {
  var sourceEmbedCode = Wistia.EmbedCode.parse($("#source_embed_code").val());
  var outputEmbedCode = Wistia.EmbedCode.parse($("#source_embed_code").val());
  var isIframe = Wistia.EmbedCode.isIframe(sourceEmbedCode.toString());

  if (sourceEmbedCode && sourceEmbedCode.isValid()) {

    // Set custom options on the embed code.
    // CHANGE ME!!!
    outputEmbedCode.setOption("videoFoam", true);

    var embedCodeString = function() {
      if (isIframe) {
        return outputEmbedCode.toString() + "<script src='//fast.wistia.com/static/iframe-api-v1.js'></script>";
      } else {
        return outputEmbedCode.toString();
      }
    };

    function addResizableTo(elem) {
      elem
        .addClass('foamed')
        .draggable()
        .resizable();
    }

    // Display the output.
    $("#output_embed_code").val(embedCodeString);
    outputEmbedCode.previewInElem("preview");
    addResizableTo($("#draggable_wrapper"));
    $("#try").show();

  } else {

    // Show an error if invalid. We can be more specific 
    // if we expect a certain problem.
    $("#output_embed_code").val("Please enter a valid Wistia embed code.");
    $("#preview").html('<div id="placeholder_preview">Your video here</div>')
  }
}


// Updating is kind of a heavy operation; we don't want to 
// do it on every single keystroke.
var updateOutputTimeout;
function debounceUpdateOutput() {
  clearTimeout(updateOutputTimeout);
  updateOutputTimeout = setTimeout(updateOutput, 500);
}


// Assign all DOM bindings on doc-ready in here. We can also 
// run whatever initialization code we might need.
window.setupLabInterface = function($) {
  $(function() {
    // Update the output whenever a configuration input changes.
    $("#configure")
      .on("keyup", "input[type=text], textarea", debounceUpdateOutput)
      .on("change", "select", debounceUpdateOutput)
      .on("click", ":radio,:checkbox", debounceUpdateOutput);
  });
};
