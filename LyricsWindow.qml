// LyricsWindow.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell
import qs.Services
import qs

FloatingWindow {
  id: window
  title: "Lyrics"

  minimumSize: Qt.size(340, 440)

  color: Colors.mainPanelBackground

  Rectangle {
    id: mainRect

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    color: Colors.itemBackground

    anchors.topMargin: 10
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    radius: 10

    clip: true

    implicitHeight: parent.height - buttonRow.height - 30

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
          lyricsSizeMult: 1.2
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

        ProgressBar {
          anchors.fill: parent
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

  RowLayout {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    anchors.bottomMargin: 10

    Row {
      id: infoRow
      spacing: 10

      Item {
        id: imgItem
        implicitHeight: 50
        implicitWidth: height
        RoundedImage {
          source: Players.player.trackArtUrl

          fillMode: Image.PreserveAspectCrop

          anchors.fill: parent

          radius: 10
        }

        TextIconButton {
          anchors.fill: parent

          backgroundColor: "transparent"

          bigTextItem.text: "󰦚"
          bigTextItem.font.pointSize: 20

          backgroundAlias.opacity: 0.5

          hoveredBackgroundColor: {
            if (Colors.isDark) {
              "black"
            } else {
              "white"
            }
          }
          pressedBackgroundColor: "grey"

          onClicked: {
            if (Players.players.length == 2) {
              if (Players.playerId == 1) {
                Players.customPlayerId = 0
              } else {
                Players.customPlayerId = 1
              }
            } else {
              playersPopup.toggleOpen()
            }
          }
        }
      }

      Popup {
        id: playersPopup
        anchor.item: imgItem
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

      Column {
        Text {
          text: TextServices.truncate(Players.player.trackTitle, (window.width - 270) / 11)

          font.pointSize: 11
          font.family: "JetBrainsMono Nerd Font"
          
          color: Colors.text
        }

        Text {
          text: TextServices.truncate(Players.player.trackArtist, (window.width - 255) / 8)

          font.pointSize: 8
          font.family: "JetBrainsMono Nerd Font"

          color: Colors.text
        }

        Text {
          text: TextServices.secondsToMinutesSeconds(Math.round(Players.player.position)) + "/" + TextServices.secondsToMinutesSeconds(Players.player.length)

          font.pointSize: 8
          font.family: "JetBrainsMono Nerd Font"

          color: Colors.text
        }
      }
    }

    Item {
      id: mainRowSpacer

      Layout.fillWidth: true
    }

    Row {
      id: buttonRow
      spacing: 10

      BaseButton {
        implicitHeight: 50
        implicitWidth: height

        backgroundAlias.radius: 10

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 15
        text: ""

        onClicked: Players.player.previous()
      }

      BaseButton {
        implicitHeight: 50
        implicitWidth: height

        backgroundAlias.radius: 10

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 15
        text: {
          if (Players.player.isPlaying){
            ""
          } else {
            ""
          }
        }

        /*Timer {
          interval: 1000
          running: true
          repeat: true
          onTriggered: parent.forceActiveFocus()
        }*/

        onClicked: Players.player.togglePlaying()
      }

      BaseButton {
        implicitHeight: 50
        implicitWidth: height

        backgroundAlias.radius: 10

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 15
        text: ""

        onClicked: Players.player.next()
      }
    }
  }
}