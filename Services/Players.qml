// Audio.qml
pragma Singleton

import QtQuick
import QtQml
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  property int playerId: 0
  property real pausedTime: 0.0
  readonly property MprisPlayer player: Mpris.players.values[playerId]

  property real prevPosition // : player.position

  FrameAnimation {
    running: player.playbackState == MprisPlaybackState.Playing

    onTriggered: {
      player.positionChanged()
    }
  }

  Timer {
    running: true //player.playbackState == MprisPlaybackState.Playing
    interval: 10
    repeat: true

    onTriggered: {
      if (prevPosition > (player.position + 1) || prevPosition < (player.position - 1)) {
        pausedTime = 0
      }
    }
  }

  Timer {
    running: true //player.playbackState == MprisPlaybackState.Playing
    interval: 20
    repeat: true

    onTriggered: {
      prevPosition = player.position
    }
  }

  Timer {
    running: player.playbackState == MprisPlaybackState.Paused
    interval: 100
    repeat: true

    onTriggered: pausedTime += 0.1
  }
}