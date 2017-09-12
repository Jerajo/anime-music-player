{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
musicPlayer = require "./background-music"

module.exports = animeMusicPlayer =

  config: configSchema
  active: false
  musicPlayer: musicPlayer
  subscriptions: null

  activate: (state) ->
    console.log "Mi paquete se activa XD"
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:toggle": => @toggle()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:play/pause": => @musicPlayer.playPause()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:stop": => @musicPlayer.stop()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:repeat": => @musicPlayer.repeat()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:next": => @musicPlayer.next()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:previous": => @musicPlayer.previous()
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:volumeUp": => @musicPlayer.volumeUpDown("up")
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:volumeDown": => @musicPlayer.volumeUpDown("down")
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:mute-toggle": => @musicPlayer.muteToggle()
    @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @desable()

  enable: ->
    @active = true
    @musicPlayer.setup()

  desable: ->
    @active = false
    @musicPlayer.distroy()

  toggle: ->
    if @active then @desable() else @enable()
