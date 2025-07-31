// WorkspaceWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../.."

Item {
  MarginWrapperManager {margin: 5}

  property var currentScreen
  property var targetMonitor: Hyprland.monitorFor(screen)

  Rectangle {
    implicitHeight: 30

    implicitWidth: row.width + 10

    color: "transparent"

    Row {
      id: row
      anchors.centerIn: parent
      spacing: 10
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
            color: {
              if (button.down) {
                "#cfff7d"
              }
              else if (mouseAreaAlias.hovered) {
                "#efffd3"
              }
              else if (highlighted) {
                "#fbfff4"
              }
              else {
                "#e5f0be"
              }
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