// VolumeWidget.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  BaseButton {
    id: button

    implicitHeight: 30
    implicitWidth: 70

    anchors.centerIn: parent

    Process {
      id: getVolProc

      command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]

      running: true

      stdout: StdioCollector {
        onStreamFinished: button.text = " " + this.text.slice(8, 12) * 1000 / 10 + "%" // ik this looks dumb, but 0.58 * 100 is apparently 57.9999999.. this fixes that.
      }
    }

    Timer {
      interval: 50

      running: true

      repeat: true

      onTriggered: getVolProc.running = true
    }

    // text: " " + Audio.sink.audio.volume.toFixed(2)

    WheelHandler {
      blocking: false
      onWheel: (event)=> Audio.setVolume(0.5)
    }

    onClicked: Quickshell.execDetached(["pavucontrol"])

    // onPressed: // make custom volume window
  }
}