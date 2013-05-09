((W) ->

  bindEvent = (elem, event, fn) -> elem.addEventListener event, fn, false

  W.plugin "custom-play-button", (video, options = {}) ->

    button_url = options.buttonUrl || null
    controls_visible = video.options.controlsVisibleOnLoad
    console.log(controls_visible)
    image = new Image

    image.onload = ->
      image.className = "play-button"
      image.style.position = "absolute"
      buttonPosition = options.buttonPosition || "center"
      switch buttonPosition
        when "center"
          video.grid.top_inside.appendChild(image);
          logoWidth = Wistia.util.elemWidth(image)
          logoHeight = Wistia.util.elemHeight(image)
          image.style.top = "#{(wistiaEmbed.height() - logoHeight)/2}px"
          image.style.left = "#{(wistiaEmbed.width() - logoWidth)/2}px"
        when "top left"
          image.style.top = "20px"
          image.style.left = "20px"
          video.grid.top_inside.appendChild(image);
        when "top right"
          image.style.top = "20px"
          image.style.right = "20px"
          video.grid.top_inside.appendChild(image);
        when "bottom left"
          if controls_visible = true
            image.style.bottom = "52px"
            image.style.left = "20px"
          else
            image.style.bottom = "20px"
            image.style.left = "20px"
          video.grid.bottom_inside.appendChild(image);
        when "bottom right"
          if controls_visible = true
            image.style.bottom = "52px"
            image.style.right = "20px"
          else
            image.style.bottom = "20px"
            image.style.right = "20px"
          video.grid.bottom_inside.appendChild(image);

    image.src=button_url

    bindEvent image, "click", video.play()

    styleElem = W.util.addInlineCss document.body, """
      .play-button {
      height: 100px;
      opacity: 0.75;
      }

      .hidden {
      display: none;
      }
    """

    wistiaEmbed.bind("play", ->
      image.className = "hidden"
      @unbind
    )

    if video.options.endVideoBehavior == "reset"
      wistiaEmbed.bind("end", ->
        image.className = "play-button"
        @unbind
      )

)(Wistia)
