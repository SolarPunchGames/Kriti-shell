// WorkspaceWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

Item {
  id: root
  MarginWrapperManager {margin: 5}

  property int maxLetters: 30

  states: State{
    name: "expanded"
    when: (mouseArea.hovered)
    PropertyChanges {target: root; maxLetters: 70}
    PropertyChanges {target: rectangle; color: "#efffd3"}
  }

  transitions: Transition {
    PropertyAnimation {
      property: "maxLetters"
      duration: 500
      easing.type: Easing.OutCubic
    }
  }

  function truncate(text:string, maxLetters:int) : string {
    if (text.length > maxLetters + 1) {
      return text.slice(0, maxLetters) + ".."
    }
    else {
      return text
    }
  }

  Rectangle {
    id: rectangle
    radius: 10

    implicitHeight: 30

    implicitWidth: textItem.width + 30

    color: "#fbfff4"

    HoverHandler {
      id: mouseArea
    }

    Text {
      id: textItem
      anchors.centerIn: parent
      text: Hyprland.activeToplevel ? truncate(Hyprland.activeToplevel.title, maxLetters) : "No active window"
      font.pointSize: 11
      font.family: "JetBrainsMono Nerd Font"
    }

  }
}