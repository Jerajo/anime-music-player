debounce = require "lodash.debounce"
path = require "path"
fs = require "fs"
observer = require './config-observer'

module.exports =
  obs: observer
  audio: null
  music: []
  musicFiles: []
  playList: []
  sequence: []
  currentMusic: 0

  disable: ->
    @remenberSong()
    @obs.destroy()
    @pause() if @music['isPlaying']
    @musicVolumeObserver?.dispose()
    @musicPathObserver?.dispose()
    @sequenceObserver?.dispose()
    @randomObserver?.dispose()
    @music = []
    @musicFiles = []
    @playList = []
    @sequence = []
    @currentMusic = 0

  remenberSong: ->
    @setConfig "musicBox.currentMusic", @currentMusic if @obs.conf['remenberSong']
    @setConfig "musicBox.time", @music['file'].currentTime if @obs.conf['remenberTime']

  setup: ->
    @obs.setup()
    @music['isMute'] = false
    @music['isPlaying'] = false

    if @obs.conf['remenberSong'] and (value = @getConfig "musicBox.currentMusic") != undefined
      @currentMusic = value

    @randomObserver = atom.config.observe 'anime-music-player.musicPlayer.random', (value) =>
      @music['isRandom'] = value
      if @musicFiles.length > 0
        @currentMusic = 0 if @music['isRandom']
        @remixer()
        @setMusic()

    @sequenceObserver = atom.config.observe 'anime-music-player.remixer.sequence', (sequence) =>
      @sequence = sequence
      if @musicFiles.length > 0 and @sequence.length is 0
        @remixer()
        return @setMusic()
      if @musicFiles.length > 0
        for index, trackNumber of sequence
          if trackNumber < 0 or trackNumber > @musicFiles.length-1
            sequence.splice(index, 1)
            error = true
        if error?
          console.error("Out of range. Has to be >= 0 and >= " + @musicFiles.length-1)
          return @setConfig "remixer.sequence", sequence
        @remixer()
        @setMusic()

    @musicVolumeObserver?.dispose()
    @musicVolumeObserver = atom.config.observe 'anime-music-player.musicPlayer.volume', (volume) =>
      @music['volume'] = (volume * 0.01)
      @music['file'].volume = @music['volume'] if @music['file'] != undefined

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
        @remixer() if @sequence.length > 0
        @setMusic()
      else
        @musicFiles = null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("musicPlayer.musicPath","../sounds/musics/")

    if @obs.conf['remenberTime'] and !@music['isRandom'] and (value = @getConfig "musicBox.time") != undefined
      @music['file'].currentTime = value

  getAudioFiles: ->
    allFiles = fs.readdirSync(@music['path'])
    for index, file of allFiles
      continue if @checkFile(file.split('.').pop())
      allFiles.splice(index, 1)

    return if (allFiles.length > 0) then allFiles else null

  checkFile: (fileExtencion) ->
    return true if(fileExtencion is "mp3") or (fileExtencion is "MP3")
    return true if(fileExtencion is "wav") or (fileExtencion is "WAV")
    return true if(fileExtencion is "3gp") or (fileExtencion is "3GP")
    return true if(fileExtencion is "m4a") or (fileExtencion is "M4A")
    return true if(fileExtencion is "webm") or (fileExtencion is "WEBM")
    return false

  remixer: ->
    @pause() if @music['isPlaying']
    return @userPlayList() if @sequence.length > 0
    console.log "Lista Ordenada"
    console.log @musicFiles
    return @playList = @shuffle(@musicFiles) if @music['isRandom']
    @playList = @musicFiles

  userPlayList: ->
    @playList = []
    for index, track of @sequence
      @playList[index] = @musicFiles[track]

    console.log "userPlayList"
    console.log @playList

  shuffle: (a) ->
    console.log "Lista Random"
    i = a.length
    while i
      j = Math.floor(Math.random() * i)
      [t = a[i], a[i] = a[j], a[j] = t, i--]

    console.log a
    return a

  setMusic: ->
    isPlaying = @music['isPlaying']
    maxIndex = @playList.length - 1
    @currentMusic = maxIndex if @currentMusic > maxIndex
    @currentMusic = 0 if @currentMusic < 0

    @music['file'].pause() if @music['file'] != undefined and isPlaying
    console.log "cansion #" + @currentMusic
    console.log @music['path'] + @playList[@currentMusic]
    @music['file'] = new Audio(@music['path'] + @playList[@currentMusic])
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']
    @music['file'].autoplay = true if isPlaying
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
    if @music['isPlaying']
      @pause()
      @play()
    else @music['file'].currentTime = 0

  previous: ->
    @changeMusic(-1)

  next: ->
    @changeMusic(1)

  changeMusic: (nextIndex) ->
    isPlaying = @music['isPlaying']
    @currentMusic = @currentMusic + nextIndex
    @setMusic()

  volumeUpDown: (volumeChange) ->
    volume = (@music['volume'] * 100)
    @music['isMute'] = false
    haschanged = false
    volume += volumeChange
    volume = 0 if volume < 0
    volume = 100 if volume > 100
    return if volume is (@music['volume'] * 100)
    @setConfig("musicPlayer.volume", volume)

  mute: ->
    @music['isMute'] = !@music['isMute']
    @music['file'].volume = if @music['isMute'] then 0 else @music['volume']

  getConfig: (config) ->
    atom.config.get("anime-music-player.#{config}")

  setConfig: (config, value) ->
    atom.config.set("anime-music-player.#{config}", value)
