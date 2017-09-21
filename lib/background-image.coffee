debounce = require "lodash.debounce"
path = require "path"
fs = require "fs"

module.exports =

  style: document.createElement 'style'
  bgImageRule: null
  backgroundImages: []

  setup: ->
    root = document.documentElement
    @style.type = 'text/css'
    document.querySelector('head atom-styles').appendChild @style

  desable: (state) ->
      document.querySelector('head atom-styles').removeChild @style

  setBackgroundImage: (backgroundImage) ->
        rule = "body:before{ background-image: url( #{backgroundImage} );}"
        if @bgImageRule isnt null
          @style.sheet.deleteRule(@bgImageRule)
        else
          @bgImageRule = @style.sheet.rules.length
        @style.sheet.insertRule(rule, @bgImageRule)

  #setBackgroundImage(atom.config.get('steam-pirate-ui.backgroundImage'))
