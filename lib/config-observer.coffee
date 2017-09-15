{CompositeDisposable} = require "atom"

module.exports =
  startingTime: []
  endingTime: []
  conf: []
  subscriptions: null

  setup: ->
    @subscriptions = new CompositeDisposable
    @observe "remenberSong"
    @observe "remenberTime"

    @startingTimeObserver = atom.config.observe "anime-music-player.remixer.start", (value) =>
      @startingTime = value

    @endingTimeObserver = atom.config.observe "anime-music-player.remixer.end", (value) =>
      @endingTime = value

  destroy: ->
    @startingTimeObserver?.dispose()
    @endingTimeObserver?.dispose()
    @subscriptions?.dispose()
    @conf = []

  observe: (key) ->
    @subscriptions.add atom.config.observe(
      "anime-music-player.musicBox.#{key}", (value) =>
        @conf[key] = value
    )
