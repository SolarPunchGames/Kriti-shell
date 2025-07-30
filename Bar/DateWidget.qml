// DateWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."

Item {
  MarginWrapperManager { margin: 5 }
  
  Rectangle {
    color: "#fbfff4"
    radius: 10

    implicitHeight: 30
    implicitWidth: 140

    Text {
      id: date

      anchors.centerIn: parent

      font.pointSize: 11
      font.family: "JetBrainsMono Nerd Font"

      text: " " + Time.date
    }
  }
}