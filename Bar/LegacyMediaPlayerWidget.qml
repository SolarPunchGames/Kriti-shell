// LegacyMediaPlayerWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.Services
import ".."

Item {
  MarginWrapperManager { margin: 5 }
  
  Rectangle {
    color: {
      if (mouseArea.pressed) {
        Colors.itemPressedBackground
      }
      else if (mouseArea.containsMouse) {
        Colors.itemHoveredBackground
      }
      else {
        Colors.itemBackground
      }
    }
    radius: 10

    implicitHeight: 30
    implicitWidth: mainText.width + 30

    MouseArea {
      id: mouseArea

      anchors.fill: parent

      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true

      onClicked: Quickshell.execDetached(["bash", "/home/alien/.config/waybar/media-player/media-player.sh", "-c", "play-pause"])

      onWheel: (wheel)=> {
        if (wheel.angleDelta.y < 0) {
          console.log("next")
          Quickshell.execDetached(["bash", "/home/alien/.config/waybar/media-player/media-player.sh", "-c", "next"])
        } else {
          console.log("previous")
          Quickshell.execDetached(["bash", "/home/alien/.config/waybar/media-player/media-player.sh", "-c", "previous"])
        }
      }
    }

    Text {
      id: mainText

      anchors.centerIn: parent

      color: Colors.text

      font.pointSize: 11
      font.family: "JetBrainsMono Nerd Font"

      text: "yay"

      Process {
        id: mainMediaProc

        command: ["bash", "/home/alien/.config/waybar/media-player/media-player.sh", "-o", "-b"]
        running: true

        stdout: StdioCollector {
          onStreamFinished: {
            var JsonObject = JSON.parse(this.text);

            mainText.text = JsonObject.text;
          }
        }
      }

      Timer {
        interval: 10

        running: true

        repeat: true

        onTriggered: mainMediaProc.running = true
      }
    }
  }
}