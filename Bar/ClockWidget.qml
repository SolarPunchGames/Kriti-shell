// ClockWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  readonly property string warningBackColor: "#af4b44"

  Rectangle {
    color: Time.isLate ? warningBackColor : "#fbfff4"
    
    radius: 10

    implicitHeight: 30
    implicitWidth: mainText.width + 45

    Text {
      id: mainText

      anchors.centerIn: parent

      font.pointSize: 10.5
      font.family: "JetBrainsMono Nerd Font"

      leftPadding: -10

      text: " " + Time.hours + ":" + Time.minutes
    }

    Text {
      id: smallText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: mainText.right

      font.pointSize: 7
      font.italic: true
      font.family: "JetBrainsMono Nerd Font"

      topPadding: -3

      text: "" + Time.seconds
    }

  }
}
