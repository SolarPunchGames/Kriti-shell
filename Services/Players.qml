// Audio.qml
pragma Singleton

import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
  id: root

  property int playerId: 0
  property real pausedTime: 0.0
  readonly property MprisPlayer player: Mpris.players.values[playerId]

//  readonly property bool isYtMusic: {
//    if (player.metadata) {
//      console.log("url: " + player.metadata.xesam)
//      false
//    }
//    false
//  }

  property real previousPosition
  property bool wasPlaying

  Connections {  
    target: player  
    function onPostTrackChanged() {
        lyricsTimer.running = true
        lyricsProc.running = false
        trackLyrics = 1
        Players.player.position = 0
        console.log("track changed")
      }  
    }

  property var trackLyrics: 1

  Timer {
    id: lyricsTimer
    interval: 500
    running: {
      console.log("https://lrclib.net/api/get?artist_name=" + encodeURI(player.trackArtist) + "&track_name=" + encodeURI(player.trackTitle) + "&album_name=" + encodeURI(player.trackAlbum) + "&duration=" + player.length)
      true
    }
    onTriggered: {
      lyricsProc.running = true
    }
  }

  Process {
    id: lyricsProc
    running: false
    command: [ "curl", "https://lrclib.net/api/get?artist_name=" + encodeURI(player.trackArtist) + "&track_name=" + encodeURI(player.trackTitle) + "&album_name=" + encodeURI(player.trackAlbum) + "&duration=" + player.length]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        console.log(text)
        if (JSON.parse(text).statusCode) {
          trackLyrics = 404
          console.log("lyrics failed")
        } else {
          trackLyrics = JSON.parse(text)
        }
      }
    }
  }

  FrameAnimation {
    running: player.playbackState == MprisPlaybackState.Playing

    onTriggered: {
      player.positionChanged()
    }
  }

  FrameAnimation {
    running: true
    onTriggered: {
      if (wasPlaying == true && player.isPlaying == false && player.position >= 1 && trackLyrics.plainLyrics) {
        previousPosition = player.position
      } else if (wasPlaying == false && player.isPlaying == true && previousPosition >= 1 && trackLyrics.plainLyrics) {
        player.position = previousPosition
      }
      wasPlaying = player.isPlaying
    }
  }
}