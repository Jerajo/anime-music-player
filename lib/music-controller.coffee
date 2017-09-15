{CompositeDisposable} = require "atom"
musicPlayer = require "./music-player"

module.exports =
  musicPlayer: musicPlayer
  conf: []

  distroy: ->
    @volumeChangeRateObserver?.dispose()
    @subscriptions.dispose()
    @musicPlayer.disable()
    @conf = []

  setup: ->
    @musicPlayer.setup()
    @addCommands()
    @volumeChangeRateObserver = atom.config.observe "anime-music-player.musicPlayer.volumeChangeRate", (value) =>
        @conf['volumeChangeRate'] = value

  playPause: ->
    return @musicPlayer.play() if not @musicPlayer.music['isPlaying']
    return @musicPlayer.pause()

  stop: ->
    @musicPlayer.stop() if @musicPlayer.music['isPlaying']

  repeat: ->
    @musicPlayer.repeat()

  next: ->
    @musicPlayer.next()

  previous: ->
    @musicPlayer.previous()

  volumeUpDown: (action) ->
    volumeChange = @conf['volumeChangeRate']
    volumeChange *= -1 if action is "down"
    @musicPlayer.volumeUpDown(volumeChange)

  muteToggle: ->
    @musicPlayer.mute()

  addCommands: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:play/pause": => @playPause()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:stop": => @stop()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:repeat": => @repeat()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:next": => @next()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:previous": => @previous()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:volumeUp": => @volumeUpDown("up")
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:volumeDown": => @volumeUpDown("down")
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:mute-toggle": => @muteToggle()
