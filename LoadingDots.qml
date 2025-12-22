import QtQuick
import Quickshell
import qs.Services
import qs

Item {
  id: root
  property int currentDotIndex: 0
  property bool running: false

  property var scaleMult: 0.8

  visible: running

  Timer {
    running: root.running
    repeat: true
    interval: 400
    onTriggered: {
      if (root.currentDotIndex == 2) {
        root.currentDotIndex = 0
      } else {
        root.currentDotIndex += 1
      }
    }
  }

  Row {
    anchors.centerIn: parent
    spacing: 5 * scaleMult
    Rectangle {
      width: 20 * scaleMult
      height: width
      radius: width / 2

      scale: root.currentDotIndex == 0 ? 1 : 0.5

      Behavior on scale {
        SpringAnimation {
          spring: 10
          damping: 0.3
        }
      }
    }
    Rectangle {
      width: 20 * scaleMult
      height: width
      radius: width / 2

      scale: root.currentDotIndex == 1 ? 1 : 0.5

      Behavior on scale {
        SpringAnimation {
          spring: 10
          damping: 0.3
        }
      }
    }
    Rectangle {
      width: 20 * scaleMult
      height: width
      radius: width / 2

      scale: root.currentDotIndex == 2 ? 1 : 0.5

      Behavior on scale {
        SpringAnimation {
          spring: 10
          damping: 0.3
        }
      }
    }
  }
}