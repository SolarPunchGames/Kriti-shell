// ClockWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  Rectangle {
    color: Time.isLate ? Colors.itemWarningBackground : Colors.itemBackground
    
    radius: 10

    implicitHeight: 30
    implicitWidth: mainText.width + 45

    Text {
      id: mainText

      anchors.centerIn: parent

      color: Colors.text

      font.pointSize: 11
      font.family: "JetBrainsMono Nerd Font"

      leftPadding: -10

      text: " " + Time.hours + ":" + Time.minutes
    }

    Text {
      id: smallText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: mainText.right
      
      color: Colors.smallText

      font.pointSize: 7
      font.italic: true
      font.family: "JetBrainsMono Nerd Font"

      topPadding: -3

      text: "" + Time.seconds
    }

  }
}
