Wistia.plugin "googleAnalytics", (video, options = {}) ->

  # Define a way to get the percent watched of a video.
  buckets = []
  percentWatched = ->
    watched = 0
    for bucket in buckets
      watched += 1 if bucket
    watched / buckets.length
  video.ready ->
    buckets.push(false) for i in [0..Math.floor(video.duration())]
  video.bind "secondchange", (s) ->
    buckets[s] = true


  # Push an event to google analytics using their _gaq handle.
  pushEvent = (name, val) ->
    if !window._gaq
      console?.log "Could not send data to google analytics because _gaq is not defined."
      return
    else
      _gaq.push(['_trackEvent', 'Video', name, val])

  
  # Trigger events so we can 
  for triggerPercent in [.25, .5, .75, 1]
    ((triggerPercent) ->
      video.bind "secondchange", (s) ->
        percent = percentWatched()
        if buckets.length > 0 and percent >= triggerPercent
          pushEvent "#{Math.round(triggerPercent * 100)} Watched", video.name()
          video.trigger "pushedtogoogleanalytics", "percentwatched", triggerPercent
          return @unbind
    )(triggerPercent)

  video.bind "secondchange", (s) ->
    if buckets.length > 0
      video.trigger "percentwatched", percentWatched()
    else
      video.trigger "percentwatched", 0


  # Trigger the play event.
  video.bind "play", ->
    pushEvent "Play", video.name()
    video.trigger "pushedtogoogleanalytics", "play"
    @unbind

  return {
    buckets: buckets
    percentWatched: percentWatched
    pushEvent: pushEvent
  }
