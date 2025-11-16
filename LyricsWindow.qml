// LyricsWindow.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Services
import qs

FloatingWindow {
  id: window
  title: "Lyrics"

  minimumSize: Qt.size(340, 440)

  color: Colors.mainPanelBackground

  Rectangle {
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