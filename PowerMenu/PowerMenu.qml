// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import ".."

Scope {
  property alias powerMenuVariants: variants
  
  Variants {
    id: variants
    model: Quickshell.screens

    PanelWindow {
      id: window

      property var modelData
      screen: modelData

      anchors {
        top: true
        right: true
      }

      color: "transparent"

      implicitHeight: mainPanel.height
      implicitWidth: mainPanel.width

      mask: Region {  
        x: mainPanel.x
        y: mainPanel.y - mainPanel.height
        width: mainPanel.width * 2 * mainPanel.scale
        height: mainPanel.height * 2 * mainPanel.scale
      }

      function toggleOpen() {
        if (mainPanel.state == "open") {
          mainPanel.state = ""
        } else {
          mainPanel.state = "open"
        }
      }

      Rectangle {
        id: mainPanel

        width: 315
        height: 315

        color: "#d1ddbe"

        bottomLeftRadius: 20

        anchors.right: parent.right
        anchors.top: parent.top

        transformOrigin: Item.TopRight

        scale: 0

        states: [
          State {
            name: "open"
            PropertyChanges {target: mainPanel; scale: 1}
          }
        ]

        transitions: Transition {
          PropertyAnimation {
            property: "scale"
            duration: 250
            easing.type: Easing.OutCubic
          }
        }

        Item {
          MarginWrapperManager { margin: 5 }

          anchors.fill: parent

          GridLayout {
            columns: 2
            rows: 2
            columnSpacing: 5
            rowSpacing: 5

            BaseButton {
              text: "Reboot"
              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.preferredWidth: 315 / 2
              Layout.preferredHeight: 315 / 2
              Layout.horizontalStretchFactor: 1
              Layout.verticalStretchFactor: 1
            }
            BaseButton {
              text: "Shutdown"
              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.preferredWidth: 315 / 2
              Layout.preferredHeight: 315 / 2
              Layout.horizontalStretchFactor: 1
              Layout.verticalStretchFactor: 1
            }
            BaseButton {
              text: "Sleep"
              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.preferredWidth: 315 / 2
              Layout.preferredHeight: 315 / 2
              Layout.horizontalStretchFactor: 1
              Layout.verticalStretchFactor: 1
            }
            BaseButton {
              text: "Logout"
              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.preferredWidth: 315 / 2
              Layout.preferredHeight: 315 / 2
              Layout.horizontalStretchFactor: 1
              Layout.verticalStretchFactor: 1
            }
          }
        }
      }
    }
  }
}
