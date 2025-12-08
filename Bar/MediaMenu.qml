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
  property alias mediaMenuVariants: variants
  
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

                    Rectangle {
                      id: progressBar

                      anchors.bottom: parent.bottom
                      anchors.left: parent.left

                      color: {
                        if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
                          Colors.itemPressedBackground
                        } else {
                          "transparent"
                        }
                      }

                      height: 3
                      width: parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
                    }
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

                  BaseButton {
                    id: playersButton

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 5
                    anchors.leftMargin: 5

                    backgroundAlias.radius: 5

                    width: 30
                    height: width

                    textAlias.rightPadding: 5
                    text: "󰦚"

                    onClicked: {
                      playersPopup.toggleOpen()
                    }

                  }

                  Rectangle {
                    id: playersPopup

                    anchors.top: playersButton.bottom
                    anchors.left: playersButton.left

                    function open() {
                      state = "open"
                      windowOpened()
                    }

                    function close() {
                      state = ""
                      windowClosed()
                    }

                    function toggleOpen() {
                      if (state == "open") {
                        close()
                      } else {
                        open()
                      }
                    }

                    signal windowOpened()
                    signal windowClosed()

                    implicitWidth: 200
                    implicitHeight: {
                      if (playersList.contentHeight > 100) {
                        100
                      } else {
                        playersList.contentHeight
                      }
                    }

                    transformOrigin: Item.TopLeft

                    color: Colors.itemBackground

                    radius: 5

                    scale: 0.6
                    opacity: 0

                    states: State {
                      name: "open"
                      PropertyChanges {target: playersPopup; scale: 1}
                      PropertyChanges {target: playersPopup; opacity: 1}
                    }

                    transitions: Transition {
                      PropertyAnimation {
                        property: "scale"
                        duration: 250
                        easing.type: Easing.OutCubic
                      }
                      PropertyAnimation {
                        property: "opacity"
                        duration: 250
                        easing.type: Easing.OutCubic
                      }
                    }

                    ListView {
                      id: playersList

                      model: Players.players

                      anchors.fill: parent

                      delegate: BaseButton {
                        text: {
                          if (modelData == Players.player) {
                            "󰸞 " + modelData.identity
                          } else {
                            "  " + modelData.identity
                          }
                        }

                        textAlias.horizontalAlignment: Text.AlignLeft
                        textAlias.leftPadding: 5

                        anchors.left: parent.left
                        anchors.right: parent.right

                        backgroundAlias.radius: playersPopup.radius
                        padding: 5

                        onClicked: {
                          Players.playerId = index
                        }
                      }
                    }
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
              implicitWidth: {
                if (closed) {
                  0
                } else {
                  mediaRect.width
                }
              }
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
                  open()
                } else {
                  close()
                }
              }

              function open() {
                closed = false
                lyricsView.reload()
              }

              function close() {
                closed = true
                lyricsView.lyricsListAlias.clear()
              }

              property bool closed: false

              color: Colors.itemBackground

              clip: true

              LyricsView {
                id: lyricsView
              }

              Component {
                id: lyricsWindowComponent
                LyricsWindow {}
              }

              Row {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 5
                anchors.leftMargin: 5

                BaseButton {
                  id: minusButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
                  height: width

                  text: "󰍴"

                  onClicked: {
                    if (lyricsView.lyricsSizeMult > 0.5) {
                      lyricsView.lyricsSizeMult -= 0.1
                    }
                  }
                }

                BaseButton {
                  id: plusButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
                  height: width

                  text: "󰐕"

                  onClicked: {
                    if (lyricsView.lyricsSizeMult < 2) {
                      lyricsView.lyricsSizeMult += 0.1
                    }
                  }
                }

              }

              Row {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: 5
                anchors.rightMargin: 5

                BaseButton {
                  id: lyricsCopyButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
                  height: width

                  textAlias.rightPadding: 3
                  text: "󰆏"

                  onClicked: {
                    Quickshell.clipboardText = Players.trackLyrics.plainLyrics
                  }
                }

                BaseButton {
                  id: lyricsWindowButton

                  backgroundAlias.radius: 7
                  backgroundColor: "transparent"

                  width: 30
                  height: width

                  textAlias.rightPadding: 3
                  text: ""

                  onClicked: {
                    lyricsWindowComponent.createObject(root)
                    window.close()
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