// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import qs.Services
import qs

Scope {
  id: root
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

            spacing: {
              if (lyricsRect.closed) {
                0
              } else {
                5
              }
            }

            Behavior on spacing {
              PropertyAnimation {
                duration: 300
              }
            }

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

                    width: 30
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

              LyricsView {
                id: lyricsView
              }

              Component {
                id: lyricsWindowComponent
                LyricsWindow {}
              }

              Row {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 5
                anchors.rightMargin: 5

                BaseButton {
                  id: lyricsWindowButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
                  height: width

                  textAlias.rightPadding: 3
                  text: "󱂬"

                  onClicked: {
                    lyricsWindowComponent.createObject(root)
                  }
                }

                BaseButton {
                  id: lyricsReloadButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
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
}