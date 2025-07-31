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
    implicitWidth: 85

    anchors.centerIn: parent

    text: " " + Audio.sink.audio.volume.toFixed(2) * 1000 / 10 + "%" // ik this looks dumb, but 0.58 * 100 is apparently 57.9999999.. this fixes that.

    WheelHandler {
      blocking: false
      onWheel: (event)=> Audio.setVolume(0.5)
    }

    onPressed: Quickshell.execDetached(["pavucontrol"])

    // onPressed: // make custom volume window
  }
}