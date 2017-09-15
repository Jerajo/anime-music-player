{CompositeDisposable} = require "atom"

configSchema = require "./config-schema"
musicPlayer = require "./music-controller"

module.exports = animeMusicPlayer =
  active: false
  config: configSchema
  musicPlayer: musicPlayer
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace",
      "anime-music-player:toggle": => @toggle()

    @toggle() if atom.config.get "anime-music-player:autoToggle"

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
