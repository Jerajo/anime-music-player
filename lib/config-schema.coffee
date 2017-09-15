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
        title: "Music Player - Path to Audio"
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

      random:
        title: "Music Player - Play Randomly"
        description: "Make a random play list."
        type: "boolean"
        default: false

  musicBox:
    type: "object"
    properties:
      remenberSong:
        title: "Music Box - Remenber Song"
        description: "Remenber whith song was the last played."
        type: "boolean"
        default: true

      remenberTime:
        title: "Music Box - Remenber Time"
        description: "Remenber time of the last sound played."
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

      sequence:
        title: "Remixer - Tracks Sequence"
        description: "Indicate the track number sequence that will be played.
        <br/>(let in blank to use the default or random order)"
        type: "array"
        default: []
        order: 2

      start:
        title: "Remixer - Starting Time"
        description: "Indicate the starting track time (in seconds).
        <br/>(let in blank to start at second 0)"
        type: "array"
        default: []

      end:
        title: "Remixer - Ending Time"
        description: "Indicate the time when next song will be played (in seconds).
        <br/>(let in blank or in 0 to play entire song)"
        type: "array"
        default: []
