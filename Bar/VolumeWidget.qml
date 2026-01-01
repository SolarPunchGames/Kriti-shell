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

      // make custom volume window

      //LazyLoader {  
      //  id: powerMenuLoader  
      //  source: "MediaMenu.qml"
      //  loading: true 
      //}

      onClicked: Quickshell.execDetached(["pavucontrol"])

      onWheel: (wheel)=> {
        if (wheel.angleDelta.y < 0) {
          Audio.setVolume(Audio.volume - Config.audio.volumeWidget.scrollIncrement.value * 0.01)
        } else {
          Audio.setVolume(Audio.volume + Config.audio.volumeWidget.scrollIncrement.value * 0.01)
        }
      }
    }
  }
}