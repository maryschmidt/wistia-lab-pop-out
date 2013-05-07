((W) ->

  bindEvent = (elem, event, fn) -> elem.addEventListener event, fn, false

  W.plugin "pop-out", (video, options = {}) ->

    popped_out = false
    popOut = ->
      popped_out = true
      child_window = window.open()

    bindEvent document.getElementById("pop-out-button"), "click", popOut

)(Wistia)
