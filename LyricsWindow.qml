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

    LyricsView {
      id: lyricsView
      lyricsSizeMult: 1.2
    }

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left

      clip: true

      height: 3

      color: "transparent"

      width: {
        parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
      }

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        width: mainRect.width
        height: mainRect.height

        color: {
          if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
            Colors.itemPressedBackground
          } else {
            "transparent"
          }
        }

        Behavior on color {
          PropertyAnimation {
            duration: 200
          }
        }

        radius: mainRect.radius
      }
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

          hoveredBackgroundColor: "black"
          pressedBackgroundColor: "grey"

          onClicked: playersPopup.toggleOpen()
        }
      }

      PopupWindow {
        id: playersPopup
        anchor.item: imgItem
        anchor.edges: Edges.Bottom | Edges.Left
        implicitWidth: 200
        implicitHeight: {
          if (playersList.contentHeight > 100) {
            100
          } else {
            playersList.contentHeight
          }
        }

        visible: false

        Connections {  
          target: window
          function onWindowClosed() {  
            playersPopup.close()
          }
        }

        function open() {
          playersPopupBackground.state = "open"
          visible = true
          windowOpened()
        }

        function close() {
          playersPopupBackground.state = ""
          //visible = false
          windowClosed()
        }

        function toggleOpen() {
          if (playersPopupBackground.state == "open") {
            close()
          } else {
            open()
          }
        }

        signal windowOpened()
        signal windowClosed()

        color: "transparent"

        Rectangle {
          id: playersPopupBackground

          anchors.fill: parent

          transformOrigin: Item.TopLeft

          color: Colors.itemBackground

          radius: 5

          scale: 0.6
          opacity: 0

          states: State {
            name: "open"
            PropertyChanges {target: playersPopupBackground; scale: 1}
            PropertyChanges {target: playersPopupBackground; opacity: 1}
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

              backgroundAlias.radius: playersPopupBackground.radius
              padding: 5

              onClicked: {
                Players.playerId = index
                playersPopup.close()
              }
            }
          }
        }
      }

      Column {
        Text {
          text: TextServices.truncate(Players.player.trackTitle, (window.width - 255) / 11)

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

        Timer {
          interval: 1000
          running: true
          repeat: true
          onTriggered: parent.forceActiveFocus()
        }

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