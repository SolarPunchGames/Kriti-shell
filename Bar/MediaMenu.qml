// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import qs.Services
import ".."

Scope {
  property alias powerMenuVariants: variants
  
  Variants {
    id: variants
    model: Quickshell.screens

    ScalePanelWindow {
      id: window

      property var modelData
      screen: modelData

      scaleItemAlias: scaleItem
      mainPanelAlias: mainPanel

      Timer {
        running: true
        interval: 100
        repeat: true

        onTriggered: {
          if (!Players.player) {
            console.log("closed")
            window.close()
          }
        }
      }

      PanelScaleItem {
        id: scaleItem

        anchors.fill: parent

        transformOrigin: Item.Top

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.right: mainPanel.left
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
        }

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.left: mainPanel.right
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: -90
        }

        Rectangle {
          id: mainPanel

          width: mainRow.width
          height: 400

          color: Colors.mainPanelBackground

          bottomLeftRadius: 13
          bottomRightRadius: bottomLeftRadius

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top

          layer.enabled: true

          Row {
            id: mainRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 5

            padding: 5

            width: children.width

            Rectangle {
              id: mediaRect

              implicitWidth: mediaColumn.width + 10
              implicitHeight: parent.height - 10

              color: Colors.itemBackground

              radius: 10

              ColumnLayout {
                id: mediaColumn
                spacing: 5

                anchors.horizontalCenter: parent.horizontalCenter

                y: 5
                
                Item {
                  id: imgItem
                  Layout.preferredWidth: 270
                  Layout.preferredHeight: width

                  Layout.alignment: Qt.AlignHCenter

                  RoundedImage {
                    id: img
                    source: Players.player.trackArtUrl

                    fillMode: Image.PreserveAspectCrop

                    anchors.fill: parent

                    radius: 7
                  }

                  BaseButton {
                    id: lyricsButton

                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 5
                    anchors.rightMargin: 5

                    backgroundAlias.radius: 5

                    width: textAlias.contentWidth + 15
                    height: width

                    textAlias.rightPadding: 5
                    text: ""

                    onClicked: {
                      lyricsRect.toggleOpen()
                    }
                  }

                  //ComboBox {
                  //  anchors.left: parent.left
                  //  anchors.top: parent.top
//
                  //  anchors.leftMargin: 5
                  //  anchors.topMargin: 5
//
                  //  width: 200
                  //  height: 30
//
                  //  model: Players.players
//
                  //  background: Rectangle {
                  //    radius: 5
//
                  //    color: Colors.itemBackground
//
                  //    opacity: 0.5
                  //  }
                  //}
                }

                Text {
                  text: TextServices.truncate(Players.player.trackTitle, 26)

                  Layout.preferredWidth: parent.width

                  horizontalAlignment: Text.AlignHCenter

                  font.pointSize: 11
                  font.family: "JetBrainsMono Nerd Font"

                  color: Colors.text
                }
                Text {
                  text: TextServices.truncate(Players.player.trackArtist, 20) + " - " + TextServices.secondsToMinutesSeconds(Math.round(Players.player.position)) + "/" + TextServices.secondsToMinutesSeconds(Players.player.length)

                  Layout.preferredWidth: parent.width
                  
                  horizontalAlignment: Text.AlignHCenter

                  font.pointSize: 8
                  font.family: "JetBrainsMono Nerd Font"

                  color: Colors.text
                }

                Row {
                  id: buttonRow
                  spacing: 5

                  Layout.alignment: Qt.AlignHCenter

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: ""

                    onClicked: Players.player.previous()
                  }

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: {
                      if (Players.player.isPlaying){
                        ""
                      } else {
                        ""
                      }
                    }

                    onClicked: Players.player.togglePlaying()
                  }

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: ""

                    onClicked: Players.player.next()
                  }
                }
              }
            }

            Rectangle {
              id: lyricsRect
              implicitWidth: closed ? 0 : mediaRect.width
              implicitHeight: parent.height - 10

              Behavior on implicitWidth {
                SpringAnimation {
                  spring: 10
                  damping: 0.6
                }
              }

              radius: 10

              function toggleOpen() {
                if (closed) {
                  closed = false
                  Players.lyricsChanged()
                } else {
                  closed = true
                  lyricsList.clear()
                }
              }

              property bool closed: false

              color: Colors.itemBackground

              clip: true

              Text {
                id: lyricsLoadingText

                anchors.fill: lyricsRect

                state: "loading"

                states: [ 
                  State {
                    name: "loading"

                    PropertyChanges {target: lyricsLoadingText; text: "Loading lyrics..."}
                  },
                  State {
                    name: "failed"

                    PropertyChanges {target: lyricsLoadingText; text: "Lyrics not found"}
                  }
                ]

                font.weight: 800

                font.pointSize:15
                font.family: "JetBrainsMono Nerd Font"

                width: lyricsRect.width - lyricsView.rightMargin - lyricsView.leftMargin
                height: 30 * lineCount

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                color: Colors.text
              }

              Component {
                id: highlight
                Rectangle {
                  id: highlightRect

                  width: lyricsView.currentItem.contentWidth + 40
                  height: lyricsView.currentItem.height

                  anchors.horizontalCenter: parent.horizontalCenter
                  color: {
                    if (Players.player.isPlaying) {
                      Colors.itemHoveredBackground
                    } else {
                      Colors.separator
                    }
                  } 

                  radius: 10

                  y: lyricsView.currentItem.y

                  opacity: lyricsView.currentItem.contentWidth == 0 || !Config.media.lyrics.highlightRectangle.value ? 0 : 1

                  Behavior on color {
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

              ListView {
                id: lyricsView
                anchors.fill: parent

                topMargin: 20
                bottomMargin: 20

                maximumFlickVelocity: 2000

                //highlightMoveDuration: 500
                //highlightMoveVelocity: -1
                highlightRangeMode: ListView.ApplyRange

                currentIndex: -1

                cacheBuffer: 1000

                highlight: highlight
                highlightFollowsCurrentItem: false

                preferredHighlightBegin: height / 2
                preferredHighlightEnd: height / 2

                model: ListModel {
                  id: lyricsList
                }

                add: Transition {
                  id: lyricAddTrans
                  SequentialAnimation {
                    PropertyAnimation { properties: "x"; to: 1000; duration: 0 }
                    PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
                    PropertyAnimation { 
                      properties: "x"
                      from: 100
                      to: 0
                      duration: 250
                      easing.type: Easing.OutCubic
                    }
                  }
                  //SequentialAnimation {
                  //  id: lyricOpacityAnim
                  //  PropertyAnimation { properties: "opacity"; to: 0; duration: 0 }
                  //  PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
                  //  PropertyAnimation { 
                  //    properties: "opacity"; 
                  //    to: lyricOpacityAnim.prevOpacity
                  //    duration: 250;
                  //  }
                  //}
                }

                Connections {  
                  target: Players
                  function onLyricsChanged() {  
                    lyricsList.clear()
                    lyricsView.currentIndex = -1
                    showLyricsTimer.running = true
                    lyricsLoadingText.visible = true
                    lyricsLoadingText.state = "loading"
                  }  
                }

                Timer {
                  id: showLyricsTimer
                  interval: 100
                  running: true

                  onTriggered: {

                    if (Players.trackLyrics.plainLyrics) {

                      lyricsLoadingText.visible = false


                      if (Players.trackLyrics.syncedLyrics) {
                        var syncedLyrics = Players.trackLyrics.syncedLyrics;
                        var lines = syncedLyrics.split("\n");
                        for (var i = 0; i < lines.length; i++) {
                          if (lines[i + 1]) {
                            var nextTime = 60 * parseFloat(lines[i + 1].substring(1,3)) + parseFloat(lines[i + 1].substring(4,9))
                          } else {
                            var nextTime = 0
                          }

                          lyricsList.append({ 
                            "lyricText": lines[i].substring(11), 
                            "time": 60 * parseFloat(lines[i].substring(1,3)) + parseFloat(lines[i].substring(4,9)), 
                            "index": i, 
                            "nextTime": nextTime
                          });;


//                        console.log("lyricText: " + lines[i].substring(11))
//                        console.log("time: " + 60 * parseFloat(lines[i].substring(1,3)) + parseFloat(lines[i].substring(4,9)))
//                        console.log("index: " + i)
//                        console.log("nextTime: " + nextTime)
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
                    } else if (Players.trackLyrics == 1) {
                      showLyricsTimer.running = true
                    } else if (Players.trackLyrics == 404) {
                      lyricsLoadingText.state = "failed"
                    }
                  }
                }

                delegate: Text {
                  id: lyric
                  required property string lyricText
                  required property real time
                  required property real nextTime
                  required property int  index

                  property bool isEmpty: lyricText == ""

                  text: {
                    if (isEmpty) {
                      Config.media.lyrics.characterBetween.choices[Config.media.lyrics.characterBetween.value]
                    } else {
                      lyricText
                    }
                  }

                  property var isCurrentItem: ListView.isCurrentItem

                  state: {
                    if (index == lyricsView.currentIndex) {
                      "highlighted"
                    } else if (index < lyricsView.currentIndex) {
                      "faded"
                    } else {
                      ""
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

                  font.weight: 300

                  font.pointSize: 10
                  //font.family: "JetBrainsMono Nerd Font"

                  width: lyricsView.width
                  height: contentHeight + 20

                  leftPadding: 30
                  rightPadding: 30

                  wrapMode: Text.WordWrap

                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter

                  color: Colors.text

                  MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    cursorShape: {
                      if (time) {
                        Qt.PointingHandCursor
                      }
                    }

                    onClicked: (mouse)=> {
                      if (time) {
                        Players.previousPosition = time
                        Players.player.position = time
                        lyricsView.currentIndex = index
                        if (mouse.button == Qt.RightButton) {
                          Players.player.isPlaying = true
                        }
                      }
                    }
                  }
                }
              }

              BaseButton {
                id: lyricsReloadButton

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 5
                anchors.rightMargin: 5

                backgroundAlias.radius: 7
                backgroundColor: "transparent"

                width: textAlias.contentWidth + 15
                height: width

                textAlias.rightPadding: 3
                text: "󰑓"

                onClicked: {
                  Players.reloadLyrics()
                }
              }
            }
          }
        }
      }
    }
  }
}