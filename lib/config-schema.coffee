module.exports =
  autoToggle:
    title: "autoToggle"
    description: "Enable to auto-toggle the package on loading."
    type: "boolean"
    default: true

  musicPlayer:
    type: "object"
    properties:
      path:
        title: "Music Player - Path to Songs"
        description: "Path to music tracks."
        type: "string"
        default: '../sounds/'

      volume:
        title: "Music Player - Volume"
        description: "Volume for music tracks."
        type: "integer"
        default: 50
        minimum: 0
        maximum: 100

      volumeChangeRate:
        title: "Music Player - Volume Change Rate"
        description: "Change rate for volume up and down commands."
        type: "integer"
        default: 10
        minimum: 1
        maximum: 100

  musicBox:
    type: "object"
    properties:
      remenberSong:
        title: "Music Box - Remenber Song"
        description: "Remenber which song was the last played."
        type: "boolean"
        default: true
        order: 1

      currentSong:
        title: "Music Box - Current Music"
        description: "Current song selected to be played"
        type: "string"
        default: ""
        order: 2

      remenberTime:
        title: "Music Box - Remenber Time"
        description: "Remenber time of the last sound played."
        type: "boolean"
        default: false
        order: 3

      time:
        title: "Music Box - Saved Time"
        description: "Time for last song was played."
        type: "integer"
        default: 0
        order: 4

      playList:
        title: "Music Box - Play List"
        description: "Indicate the order, that songs will be played.
        (let in blank to use the default or random order)"
        type: "array"
        default: []
        order: 5

      random:
        title: "Music Box - Play Randomly"
        description: "Make a random play list."
        type: "boolean"
        default: false

  remixer:
    type: "object"
    properties:
      enable:
        title: "Remixer - Enable"
        description: "Enable/disable the remixer."
        type: "boolean"
        default: false
        order: 1

      start:
        title: "Remixer - Starting Time"
        description: "Indicate the starting track time (in seconds).
        (let in blank to start at second 0)"
        type: "array"
        default: []

      end:
        title: "Remixer - Ending Time"
        description: "Indicate the time when next song will be played (in seconds).
        (let in blank or in 0 to play entire song)"
        type: "array"
        default: []

  visualEffects:
    type: "object"
    properties:
      enable:
        title: "Visual Effects - Enable"
        description: "Enable/disable the visual effects."
        type: "boolean"
        default: true
        order: 1

      random:
        title: "Visual Effects - Display Randomly"
        description: "Displays a random image for each song."
        type: "boolean"
        default: false
        order: 2

      path:
        title: "Visual Effects - Path to Images"
        description: "Path to music tracks."
        type: "string"
        default: '../images/'
        order: 3

      currentImage:
        title: "Visual Effects - Current Image"
        description: "Path to music tracks."
        type: "string"
        default: '1.jpg'
