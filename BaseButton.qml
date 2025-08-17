// BaseButton.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.Services

AbstractButton {
  id: button
  
  property real fontSize: 11

  property alias mouseAreaAlias: mouseArea
  property alias backgroundAlias: rectangle
  property alias textAlias: textItem

  property bool buttonHovered: mouseArea.hovered

  contentItem: Text {
    id: textItem
    font.pointSize: button.fontSize
    font.family: "JetBrainsMono Nerd Font"

    color: Colors.text

    topPadding: button.textTopPadding
    bottomPadding: button.textBottomPadding
    leftPadding: button.textLeftPadding
    rightPadding: button.textRightPadding

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    text: button.text
  }

  property alias cursorShape: mouseArea.cursorShape

  property real textTopPadding
  property real textBottomPadding
  property real textLeftPadding
  property real textRightPadding

  HoverHandler {
    id: mouseArea
    blocking: false
    cursorShape: Qt.PointingHandCursor
  }

  property color pressedBackgroundColor: Colors.itemPressedBackground
  property color hoveredBackgroundColor: Colors.itemHoveredBackground
  property color backgroundColor: Colors.itemBackground

  background: Rectangle {
    id: rectangle
    color: {
      if (button.down) {
        pressedBackgroundColor
      }
      else if (button.buttonHovered) {
        hoveredBackgroundColor
      }
      else {
        backgroundColor
      }
    }

    radius: 10
  }
}