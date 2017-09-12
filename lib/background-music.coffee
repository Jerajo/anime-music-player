musicPlayer = require "./music-player"

module.exports =
  musicPlayer: musicPlayer
  conf: []

  distroy: ->
    @musicPlayer.disable()
    @volumeChangeRateObserver?.dispose()
    @conf = null

  setup: ->
    @musicPlayer.setup()
    @musicPlayer.remixer()
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
