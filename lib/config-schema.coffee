module.exports =
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

  musicBox:
    type: "object"
    properties:
      remenberSound:
        title: "Music Box - Remenber Sound"
        description: "Remenber whith sound was the last played."
        type: "boolean"
        default: true

      remenberTime:
        title: "Music Box - Remenber Time"
        description: "Remenber time of the last sound played."
        type: "boolean"
        default: false

      remixer:
        title: "Music Box - Remixer"
        description: "Indicate the track number, the starting time and the ending time (in seconds) to make a remix. Note: The values has to be inside of the paramiters."
        type: "array"
        default: []
