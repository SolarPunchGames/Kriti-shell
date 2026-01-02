// VolumeWidget.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.Services
import qs

Item {
  MarginWrapperManager { margin: 5 }

  BaseButton {
    id: button

    implicitHeight: 30
    implicitWidth: contentItem.contentWidth + 20

    clip: true

    Behavior on implicitWidth {
      SpringAnimation {
        spring: 5
        damping: 0.3
      }
    }

    anchors.centerIn: parent

    text: {
      if (volumeText) {
        if (Audio.muted) {
          "󰟎 " + volumeText
        } else {
          "󰋋 " + volumeText
        }
      } else {
        if (Audio.muted) {
          "󰟎"
        } else {
          "󰋋"
        }
      }
    }

    contentItem.opacity: Audio.muted ? 0.8 : 1

    property var volumeText: Math.round(Audio.volume * 100) + "%"

    MouseArea {
      id: mouseArea

      anchors.fill: parent

      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true
      acceptedButtons: Qt.AllButtons

      property int dragStart
      property real dragStartVolume

      // make custom volume window

      //LazyLoader {  
      //  id: powerMenuLoader  
      //  source: "MediaMenu.qml"
      //  loading: true 
      //}

      onClicked: (mouse)=> {
        if (mouse.button == Qt.LeftButton) {
          Quickshell.execDetached(["pavucontrol"])
        }
      }

      onWheel: (wheel)=> {
        if (wheel.angleDelta.y < 0) {
          Audio.setVolume(Audio.volume - Config.audio.volumeWidget.scrollIncrement.value * 0.01)
        } else {
          Audio.setVolume(Audio.volume + Config.audio.volumeWidget.scrollIncrement.value * 0.01)
        }
      }

      onPressed: (mouse)=> {
        if (mouse.button == Qt.RightButton) {
          dragStart = mouseX
          dragStartVolume = Audio.volume
        }
      }

      FrameAnimation {
        running: mouseArea.pressedButtons & Qt.RightButton
        onTriggered: {
          var volumeChange = (mouseArea.dragStart - mouseArea.mouseX) * 0.01
          
          var newVolume = Math.min(1, Math.max(0, mouseArea.dragStartVolume - volumeChange * 0.02))

          // Attempted to make it slower to move when over 100

          //if ((mouseArea.dragStartVolume >= 1 && newVolume < 1) || (mouseArea.dragStartVolume < 1 && newVolume >= 1)) {
          //  if (mouseArea.dragStartVolume < 1) {
          //    newVolume = 1 + (newVolume - 1) * 0.1
          //  } else {
          //    var startVolumeOver = (mouseArea.dragStartVolume - 1) * 10
          //    newVolume = Math.max(0, (1 + startVolumeOver) - volumeChange * 0.1)
          //  }
          //} else if (mouseArea.dragStartVolume >= 1) {
          //  newVolume = Math.max(0, mouseArea.dragStartVolume - volumeChange * 0.01)
          //}

          if ((Audio.volume - newVolume) >= 0.005 || (Audio.volume - newVolume) <= -0.005) {
            Audio.setVolume(newVolume)
          }
        }
      }
    }
  }
}