// Players.qml
pragma Singleton

import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
  id: root

  property int playerId: {
    if (customPlayerId > (players.length - 1)) {
      0 //players.length - 1
    } else {
      customPlayerId
    }
  }
  property int customPlayerId: 0
  property real pausedTime: 0.0
  readonly property var players: Mpris.players.values
  readonly property MprisPlayer player: players[playerId]

  property int customLyricsId
  property bool areLyricsCustom: false

  property real previousPosition
  property bool wasPlaying

  onPlayerIdChanged: reloadLyrics()

  signal lyricsChanged()

  Connections {  
    target: player  
    function onPostTrackChanged() {
      reloadLyrics() 

      if (Config.media.playback.resetPositionOnTrackChange.value) {
        player.position = 0
      }

      //console.log("track changed")
    }  
  }
  
  function reloadLyrics() {
    lyricsTimer.running = true
    lyricsProc.running = false
    defaultLyrics = 1
    currentTry = 1
    areLyricsCustom = false

    lyricsChanged()

    //console.log("reload lyrics")
  }

  function loadCustomLyrics(id) {
    customLyricsId = id
    customLyricsProc.running = true
    customLyrics = 1
    areLyricsCustom = true

    lyricsChanged()
  }

  property var trackLyrics: areLyricsCustom ? customLyrics : defaultLyrics
  property var defaultLyrics: 1
  property var customLyrics: 1

  readonly property int maxTries: 5
  property int currentTry: 1

  Timer {
    id: lyricsTimer
    interval: 100
    running: {
      //console.log("https://lrclib.net/api/get?artist_name=" + encodeURI(player.trackArtist) + "&track_name=" + encodeURI(player.trackTitle) + "&album_name=" + encodeURI(player.trackAlbum) + "&duration=" + player.length)
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
        //console.log(text)
        if (JSON.parse(text).statusCode) {
          if (currentTry < maxTries) {
            lyricsTimer.running = true
            currentTry += 1
          } else {
            defaultLyrics = 404
          }
          //console.log("lyrics failed")
        } else {
          defaultLyrics = JSON.parse(text)
        }
      }
    }
  }

  Process {
    id: customLyricsProc
    running: false
    command: [ "curl", "https://lrclib.net/api/get/" + customLyricsId ]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        customLyrics = JSON.parse(text)
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
      /*if (wasPlaying == false && player.isPlaying && previousPosition >= 0.5 && trackLyrics.plainLyrics) {
        player.position = previousPosition
      } else if (!player.isPlaying && player.position >= 0.5 && trackLyrics.plainLyrics) {
        previousPosition = player.position
      }*/ // YT (or Firefox idk) made an update that makes this unnecessary
      wasPlaying = player.isPlaying
    }
  }
}