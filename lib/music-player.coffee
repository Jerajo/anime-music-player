debounce = require "lodash.debounce"
path = require "path"
fs = require "fs"

module.exports =
  audio: null
  music: []
  musicFiles: []
  currentMusic: 0

  disable: ->
    @stop() if @music['isPlaying']
    @musicVolumeObserver?.dispose()
    @musicPathObserver?.dispose()
    @music = null
    @musicFiles = null
    @currentMusic = 0

  setup: ->
    @music['isMute'] = false
    @music['isPlaying'] = false

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'anime-music-player.musicPlayer.volume', (volume) =>
      @music['volume'] = (volume * 0.01)
      @music['file'].volume = @music['volume'] if @music['file'] != undefined

    @musicPathObserver?.dispose()
    @musicPathObserver = atom.config.observe 'anime-music-player.musicPlayer.path', (value) =>
      mPath = value
      if mPath is "../sounds/"
        @music['path'] = path.join(__dirname, mPath)
      else
        if mPath[mPath.length-1] != '/' or mPath[mPath.length-1] != '\\'
          @music['path'] = mPath + '\\'
        else if mPath[mPath.length-1] is '/'
          @music['path'] = mPath.replace('/','\\')
        else @music['path'] = mPath

      if fs.existsSync(@music['path'])
        @musicFiles = @getAudioFiles()
        @currentMusic = 0
        @setMusic()
      else
        @musicFiles = null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("musicPath","../sounds/musics/")

  getAudioFiles: ->
    allFiles = fs.readdirSync(@music['path'])
    file = 0
    while(allFiles[file])
      fileName = allFiles[file++]
      fileExtencion = fileName.split('.').pop()
      continue if(fileExtencion is "mp3") or (fileExtencion is "MP3")
      continue if(fileExtencion is "wav") or (fileExtencion is "WAV")
      continue if(fileExtencion is "3gp") or (fileExtencion is "3GP")
      continue if(fileExtencion is "m4a") or (fileExtencion is "M4A")
      continue if(fileExtencion is "webm") or (fileExtencion is "WEBM")
      allFiles.splice(--file, 1)
      break if file is allFiles.length

    return if (allFiles.length > 0) then allFiles else null

  setMusic: ->
    @music['file'].pause() if @music['file'] != undefined and @music['isPlaying']
    @music['file'] = new Audio(@music['path'] + @musicFiles[@currentMusic])
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']
    @music['file'].onended = =>
      @next()

  play: ->
    return null if !@music['file'].paused
    @music['file'].play()
    @music['isPlaying'] = true

  pause: ->
    @music['file'].pause()
    @music['isPlaying'] = false

  stop: ->
    @music['file'].pause()
    @music['isPlaying'] = false
    @music['file'].currentTime = 0

  repeat: ->
    isPlaying = @music['isPlaying']
    @stop()
    @autoPlay() if isPlaying

  autoPlay: ->
    @music['file'].play()
    @music['isPlaying'] = true

  previous: ->
    @changeMusic(-1)

  next: ->
    @changeMusic(1)


  changeMusic: (nextIndex) ->
    isPlaying = @music['isPlaying']
    maxIndex = @musicFiles.length - 1
    @currentMusic = @currentMusic + nextIndex
    @currentMusic = 0 if @currentMusic > maxIndex
    @currentMusic = maxIndex if @currentMusic < 0

    @setMusic()
    @autoPlay() if isPlaying


  volumeUpDown: (volumeChange) ->
    volume = (@music['volume'] * 100)
    @music['isMute'] = false
    haschanged = false
    volume += volumeChange
    volume = 0 if volume < 0
    volume = 100 if volume > 100
    return if volume is (@music['volume'] * 100)
    @setConfig("volume", volume)

  mute: ->
    @music['isMute'] = !@music['isMute']
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']

  remixer: ->
    value = atom.config.get "anime-music-player.musicBox.remixer"
    console.log value

  setConfig: (config, value) ->
    atom.config.set("anime-music-player.musicPlayer.#{config}", value)
