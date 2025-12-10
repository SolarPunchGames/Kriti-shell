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

    implicitWidth: list.contentWidth

    Behavior on implicitWidth {
      SpringAnimation { 
        spring: 8
        damping: 0.5
      }
    }

    color: "transparent"

    ListView {
      id: list
      anchors.fill: parent
      spacing: 10

      width: contentWidth

      orientation: Qt.Horizontal

      boundsBehavior: Flickable.StopAtBounds

      add: Transition {
        NumberAnimation {
          property: "scale"
          from: 0.5
          to: 1
          duration: 100
          easing.type: Easing.OutCubic
        }
      }

      remove: Transition {
        NumberAnimation {
          property: "scale"
          from: 1
          to: 0
          duration: 100
          easing.type: Easing.OutCubic
        }
      }

      displaced: Transition {
        SpringAnimation {
          properties: "x"
          spring: 5
          damping: 0.3
        }
      }

      SortFilterProxyModel {
        id: filteredWorkspaces
        sourceModel: Hyprland.workspaces

        filters: ValueFilter {
          roleName: "monitor.id"
          value: targetMonitor.id
          enabled: true
        }
      }
    
      model: Hyprland.workspaces

      delegate: BaseButton {
        id: button

        visible: modelData.monitor === targetMonitor

        anchors.verticalCenter: parent.verticalCenter

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