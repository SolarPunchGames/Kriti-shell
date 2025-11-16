// AppMenu.qml
// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
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

      //WlrLayershell.keyboardFocus: scaleItem.state == "open" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.none

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

          ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.bottomMargin: 5

            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true

              radius: 10

              clip: true

              color: Colors.itemBackground

              ListView {
                id: appsView
                anchors.fill: parent

                topMargin: 20
                bottomMargin: 20

                maximumFlickVelocity: 2000

                currentIndex: -1

                cacheBuffer: 1000

                model: DesktopEntries.applications

                delegate: BaseButton {
                  id: app

                  width: appsView.width - 10

                  anchors.horizontalCenter: parent.horizontalCenter

                  topPadding: 10
                  bottomPadding: 10

                  text: modelData.name

                  onClicked: {
                    modelData.execute()
                    for (var i = 0; i < appMenuVariants.instances.length; i++) {
                      var instance = appMenuVariants.instances[i]
                      instance.close()
                    }
                  }
                }
              }
            }

            TextField {
              id: searchField

              Layout.fillWidth: true
              Layout.preferredHeight: 50

              color: Colors.text

              background: Rectangle {
                radius: 10
                color: Colors.itemBackground
              }
            }
          }
        }
      }
    }
  }
}
