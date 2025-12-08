// WorkspaceWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Services
import qs

Item {
  MarginWrapperManager {margin: 5}

  property var currentScreen
  property var targetMonitor: Hyprland.monitorFor(screen)

  Rectangle {
    implicitHeight: 30

    implicitWidth: row.width + 10

    Behavior on implicitWidth {
      SpringAnimation { 
        spring: 8
        damping: 0.5
      }
    }

    color: "transparent"

    Row {
      id: row
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: 5
      spacing: 10

      add: Transition {
        NumberAnimation {
          property: "scale"
          from: 0.5
          to: 1
          duration: 100
          easing.type: Easing.OutCubic
        }
      }

      move: Transition {
        NumberAnimation {
          property: "scale"
          to: 1
        }
      }

      Repeater {
        model: { 
          Hyprland.workspaces
        }
        delegate: BaseButton {
          id: button

          visible: modelData.monitor === targetMonitor

          scale: {
            if (visible) {
              1
            }
            else {
              0
            }
          }

          backgroundAlias.radius: 5
          implicitHeight: 22
          implicitWidth: implicitHeight
          rotation: 45

          backgroundAlias.color: {
            if (button.down) {
              Colors.itemPressedBackground
            }
            else if (mouseAreaAlias.hovered) {
              Colors.itemHoveredBackground
            }
            else if (highlighted) {
              Colors.itemBackground
            }
            else {
              Colors.itemDisabledBackground
            }
          }

          property bool highlighted: modelData.active

          onClicked: modelData.activate()

          text: modelData.name

          textAlias.rotation: -45
        }
      }
    }
  }
}