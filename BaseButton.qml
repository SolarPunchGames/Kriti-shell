// BaseButton.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

AbstractButton {
  id: button
  implicitHeight: 30
  implicitWidth: 30
  
  property real fontSize: 11

  contentItem: Text {
    font.pointSize: button.fontSize
    font.family: "JetBrainsMono Nerd Font"

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: button.text
  }

  property alias cursorShape: mouseArea.cursorShape

  HoverHandler {
      id: mouseArea
      blocking: false
      cursorShape: Qt.PointingHandCursor
  }

  background: Rectangle {
    color: {
      if (button.down) {
        "#cfff7d"
      }
      else if (mouseArea.hovered) {
        "#efffd3"
      }
      else {
        "#fbfff4"
      }
    }

    radius: 10
  }
}