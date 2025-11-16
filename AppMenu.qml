// AppMenu.qml
// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import qs.Services
import qs

Scope {
  id: root
  property alias appMenuVariants: variants

  IpcHandler {
    target: "appMenu"

    function toggle(): void {
      for (var i = 0; i < appMenuVariants.instances.length; i++) {
        var instance = appMenuVariants.instances[i]
        if (Hyprland.monitorFor(instance.modelData) == Hyprland.focusedMonitor) {
          instance.toggleOpen()
        } else {
          instance.close()
        }
      }
    }
  }
  
  Variants {
    id: variants
    model: Quickshell.screens

    ScalePanelWindow {
      id: window

      property var modelData
      screen: modelData

      scaleItemAlias: scaleItem
      mainPanelAlias: mainPanel

      PanelScaleItem {
        id: scaleItem

        anchors.fill: parent

        transformOrigin: Item.Bottom

        InvertedRounding {
          anchors.bottom: mainPanel.bottom
          anchors.right: mainPanel.left
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: 90
          y: -13
        }

        InvertedRounding {
          anchors.bottom: mainPanel.bottom
          anchors.left: mainPanel.right
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: 180
          y: -13
        }

        Rectangle {
          id: mainPanel

          width: 600
          height: 600

          color: Colors.mainPanelBackground

          topLeftRadius: 13
          topRightRadius: topLeftRadius

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom

          layer.enabled: true
        }
      }
    }
  }
}