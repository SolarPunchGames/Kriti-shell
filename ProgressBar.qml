import QtQuick
import qs.Services
import qs

Item {
  id: root

  property var radius: 10
  property var animationTime: 150

  property bool hovered: progressMouseArea.containsMouse || progressMouseArea.pressed

  MouseArea {
    id: progressMouseArea
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25

    cursorShape: Qt.PointingHandCursor

    hoverEnabled: true

    Timer {
      running: true
      repeat: true
      interval: 50
      onTriggered: {
        if (progressMouseArea.pressed) {
          if (progressMouseArea.mouseX >= 0 && progressMouseArea.mouseX <= progressMouseArea.width) {
            Players.player.position = Players.player.length * (progressMouseArea.mouseX / progressMouseArea.width)
          } else if (progressMouseArea.mouseX < 0) {
            Players.player.position = 0
          } else {
            Players.player.position = Players.player.length
          }
        }
      }
    }

    property bool wasPlaying: false

    onPressed: {
      if (Players.player.isPlaying) {
        wasPlaying = true
        Players.player.isPlaying = false
      }
    }
    onReleased: {
      if (wasPlaying) {
        wasPlaying = false
        Players.player.isPlaying = true
      }
    }
  }
  
  Rectangle {
    id: progressBackground

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottomMargin: root.hovered ? 11 : 0

    clip: true

    color: "transparent"

    Behavior on height {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    Behavior on anchors.bottomMargin {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    height: root.hovered ? 2 : 1

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottomMargin: root.hovered ? -11 : 0

      height: root.height

      radius: root.radius

      Behavior on color {
        PropertyAnimation {
          duration: Colors.colorTransitionTime
        }
      }

      Behavior on anchors.bottomMargin {
        PropertyAnimation {
          duration: root.animationTime
          easing.type: Easing.OutCubic
        }
      }

      color: {
        if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
          if (root.hovered) {
            Colors.mainPanelBackground
          } else {
            "transparent"
          }
        } else {
          "transparent"
        }
      }
    }
  }

  Rectangle {
    id: progressBar

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.bottomMargin: root.hovered ? 10 : 0

    radius: 2

    color: "transparent"

    clip: true

    Behavior on height {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    Behavior on anchors.bottomMargin {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    Behavior on width {
      PropertyAnimation {
        duration: 100
        easing.type: Easing.OutCubic
      }
    }

    height: root.hovered ? 4 : 2
    width: 0

    Timer {
      running: true
      repeat: true
      interval: Players.player.isPlaying ? 250 : 50
      onTriggered: {
        progressBar.width = progressBar.parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
      }
    }

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.bottomMargin: root.hovered ? -10 : 0

      height: root.height
      width: root.width

      radius: root.radius

      Behavior on color {
        PropertyAnimation {
          duration: Colors.colorTransitionTime
        }
      }

      Behavior on anchors.bottomMargin {
        PropertyAnimation {
          duration: root.animationTime
          easing.type: Easing.OutCubic
        }
      }
      
      color: {
        if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
          if (root.hovered) {
            Colors.itemPressedBackground
          } else {
            Colors.itemHoveredBackground
          }
        } else {
          "transparent"
        }
      }
    }
  }
  
  Rectangle {
    id: progressCircle
    width: 12
    height: width

    anchors.verticalCenter: progressBar.verticalCenter
    anchors.left: progressBar.right
    anchors.bottomMargin: root.hovered ? 10 : 0

    radius: width / 2

    transform: Translate {x: -progressCircle.width / 2}

    scale: root.hovered ? 1 : 0

    Behavior on scale {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    Behavior on color {
      PropertyAnimation {
        duration: Colors.colorTransitionTime
      }
    }

    Behavior on anchors.bottomMargin {
      PropertyAnimation {
        duration: root.animationTime
        easing.type: Easing.InOutCubic
      }
    }

    color: {
      if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
        if (root.hovered) {
          Colors.itemPressedBackground
        } else {
          Colors.itemHoveredBackground
        }
      } else {
        "transparent"
      }
    }
  }
}