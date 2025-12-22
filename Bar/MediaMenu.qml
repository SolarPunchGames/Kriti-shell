// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import qs.Services
import qs

Scope {
  id: root
  property alias mediaMenuVariants: variants

  Component.onCompleted: WindowManager.mediaMenuVariants = mediaMenuVariants

  Variants {
    id: variants
    model: Quickshell.screens

    ScalePanelWindow {
      id: window

      property var modelData
      screen: modelData

      WlrLayershell.keyboardFocus: scaleItemAlias.state == "open" ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

      scaleItemAlias: scaleItem
      mainPanelAlias: mainPanel

      function openLyricsWindow() {
        lyricsWindowComponent.createObject(root)
        window.close()
      }

      Component {
        id: lyricsWindowComponent
        LyricsWindow {}
      }

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

                  Popup {
                    id: playersPopup
                    anchor.item: playersButton
                    anchor.edges: Edges.Bottom | Edges.Left

                    backgroundAlias.width: 11 * 15
                    backgroundAlias.height: {
                      if (playersList.contentHeight > 200) {
                        200
                      } else {
                        playersList.contentHeight
                      }
                    }

                    ListView {
                      id: playersList

                      model: Players.players

                      anchors.fill: parent

                      delegate: BaseButton {
                        id: playersListButton

                        property var data: modelData

                        text: TextServices.truncate(modelData.identity, 13)

                        contentItem: RowLayout {
                          Text {
                            id: checkItem
                            font.pointSize: playersListButton.fontSize
                            font.family: "JetBrainsMono Nerd Font"

                            Layout.fillWidth: true

                            color: Colors.text

                            topPadding: playersListButton.textTopPadding
                            bottomPadding: playersListButton.textBottomPadding
                            leftPadding: playersListButton.textLeftPadding
                            rightPadding: playersListButton.textRightPadding

                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                            wrapMode: Text.WordWrap

                            text: "󰸞"

                            opacity: {
                              if (playersListButton.data == Players.player) {
                                1
                              } else {
                                0
                              }
                            }
                          }
                          Column {
                            Layout.fillWidth: true
                            Text {
                              id: textItem
                              font.pointSize: playersListButton.fontSize
                              font.family: "JetBrainsMono Nerd Font"


                              color: Colors.text

                              topPadding: playersListButton.textTopPadding
                              bottomPadding: playersListButton.textBottomPadding
                              leftPadding: playersListButton.textLeftPadding
                              rightPadding: playersListButton.textRightPadding

                              horizontalAlignment: Text.AlignLeft
                              verticalAlignment: Text.AlignVCenter

                              wrapMode: Text.WordWrap

                              text: playersListButton.text
                            }
                            Text {
                              id: descriptionItem
                              font.pointSize: 6
                              font.family: "JetBrainsMono Nerd Font"

                              width: playersListButton.width

                              color: Colors.text
                              opacity: 0.7

                              topPadding: playersListButton.textTopPadding
                              bottomPadding: playersListButton.textBottomPadding
                              leftPadding: playersListButton.textLeftPadding
                              rightPadding: playersListButton.textRightPadding

                              horizontalAlignment: Text.AlignLeft
                              verticalAlignment: Text.AlignVCenter

                              wrapMode: Text.WordWrap

                              text: TextServices.truncate(playersListButton.player.trackTitle, 25)
                            }
                          }
                        }

                        textLeftPadding: 5

                        anchors.left: parent.left
                        anchors.right: parent.right

                        backgroundAlias.radius: playersPopup.backgroundAlias.radius
                        padding: 5

                        property var player: Players.players[index]

                        onClicked: {
                          playersPopup.close()
                          Players.customPlayerId = index
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

              StackLayout {
                id: tabs
                anchors.fill: parent
                currentIndex: 0

                Connections {
                  target: searchTab
                  function onLyricsFound() {
                    tabs.currentIndex = 0
                  }
                }

                Item {
                  id: lyricsTab
                  LyricsView {
                    id: lyricsView
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

                    BaseButton {
                      id: lyricsSyncButton

                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      textRightPadding: 3

                      text: {
                        if (Players.trackLyrics.syncedLyrics && lyricsView.synced) {
                          "󱫧"
                        } else {
                          "󰔛"
                        }
                      }

                      visible: Players.trackLyrics.syncedLyrics ? true : false

                      onClicked: {
                        lyricsView.synced = !lyricsView.synced
                        lyricsView.reload(0)
                      }
                    }
                  }

                  Row {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 5
                    anchors.rightMargin: 5

                    BaseButton {
                      id: lyricsSearchButton

                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      text: ""

                      onClicked: {
                        tabs.currentIndex = 1
                      }
                    }

                    BaseButton {
                      id: lyricsCopyButton

                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      textRightPadding: 3
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

                      textRightPadding: 3
                      text: ""

                      onClicked: {
                        window.openLyricsWindow()
                      }
                    }

                    BaseButton {
                      id: lyricsReloadButton

                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      textRightPadding: 3
                      text: "󰑓"

                      onClicked: {
                        Players.reloadLyrics()
                      }
                    }
                  }
                }

                LyricsSearch {
                  id: searchTab
                  Row {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: 5
                    anchors.leftMargin: 5

                    BaseButton {
                      id: lyricsSearchTabBackButton

                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      text: "󰁍"

                      onClicked: {
                        tabs.currentIndex = 0
                      }
                    }
                  }
                  Row {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 5
                    anchors.rightMargin: 5

                    BaseButton {
                      backgroundAlias.radius: 7
                      backgroundColor: "transparent"

                      width: 30
                      height: width

                      textRightPadding: 3
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
  }
}