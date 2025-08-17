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

          width: 580
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

            Rectangle {

              implicitWidth: mainPanel.width / 2 - 7.5
              implicitHeight: parent.height - 10

              color: Colors.itemBackground

              radius: 10

              ColumnLayout {
                id: mediaColumn
                spacing: 5

                anchors.horizontalCenter: parent.horizontalCenter

                y: 5
                
                Item {
                  Layout.preferredWidth: parent.parent.width - 10
                  Layout.preferredHeight: width

                  Layout.alignment: Qt.AlignHCenter

                  RoundedImage {
                    id: img
                    source: Players.player.trackArtUrl

                    fillMode: Image.PreserveAspectCrop

                    anchors.fill: parent

                    radius: 7
                  }
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
                  text: TextServices.truncate(Players.player.trackArtist, 20) + " - " + TextServices.formatSecondsToMinutesAndSeconds(Math.round(Players.player.position)) + "/" + TextServices.formatSecondsToMinutesAndSeconds(Players.player.length)

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
              implicitWidth: mediaColumn.width + 10
              implicitHeight: parent.height - 10

              radius: 10

              color: Colors.itemBackground

              clip: true

              ListView {
                id: lyricsView
                anchors.fill: parent

                topMargin: 20
                rightMargin: 20
                leftMargin: 20

                maximumFlickVelocity: 2000

                highlightMoveDuration: 2000
                highlightRangeMode: ListView.ApplyRange

                currentIndex: -1

                preferredHighlightBegin: height / 3
                preferredHighlightEnd: height / 2

                model: ListModel {
                  id: lyricsList
                }

                Connections {  
                  target: Players.player 
                  function onTrackChanged() {  
                    lyricsList.clear()
                    showLyricsTimer.running = true
                  }  
                }

                Timer {
                  id: showLyricsTimer
                  interval: 10000
                  running: true

                  onTriggered: {
                    if (Players.trackLyrics.syncedLyrics) {
                      var syncedLyrics = Players.trackLyrics.syncedLyrics
                      var lines = syncedLyrics.split("\n");
                      for (var i = 0; i < lines.length; i++) {
                        lyricsList.append({ "lyricText": lines[i].substring(11), "time": 60 * parseFloat(lines[i].substring(1,3)) + parseFloat(lines[i].substring(4,9)), "index": i });
                      }
                    } else {
                      var plainLyrics = Players.trackLyrics.plainLyrics
                      var lines = plainLyrics.split("\n");
                      for (var i = 0; i < lines.length; i++) {
                        lyricsList.append({ "lyricText": lines[i], "time": 0, "index": i });
                      }
                    }
                  }
                }

                delegate: Text {
                  id: lyric
                  required property string lyricText
                  required property real time
                  required property int  index
                  text: lyricText

                  property var isCurrentItem: ListView.isCurrentItem

                  state: {
                    if (isCurrentItem) {
                      "highlighted"
                    } else if (Players.player.position > time && time != 0) {
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
                        if (Players.player.position >= time -0.1 && Players.player.position <= time + 0.5) {
                          lyricsView.currentIndex = index
                        }  
                      }
                    }
                  }

                  states: [ State {
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

                  width: lyricsRect.width - lyricsView.rightMargin - lyricsView.leftMargin
                  height: 30 * lineCount

                  wrapMode: Text.WordWrap

                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter

                  color: Colors.text

                  MouseArea {
                    anchors.fill: parent

                    cursorShape: {
                      if (time) {
                        Qt.PointingHandCursor
                      }
                    }

                    onClicked: {
                      if (time) {
                        Players.player.position = time
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}