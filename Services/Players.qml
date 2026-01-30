// Players.qml
pragma Singleton

import QtQuick
import QtQml
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "../Scripts/httpRequest.js" as HTTPR

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

  property bool ytDlpAvailable: false

  readonly property var playerToSwitchTo: {
    var playingPlayers = []
    for (var i = 0; i < players.length; i++) {
      if (players[i].isPlaying == true) {
        playingPlayers.push(i)
      }
    }
    if (playingPlayers.length == 1) {
      if (playingPlayers[0] != playerId) {
        players[playingPlayers[0]]
      }
    } else {
      null
    }
  }

  property bool tempDisableSwitchSuggestion: false

  onPlayerIdChanged: {
    reloadLyrics()
    tempDisableSwitchSuggestion = false
  }

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
    lyricsTimer.running = false
    lyricsTimer.running = true
    gettingLyrics = false
    defaultLyrics = 1
    currentTry = 1
    areLyricsCustom = false

    ytTranscriptProc.running = true

    lyricsChanged()

    //console.log("reload lyrics")
  }

  function loadCustomLyrics(data) {
    customLyrics = data
    areLyricsCustom = true

    lyricsChanged()
  }

  property var trackLyrics: areLyricsCustom ? customLyrics : defaultLyrics
  property var defaultLyrics: 1
  property var customLyrics: 1

  property var ytTranscript: JSON.parse(ytTranscriptProc.text())

  onYtTranscriptChanged: console.log(ytTranscript)

  readonly property int maxTries: 5
  property int currentTry: 1

  property bool gettingLyrics: false

  onGettingLyricsChanged: {
    if (gettingLyrics) {
      HTTPR.sendRequest("https://lrclib.net/api/get?artist_name=" + encodeURI(player.trackArtist) + 
                        "&track_name=" + encodeURI(player.trackTitle) + 
                        "&album_name=" + encodeURI(player.trackAlbum) + 
                        "&duration=" + player.length, 
      function(response) {
        if (gettingLyrics) {
          gettingLyrics = false
          if (JSON.parse(response.content).statusCode) {
            if (currentTry < maxTries) {
              lyricsTimer.running = true
              currentTry += 1
            } else {
              defaultLyrics = 404
            }
          } else {
            defaultLyrics = JSON.parse(response.content)
          }
        }
      })
    }
  }

  Timer {
    id: lyricsTimer
    interval: 100
    running: true
    onTriggered: {
      gettingLyrics = true
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

  Process {
    id: ytTranscriptProc
    running: false
    command: {
      [ "yt-dlp", "--no-write-auto-subs", "--write-subs", "--sub-format=json3", "--skip-download", "-o " + Quickshell.shelldir + "/.cache/yt-transcript", player.metadata["xesam:url"].toString() ]
    }
    stderr: StdioCollector {
      onStreamFinished: {
        console.log(this.text)
        console.log("yt-dlp finished")
      }
    }
  }

  FileView {
    id: configFile
    path: Quickshell.shellPath("/.cache/yt-transcript.en.json3")
    blockLoading: true

    watchChanges: true
    onFileChanged: {
      this.reload()
    }

    onLoadFailed: (error) => {
      if (error == FileViewError.FileNotFound) {
        ytTranscriptProc.running = true
        console.log(player.metadata.value("xesam:url").toString())
        console.log("yt-dlp --no-write-auto-subs --write-subs --sub-format=json3 --skip-download -o " + Quickshell.shelldir + "/.cache/yt-transcript " + player.metadata.value("xesam:url").toString())
      }
    }
  }
}