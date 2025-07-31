// PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
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

        color: "#d1ddbe"

        bottomLeftRadius: 15

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

            BaseButton { // rebootButton
              id: rebootButton
              text: "Reboot"

              Layout.fillWidth: true
              Layout.fillHeight: true
              Layout.preferredWidth: 315 / 2
              Layout.preferredHeight: 315 / 2
              Layout.horizontalStretchFactor: 1
              Layout.verticalStretchFactor: 1

              onClicked: Quickshell.execDetached(["systemctl", "reboot"]) | toggleOpen()

              Text {
                id: bigRebootText

                anchors.centerIn: parent

                scale: 0

                font.pointSize: 60

                text: "󰑓"

                bottomPadding: 7
                leftPadding: 7

                states: State{
                  name: "hovered"
                  when: rebootButton.mouseAreaAlias.hovered
                  PropertyChanges {target: bigRebootText; scale: 1}
                }

                transitions: Transition {
                  PropertyAnimation {
                    property: "scale"
                    duration: 250
                    easing.type: Easing.OutCubic
                  }
                }
              }

              states: State{
                name: "hovered"
                when: rebootButton.mouseAreaAlias.hovered
                PropertyChanges {target: rebootButton; textAlias.scale: 0}
              }
              transitions: Transition {
                PropertyAnimation {
                  property: "textAlias.scale"
                  duration: 250
                  easing.type: Easing.OutCubic
                }
              }
            }
            BaseButton { // sleepButton
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

              Text {
                id: bigSleepText

                anchors.centerIn: parent

                scale: 0

                font.pointSize: 60

                text: "󰤄"

                bottomPadding: 7
                leftPadding: 7

                states: State{
                  name: "hovered"
                  when: sleepButton.mouseAreaAlias.hovered
                  PropertyChanges {target: bigSleepText; scale: 1}
                }

                transitions: Transition {
                  PropertyAnimation {
                    property: "scale"
                    duration: 250
                    easing.type: Easing.OutCubic
                  }
                }
              }

              states: State{
                name: "hovered"
                when: sleepButton.mouseAreaAlias.hovered
                PropertyChanges {target: sleepButton; textAlias.scale: 0}
              }
              transitions: Transition {
                PropertyAnimation {
                  property: "textAlias.scale"
                  duration: 250
                  easing.type: Easing.OutCubic
                }
              }
            }
            BaseButton { // logoutButton
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

              Text {
                id: bigLogoutText

                anchors.centerIn: parent

                scale: 0

                font.pointSize: 60

                text: "󰍃"

                bottomPadding: 5
                leftPadding: 0

                states: State{
                  name: "hovered"
                  when: logoutButton.mouseAreaAlias.hovered
                  PropertyChanges {target: bigLogoutText; scale: 1}
                }

                transitions: Transition {
                  PropertyAnimation {
                    property: "scale"
                    duration: 250
                    easing.type: Easing.OutCubic
                  }
                }
              }

              states: State{
                name: "hovered"
                when: logoutButton.mouseAreaAlias.hovered
                PropertyChanges {target: logoutButton; textAlias.scale: 0}
              }
              transitions: Transition {
                PropertyAnimation {
                  property: "textAlias.scale"
                  duration: 250
                  easing.type: Easing.OutCubic
                }
              }
            }
            BaseButton { // lockButton
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

              Text {
                id: bigLockText

                anchors.centerIn: parent

                scale: 0

                font.pointSize: 60

                text: ""

                bottomPadding: 7
                leftPadding: 3

                states: State{
                  name: "hovered"
                  when: lockButton.mouseAreaAlias.hovered
                  PropertyChanges {target: bigLockText; scale: 1}
                }

                transitions: Transition {
                  PropertyAnimation {
                    property: "scale"
                    duration: 250
                    easing.type: Easing.OutCubic
                  }
                }
              }

              states: State{
                name: "hovered"
                when: lockButton.mouseAreaAlias.hovered
                PropertyChanges {target: lockButton; textAlias.scale: 0}
              }
              transitions: Transition {
                PropertyAnimation {
                  property: "textAlias.scale"
                  duration: 250
                  easing.type: Easing.OutCubic
                }
              }
            }
          }
        }

        BaseButton { // shutdownButton
          id: shutdownButton
          text: "Shutdown"

          anchors.centerIn: parent

          width: 150
          height: width

          backgroundAlias.radius: width / 2
          backgroundAlias.border.color: "#d1ddbe"
          backgroundAlias.border.width: 5
          backgroundAlias.color: {
            if (shutdownButton.down) {
              "#cfff7d"
            }
            else if (shutdownRoundMouseArea.containsMouse) {
              "#efffd3"
            }
            else {
              "#fbfff4"
            }
          }

          RoundMouseArea {
            id: shutdownRoundMouseArea
            anchors.fill: parent
            onClicked: {
              Quickshell.execDetached(["systemctl", "shutdown"])
              toggleOpen()
            }
          }


          Text {
            id: bigShutdownText

            anchors.centerIn: parent

            scale: 0

            font.pointSize: 65

            text: "󰐥"

            bottomPadding: 7
            leftPadding: 4

            states: State{
              name: "hovered"
              when: shutdownRoundMouseArea.containsMouse
              PropertyChanges {target: bigShutdownText; scale: 1}
            }

            transitions: Transition {
              PropertyAnimation {
                property: "scale"
                duration: 250
                easing.type: Easing.OutCubic
              }
            }
          }

          states: State{
            name: "hovered"
            when: shutdownRoundMouseArea.containsMouse
            PropertyChanges {target: shutdownButton; textAlias.scale: 0}
          }
          transitions: Transition {
            PropertyAnimation {
              property: "textAlias.scale"
              duration: 250
              easing.type: Easing.OutCubic
            }
          }
        }
      }
    }
  }
}
