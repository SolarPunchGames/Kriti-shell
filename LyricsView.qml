// LyricsView.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Services

ListView {
  id: lyricsView
  anchors.fill: parent

  topMargin: {
//    if (Players.areLyricsCustom) {
//      100
//    } else {
      40
//    }
  }
  bottomMargin: 20

  maximumFlickVelocity: 2000

  //highlightMoveDuration: 500
  //highlightMoveVelocity: -1
  highlightRangeMode: ListView.ApplyRange

  currentIndex: -1

  cacheBuffer: 1000000

  property var lyricsSizeMult: 1
  property var synced: true

  Component.onCompleted: forceLayout()

//  Column {
//    id: customLyricsColumn
//    anchors.top: parent.top
//    topPadding: 20
//
//    Text {
//      id: customLyricsText
//
//      font.pointSize: 8
//      font.family: Config.style.font.value
//
//      width: lyricsRect.width - lyricsView.rightMargin - lyricsView.leftMargin
//      height: 30 * lineCount
//
//      bottomPadding: -20
//
//      wrapMode: Text.WordWrap
//
//      horizontalAlignment: Text.AlignHCenter
//      verticalAlignment: Text.AlignVCenter
//
//      color: Colors.text
//
//      visible: Players.areLyricsCustom
//
//      text: "Custom Lyrics:"
//    }
//
//    Text {
//      id: customLyricsTitle
//
//      font.weight: 800
//
//      font.pointSize: 12
//      font.family: Config.style.font.value
//
//      width: lyricsRect.width - lyricsView.rightMargin - lyricsView.leftMargin
//      height: 30 * lineCount
//
//      wrapMode: Text.WordWrap
//
//      horizontalAlignment: Text.AlignHCenter
//      verticalAlignment: Text.AlignVCenter
//
//      color: Colors.text
//
//      visible: Players.areLyricsCustom
//
//      text: Players.trackLyrics.name
//    }
//  }

  Text {
    id: lyricsLoadingText
    anchors.fill: parent

    font.weight: 800
    
    text: "Lyrics not found"

    font.pointSize: 15
    font.family: Config.style.font.value

    width: lyricsRect.width - lyricsView.rightMargin - lyricsView.leftMargin
    height: 30 * lineCount

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    color: Colors.text

    visible: Players.trackLyrics == 404 ? true : false
  }

  LoadingDots {
    id: lyricsLoadingDots
    anchors.fill: parent
    running: Players.trackLyrics == 1 ? true : false
  }

  Component {
    id: highlight
    Rectangle {
      id: highlightRect

      width: lyricsView.currentItem.contentWidth + 40 * lyricsView.lyricsSizeMult
      height: lyricsView.currentItem.height

      anchors.horizontalCenter: parent.horizontalCenter
      color: {
        if (Players.player.isPlaying) {
          Colors.itemHoveredBackground
        } else {
          "transparent"
        }
      }

      border.color: {
        if (Players.player.isPlaying) {
          Colors.itemPressedBackground
        } else {
          Colors.separator
        }
      }
      border.width: 1

      radius: 10 * lyricsSizeMult

      y: lyricsView.currentItem.y

      opacity: lyricsView.currentItem.contentWidth != 0 && Config.media.lyrics.highlightRectangle.value ? 1 : 0

      Behavior on color {
        PropertyAnimation {
          duration: 100;
        }
      }

      Behavior on border.color {
        PropertyAnimation {
          duration: 100;
        }
      }

      Behavior on opacity {
        PropertyAnimation {
          duration: 250;
        }
      }

      Behavior on y {
        SpringAnimation {
          spring: 5
          damping: 0.4
        }
      }
      Behavior on width {
        SpringAnimation { 
          spring: 3
          damping: 0.26
        }
      }
      Behavior on height {
        SpringAnimation { 
          spring: 3
          damping: 0.3
        }
      }
    }
  }

  highlight: highlight
  highlightFollowsCurrentItem: false

  preferredHighlightBegin: height / 5 * 2
  preferredHighlightEnd: height / 5 * 2

  property alias lyricsListAlias: lyricsList

  model: ListModel {
    id: lyricsList
  }

//  add: Transition {
//    id: lyricAddTrans
//    SequentialAnimation {
//      PropertyAnimation { properties: "x"; to: 1000; duration: 0 }
//      PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
//      PropertyAnimation { 
//        properties: "x"
//        from: 20
//        to: 0
//        duration: 250
//        easing.type: Easing.OutCubic
//      }
//    }
//    //SequentialAnimation {
//    //  PropertyAnimation { properties: "opacity"; to: 0; duration: 0 }
//    //  PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
//    //  PropertyAnimation { 
//    //    properties: "opacity"; 
//    //    to: 0.5
//    //    duration: 250;
//    //  }
//    //}
//  }

  Connections {  
    target: Players
    function onLyricsChanged() {  
      lyricsView.reload()
    }
  }

  function reload(delay = 100) {
    showLyricsTimer.interval = delay
    lyricsList.clear()
    lyricsView.currentIndex = -1
    showLyricsTimer.running = true
  }

  Timer {
    id: showLyricsTimer
    interval: 100
    running: true

    onTriggered: {
      if (Players.trackLyrics.plainLyrics) {

        if (Players.trackLyrics.syncedLyrics && synced == true) {
          var syncedLyrics = Players.trackLyrics.syncedLyrics;
          var lines = syncedLyrics.split("\n");
          for (var i = 0; i < lines.length; i++) {
            if (lines[i + 1]) {
              var nextTime = 60 * parseFloat(lines[i + 1].substring(1,3)) + parseFloat(lines[i + 1].substring(4,9))
            } else {
              var nextTime = 0
            }

            if (lines[i].substring(10, 11) == " ") {
              var lyricText = lines[i].substring(11)
            } else {
              var lyricText = lines[i].substring(10)
            }

            lyricsList.append({ 
              "lyricText": lyricText, 
              "time": 60 * parseFloat(lines[i].substring(1,3)) + parseFloat(lines[i].substring(4,9)), 
              "index": i, 
              "nextTime": nextTime
            });;
          }

        } else {
          var plainLyrics = Players.trackLyrics.plainLyrics
          var lines = plainLyrics.split("\n");
          for (var i = 0; i < lines.length; i++) {
            lyricsList.append({ 
              "lyricText": lines[i], 
              "time": 0, 
              "index": i,
              "nextTime": 0
            })
          }
        }

      } else if (Players.ytTranscript) {
        console.log(JSON.stringify(Players.ytTranscript))
        console.log("yt transcript found")
      } else if (Players.trackLyrics == 1) {
        showLyricsTimer.running = true
      }
      lyricsView.forceLayout()
    }
  }

  delegate: Text {
    id: lyric
    required property string lyricText
    required property real time
    required property real nextTime
    required property int  index

    property bool isEmpty: lyricText == ""

    property var isCurrentItem: ListView.isCurrentItem

    font.weight: 300

    font.pointSize: 10 * lyricsView.lyricsSizeMult
    font.family: Config.style.font.value

    width: lyricsView.width
    height: contentHeight + 20 * lyricsView.lyricsSizeMult

    leftPadding: 30 / lyricsView.lyricsSizeMult * 2
    rightPadding: 30 / lyricsView.lyricsSizeMult * 2

    wrapMode: Text.WordWrap

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    color: Colors.text

    text: {
      if (isEmpty) {
        Config.media.lyrics.characterBetween.choices[Config.media.lyrics.characterBetween.value]
      } else {
        lyricText
      }
    }

    state: {
      if (index == lyricsView.currentIndex) {
        "highlighted"
      } else if (index < lyricsView.currentIndex) {
        "faded"
      } else {
        ""
      }
    }

    states: [ 
      State {
        name: "highlighted"

        PropertyChanges {target: lyric; scale: 1.1}
        PropertyChanges {target: lyric; font.weight: 800}
      },
      State {
        name: "faded"

        PropertyChanges {target: lyric; scale: 0.9}
        PropertyChanges {target: lyric; font.weight: 300}
        PropertyChanges {target: lyric; opacity: 0.5}
      }
    ]

    transitions: Transition {
      PropertyAnimation {
        property: "scale"
        duration: 250
        easing.type: Easing.InOutCubic
      }
      PropertyAnimation {
        property: "font.weight"
        duration: 250
        easing.type: Easing.InOutCubic
      }
    }

    Timer {
      running: true
      interval: 10
      repeat: true
      
      onTriggered: {
        if (time) {
          if ((Players.player.position >= time && Players.player.position <= nextTime - 0.1) || (nextTime == 0 && Players.player.position >= time && Players.player.position <= time + 1)) {
            lyricsView.currentIndex = index
          } else if (Players.player.position < time - 0.1 && index == 0) {
            lyricsView.currentIndex = -1
          }
        } 
      }
    }

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

      cursorShape: {
        if (time) {
          Qt.PointingHandCursor
        }
      }

      onClicked: (mouse)=> {
        if (time && mouse.button != Qt.MiddleButton) {
          Players.previousPosition = time
          Players.player.position = time
          lyricsView.currentIndex = index
          if (mouse.button == Qt.RightButton) {
            Players.player.isPlaying = true
          }
        }
        if (mouse.button == Qt.MiddleButton) {
          Quickshell.clipboardText = parent.text
        }
      }
    }
  }
}
