// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services
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

      color: "#00000000"

      implicitHeight: mainPanel.height + 50
      implicitWidth: mainPanel.width + 50

      mask: Region {  
        x: mainPanel.x
        y: mainPanel.y - mainPanel.height
        width: {
          if (scaleItem.state == "open") {
            mainPanel.width * 2
          } else {
            0
          }
        }
        height: {
          if (scaleItem.state == "open") {
            mainPanel.height * 2
          } else {
            0
          }
        }
      }

      function toggleOpen() {
        if (scaleItem.state == "open") {
          scaleItem.state = ""
        } else {
          scaleItem.state = "open"
        }
      }

      Item {
        id: scaleItem

        anchors.fill: parent

        transformOrigin: Item.TopRight

        scale: 0.6
        opacity: 0

        states: State {
          name: "open"
          PropertyChanges {target: scaleItem; scale: 1}
          PropertyChanges {target: scaleItem; opacity: 1}
        }

        transitions: Transition {
          PropertyAnimation {
            property: "scale"
            duration: 250
            easing.type: Easing.OutCubic
          }
          PropertyAnimation {
            property: "opacity"
            duration: 250
            easing.type: Easing.OutCubic
          }
        }

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
