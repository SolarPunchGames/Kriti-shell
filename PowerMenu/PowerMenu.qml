// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services
import ".."
import "../.."

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

      margins {
        right: -50
      }

      color: "transparent"

      implicitHeight: mainPanel.height + 100
      implicitWidth: mainPanel.width + 100

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

        InvertedRounding {
          anchors.top: parent.top
          anchors.right: parent.left
          roundingColor: parent.color
        }

        InvertedRounding {
          anchors.top: parent.top
          anchors.left: parent.right
          roundingColor: parent.color
          rotation: -90
        }

        width: 315
        height: 315

        color: Colors.mainPanelBackground

        bottomLeftRadius: 13
        bottomRightRadius: bottomLeftRadius

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        transformOrigin: Item.TopRight

        scale: 0

        states: State {
            name: "open"
            PropertyChanges {target: mainPanel; scale: 1}
          }

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
