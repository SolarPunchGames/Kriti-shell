// DateWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import ".."

Item {
  MarginWrapperManager { margin: 5 }
  
  Rectangle {
    color: Colors.itemBackground
    radius: 10

    implicitHeight: 30
    implicitWidth: date.width + 30

    Text {
      id: date

      anchors.centerIn: parent

      color: Colors.text

      font.pointSize: 11
      font.family: "JetBrainsMono Nerd Font"

      text: " " + Time.date
    }
  }
}