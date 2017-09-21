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
  songNumber: 0

  disable: ->
    if !@music['isRandom'] and @obs.conf['remenberTime']
      @setConfig "musicBox.time", @music['file'].currentTime
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
    @songNumber = 0

  setup: ->
    @obs.setup()
    @music['isMute'] = false
    @music['isPlaying'] = false

    @currentSongObserver = atom.config.observe 'anime-music-player.musicBox.currentSong', (currentSong) =>
      @songName = currentSong

    @randomObserver = atom.config.observe 'anime-music-player.musicBox.random', (value) =>
      @music['isRandom'] = value
      if @musicFiles.length > 0
        @songNumber = 0 if @music['isRandom']
        @randomPlayList()

    @sequenceObserver = atom.config.observe 'anime-music-player.musicBox.playList', (playList) =>
      @sequence = playList
      if @musicFiles.length > 0
        @userPlayList()
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
        console.log @musicFiles
        if @music['isRandom']
          @randomPlayList()
        else if @sequence.length > 0
          @userPlayList()
        else
          @playList = @musicFiles
          console.error "using defalutPlayList"
          @setSongNumber() if @obs.conf['remenberSong']
        console.log @playList
        @setMusic()
      else
        @musicFiles = null
        console.error  "Error!: The folder doesn't exist or doesn't contain audio files!."
        @setConfig("musicPlayer.musicPath","../sounds/musics/")

    if !@music['isRandom'] and @obs.conf['remenberTime']
      @music['file'].currentTime = @getConfig "musicBox.time"

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

  setSongNumber: ->
    return @songNumber = 0 if @songName is ""
    for number, song of @musicFiles
      console.log number + " | " + song
      return @songNumber = parseInt(number) if song is @songName
    atom.notifications.addError "Song didn't found"
    @setConfig "musicBox.currentSong", ""
    @songNumber = 0

  userPlayList: ->
    console.error "using userPlayList"
    @playList = []
    error = ""
    for index, trackNumber of @sequence
      if trackNumber < 0 or trackNumber > @musicFiles.length-1
        error += "The track #{trackNumber} is out of range.\n"
        @sequence.splice(index, 1)
    if error != ""
      error += "Out of range. Has to be >= 0 and >= #{@musicFiles.length-1}"
      atom.notifications.addError error
      @setConfig "musicBox.playList", @sequence
    for index, track of @sequence
      @playList[index] = @musicFiles[track]

  randomPlayList: ->
    console.error "using randomPlayList"
    i = @musicFiles.length
    while i
      j = Math.floor(Math.random() * i)
      [c = list[i], list[i] = list[j], list[j] = c]
      [t = @musicFiles[i], @musicFiles[i] = @musicFiles[j], @musicFiles[j] = t, i--]
    console.log list
    @setConfig "musicBox.playList", list

  setMusic: ->
    console.log "Ahy #{@playList.length-1} cansiones en el playList"
    console.log "cansion #" + @songNumber
    console.log @musicFiles[@songNumber]

    return @changeMusic(1) if @musicFiles[@songNumber] is undefined
    isPlaying = @music['isPlaying']
    @music['file'].pause() if @music['file'] != undefined and isPlaying
    @music['file'] = new Audio(@music['path'] + @musicFiles[@songNumber])
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
    previus = @songNumber
    @songNumber = @songNumber + nextIndex
    maxIndex = @playList.length - 1
    @songNumber = 0 if @songNumber > maxIndex
    @songNumber = maxIndex if @songNumber < 0
    console.log @songNumber + " | " + nextIndex + " | " + previus + " | " + maxIndex
    @setConfig "musicBox.currentSong", @playList[@songNumber]
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
