// WorkspaceWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Services

Item {
  id: root
  MarginWrapperManager {margin: 5}

  property int maxLetters: 30
  property int expandedMaxLetters: 60
  readonly property string appTitle: Hyprland.activeToplevel.title

  states: State{
    name: "expanded"
    when: (mouseArea.hovered)
    PropertyChanges {target: root; maxLetters: appTitle.length < expandedMaxLetters ? appTitle.length : expandedMaxLetters}
  }

  transitions: Transition {
    PropertyAnimation {
      property: "maxLetters"
      duration: 500
      easing.type: Easing.InCubic
    }
  }

  Rectangle {
    id: rectangle
    radius: 10

    implicitHeight: 30

    implicitWidth: textItem.width + 30

    color: {
      if (root.state == "expanded") {
        Colors.itemHoveredBackground
      }
      else {
        Colors.itemBackground
      }

    }

    HoverHandler {
      id: mouseArea
    }

    Text {
      id: textItem
      anchors.centerIn: parent
      text: Hyprland.activeToplevel ? TextServices.truncate(appTitle, maxLetters) : "No active window"
      font.pointSize: 11
      color: Colors.text
      font.family: "JetBrainsMono Nerd Font"
    }
  }
}