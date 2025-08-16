// MediaPlayerWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell.Io
import qs.Services
import ".."

Item {
  MarginWrapperManager { margin: 5 }
  
  Rectangle {
    id: rect

    color: {
      if (mouseArea.pressed) {
        Colors.itemHoveredBackground
      }
//      else if (mouseArea.containsMouse) {
//        Colors.itemHoveredBackground
//      }
      else {
        Colors.itemBackground
      }
    }
    radius: 10

    implicitHeight: 30
    implicitWidth: row.width + 30

    states: State {
      name: "closed"
      PropertyChanges {target: rect; y: -25}
    }

    transitions: Transition {
      PropertyAnimation {
        property: "y"
        duration: 200
        easing.type: Easing.OutCubic
      }
    }

    MouseArea {
      id: mouseArea

      anchors.fill: parent

      cursorShape: Qt.PointingHandCursor
      hoverEnabled: true

      acceptedButtons: Qt.AllButtons

      onClicked: (mouse)=> {
        if (mouse.button == Qt.LeftButton) {
          if (rect.state == "closed") {
            rect.state = ""
          } else {
            Players.player.togglePlaying()
          }
        } else if (mouse.button == Qt.MiddleButton) {
          if (rect.state == "closed") {
            rect.state = ""
          } else {
            rect.state = "closed"
          }
        }
      }

      onWheel: (wheel)=> {
        if (wheel.angleDelta.y < 0) {
          Players.player.next()
        } else {
          Players.player.previous()
        }
      }
    }

    Row {
      id: row
      anchors.centerIn: parent
      spacing: 5

      Text {
        id: mainText

        anchors.verticalCenter: parent.verticalCenter

        color: Colors.text

        font.pointSize: 11
        font.family: "JetBrainsMono Nerd Font"

        text: TextServices.truncate(Players.player.trackTitle, 30) + " "
      }

      property int buttonRadius: 5

      BaseButton {
        height: 24
        width: height

        backgroundAlias.radius: buttonRadius

        hoveredBackgroundColor: Colors.itemDisabledBackground

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 10
        text: ""

        onClicked: Players.player.previous()
      }

      BaseButton {
        height: 24
        width: height

        backgroundAlias.radius: buttonRadius

        hoveredBackgroundColor: Colors.itemDisabledBackground

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 10
        text: {
          if (Players.player.isPlaying){
            ""
          } else {
            ""
          }
        }

        onClicked: Players.player.togglePlaying()
      }

      BaseButton {
        height: 24
        width: height

        backgroundAlias.radius: buttonRadius

        hoveredBackgroundColor: Colors.itemDisabledBackground

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 10
        text: ""

        onClicked: Players.player.next()
      }
    }
  }
}