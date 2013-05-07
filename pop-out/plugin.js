Wistia.plugin("pop-out", function(video, options) {
  console.log("initializing pop-out plugin for", video.hashedId());
  console.log("options are", options);
  video.ready(function() {
    console.log(video.name(), "is ready");
  });
});
