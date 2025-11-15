// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs

Scope {
  property alias powerMenuVariants: variants
  
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

        transformOrigin: Item.TopRight

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.right: mainPanel.left
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
        }

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.left: mainPanel.right
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: -90
        }

        Rectangle {
          id: mainPanel

          width: 315
          height: 315

          color: Colors.mainPanelBackground

          bottomLeftRadius: 13
          bottomRightRadius: bottomLeftRadius

          anchors.right: parent.right
          anchors.top: parent.top

          layer.enabled: true


          Item {
            MarginWrapperManager { margin: 5 }

            anchors.fill: parent

            GridLayout {
              columns: 2
              rows: 2
              columnSpacing: 5
              rowSpacing: 5

              TextIconButton { // rebootButton
                id: rebootButton
                text: "Reboot"

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 315 / 2
                Layout.preferredHeight: 315 / 2
                Layout.horizontalStretchFactor: 1
                Layout.verticalStretchFactor: 1

                onClicked: {
                  Quickshell.execDetached(["systemctl", "reboot"])
                  toggleOpen()
                }


                bigTextItem.font.pointSize: 60

                bigTextItem.text: "󰑓"

                bigTextItem.bottomPadding: 7
                bigTextItem.leftPadding: 7
              }

              TextIconButton { // sleepButton
                id: sleepButton
                text: "Sleep"

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 315 / 2
                Layout.preferredHeight: 315 / 2
                Layout.horizontalStretchFactor: 1
                Layout.verticalStretchFactor: 1

                onClicked: {
                  Quickshell.execDetached(["systemctl", "suspend"])
                  toggleOpen()
                }

                bigTextItem.font.pointSize: 60

                bigTextItem.text: "󰤄"

                bigTextItem.bottomPadding: 7
                bigTextItem.leftPadding: 7
              }

              TextIconButton { // logoutButton
                id: logoutButton
                text: "Logout"

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 315 / 2
                Layout.preferredHeight: 315 / 2
                Layout.horizontalStretchFactor: 1
                Layout.verticalStretchFactor: 1

                onClicked: {
                  Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
                  toggleOpen()
                }

                bigTextItem.font.pointSize: 60

                bigTextItem.text: "󰍃"

                bigTextItem.bottomPadding: 5
                bigTextItem.leftPadding: 0
              }

              TextIconButton { // lockButton
                id: lockButton
                text: "Lock"

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 315 / 2
                Layout.preferredHeight: 315 / 2
                Layout.horizontalStretchFactor: 1
                Layout.verticalStretchFactor: 1

                onClicked: {
                  Quickshell.execDetached(["hyprlock"])
                  toggleOpen()
                }

                bigTextItem.font.pointSize: 60

                bigTextItem.text: ""

                bigTextItem.bottomPadding: 7
                bigTextItem.leftPadding: 3
              }
            }
          }

          TextIconButton { // shutdownButton
            id: shutdownButton
            text: "Shutdown"

            anchors.centerIn: parent

            width: 150
            height: width

            backgroundAlias.radius: width / 2
            backgroundAlias.border.color: Colors.mainPanelBackground
            backgroundAlias.border.width: 5

            buttonHovered: shutdownRoundMouseArea.containsMouse

            RoundMouseArea {
              id: shutdownRoundMouseArea
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                Quickshell.execDetached(["systemctl", "poweroff"])
                toggleOpen()
              }
            }

            bigTextItem.font.pointSize: 65

            bigTextItem.text: "󰐥"

            bigTextItem.bottomPadding: 7
            bigTextItem.leftPadding: 4
          }
        }
      }
    }
  }
}
