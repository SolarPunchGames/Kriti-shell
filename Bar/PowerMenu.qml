// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs

Scope {
  id: root
  property alias powerMenuVariants: variants

  property var command
  property string commandName

  Component {
    id: confirmationWindowComponent
    FloatingWindow {
      id: confirmationWindow
      color: Colors.mainPanelBackground

      minimumSize: Qt.size(350, 120)
      maximumSize: Qt.size(350, 120)
      ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        Text {
          Layout.fillWidth: true
          Layout.fillHeight: true
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          text: "Are you sure you want to " + root.commandName + "?"
          color: Colors.text
          font.pointSize: 11
          font.family: "JetBrainsMono Nerd Font"
        }
        RowLayout {
          Layout.fillWidth: true
          Layout.fillHeight: true
          uniformCellSizes: true
          spacing: 10
          BaseButton {
            text: "Yes"
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
              Quickshell.execDetached(root.command)
              confirmationWindow.destroy()
            }
          }
          BaseButton {
            text: "No"
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: confirmationWindow.destroy()
          }
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
                  /*for (const item of root.children) {
                    if (item instanceof FloatingWindow) {
                    }
                    item.destroy()
                  }*/ // I tried to make it close all other confirmation windows
                  confirmationWindowComponent.createObject(root)
                  root.command = ["systemctl", "reboot"]
                  root.commandName = "reboot"
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
                  confirmationWindowComponent.createObject(root)
                  root.command = ["systemctl", "suspend"]
                  root.commandName = "sleep"
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
                  confirmationWindowComponent.createObject(root)
                  root.command = ["hyprctl", "dispatch", "exit"]
                  root.commandName = "logout"
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
                  confirmationWindowComponent.createObject(root)
                  root.command = ["hyprlock"]
                  root.commandName = "lock"
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
            buttonPressed: {
              console.log(shutdownRoundMouseArea.pressed)
              shutdownRoundMouseArea.pressed
            }

            RoundMouseArea {
              id: shutdownRoundMouseArea
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                confirmationWindowComponent.createObject(root)
                root.command = ["systemctl", "poweroff"]
                root.commandName = "shutdown"
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
