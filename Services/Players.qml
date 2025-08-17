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

  property real previousPosition
  property bool wasPlaying

  property real prevPosition // : player.position

  Connections {  
    target: player  
    function onPostTrackChanged() {
        lyricsTimer.running = true  
        Players.player.position = 0
      }  
    }

  property string trackLyrics

  Timer {
    id: lyricsTimer
    interval: 2000
    running: {
      //console.log("\"https://lrclib.net/api/get?artist_name=" + player.trackArtist.replace(/ /g, "+").replace(/ä/g, "%C3%A4").replace(/'/g, "%27") + "&track_name=" + player.trackTitle.replace(/ /g, "+").replace(/ä/g, "%C3%A4").replace(/'/g, "%27") + "&album_name=" + player.trackAlbum.replace(/ /g, "+").replace(/ä/g, "%C3%A4").replace(/'/g, "%27") + "&duration=" + player.length + "\"")
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
        trackLyrics = text
      }
    }
  }

  FrameAnimation {
    running: player.playbackState == MprisPlaybackState.Playing

    onTriggered: {
      player.positionChanged()
    }
  }

  //FrameAnimation {
  //  running: true

  //  onTriggered: {
  //    if (wasPlaying == true && player.isPlaying == false && player.position >= 1) {
  //      console.log("paused")
  //      previousPosition = player.position
  //    } else if (wasPlaying == false && player.isPlaying == true && previousPosition >= 1) {
  //      console.log("unpaused")
  //      player.position = previousPosition
  //    }
  //    wasPlaying = player.isPlaying
  //  }
  //}
}