// BaseButton.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs

AbstractButton {
  id: button
  
  property real fontSize: 11

  property alias mouseAreaAlias: mouseArea
  property alias backgroundAlias: rectangle
  property alias textAlias: textItem

  property bool buttonHovered: mouseArea.hovered
  property bool buttonPressed: down

  property bool transparent: false

  property bool visuallyDisabled: false

  property string tooltipText

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

    Behavior on opacity {
      PropertyAnimation {
        duration: Colors.colorTransitionTime
      }
    }

    text: button.text
  }

  property alias cursorShape: mouseArea.cursorShape

  property real textTopPadding
  property real textBottomPadding
  property real textLeftPadding
  property real textRightPadding

  opacity: visuallyDisabled ? 0.5 : 1

  HoverHandler {
    id: mouseArea
    blocking: false
    cursorShape: visuallyDisabled ? Qt.ArrowCursor : Qt.PointingHandCursor
  }

  HoverPopup {
    anchor.item: button
    hovered: {
      buttonHovered

      // Make popup show only when mouse is stationary
      //mouseArea.point.state == EventPoint.Stationary ? buttonHovered : false
    }
    text: button.tooltipText
  }

  property color pressedBackgroundColor: Colors.itemPressedBackground
  property color hoveredBackgroundColor: Colors.itemHoveredBackground
  property color backgroundColor: Colors.itemBackground

  background: Rectangle {
    id: rectangle
    color: {
      if (button.buttonPressed & !visuallyDisabled) {
        pressedBackgroundColor
      }
      else if (button.buttonHovered & !visuallyDisabled) {
        hoveredBackgroundColor
      }
      else {
        backgroundColor
      }
    }

    opacity: {
      if (button.transparent & !button.buttonHovered & !button.buttonPressed || visuallyDisabled) {
        0
      } else {
        1
      }
    }

    Behavior on color {
      PropertyAnimation {
        duration: Colors.colorTransitionTime;
      }
    }

    Behavior on opacity {
      PropertyAnimation {
        duration: Colors.colorTransitionTime;
      }
    }

    radius: 10
  }
}