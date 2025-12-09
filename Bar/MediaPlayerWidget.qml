// MediaPlayerWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell.Io
import qs.Services
import qs

Item {
  MarginWrapperManager { margin: 5 }

  property var currentScreen

  Popup {
    id: rightClickMenu
    anchor.item: rect

    onWindowOpened: {
      anchor.rect.x = mouseArea.mouseX
      anchor.rect.y = mouseArea.mouseY
    }

    listAlias.model: [ 
      {
        customText: true,
        getText() {
          if (rect.state == "closed") {
            return "Show"
          } else {
            return "Hide"
          }
        },
        activate() {
          if (rect.state == "closed") {
            rect.state = ""
          } else {
            rect.state = "closed"
          }
        },
      }, 
      {
        description: "(Middle mouse button)",
        customText: true,
        getText() {
          if (mediaMenuLoader.item) {
            for (var i = 0; i < mediaMenuLoader.item.mediaMenuVariants.instances.length; i++) {
              var instance = mediaMenuLoader.item.mediaMenuVariants.instances[i]
              if (instance.modelData.name === currentScreen) {
                if (instance.scaleItemAlias.state == "") {
                  return "Show media player"
                } else {
                  return "Hide media player"
                }
                break
              }
            }
          }
        },
        activate() {
          if (mediaMenuLoader.item) {
            for (var i = 0; i < mediaMenuLoader.item.mediaMenuVariants.instances.length; i++) {
              var instance = mediaMenuLoader.item.mediaMenuVariants.instances[i]
              if (instance.modelData.name === currentScreen) {
                instance.toggleOpen()
                break
              }
            }
          }
        },
      },
      {
        text: "Open lyrics window",
        activate() {
          if (mediaMenuLoader.item) {
            for (var i = 0; i < mediaMenuLoader.item.mediaMenuVariants.instances.length; i++) {
              var instance = mediaMenuLoader.item.mediaMenuVariants.instances[i]
              if (instance.modelData.name === currentScreen) {
                instance.openLyricsWindow()
                break
              }
            }
          }
        },
      }
    ]
  }
  
  Rectangle {
    id: rect

    color: Colors.itemBackground

    Rectangle {
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left

      clip: true

      color: "transparent"

      width: {
        parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
      }

      Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        width: rect.width

        color: {
          if (Config.media.widget.progressBar.value == 0 || (Config.media.widget.progressBar.value == 1 && Players.trackLyrics != 404 && Players.trackLyrics != 1)) {
            Colors.itemHoveredBackground
          } else {
            "transparent"
          }
        }

        Behavior on color {
          PropertyAnimation {
            duration: 200
          }
        }

        radius: rect.radius
      }
    }

    radius: 10

    implicitHeight: 30
    implicitWidth: {
      if (Players.player) {
        row.width + 30
      } else {
        0
      }
    }

    clip: true

    Behavior on implicitWidth {
      SpringAnimation {
        spring: 5
        damping: 0.4
      }
    }

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

      LazyLoader {  
        id: mediaMenuLoader  
        source: "MediaMenu.qml"
        loading: true 
      }

      onClicked: (mouse)=> {
        if (mouse.button == Qt.LeftButton) {
          Players.player.togglePlaying()
        } else if (mouse.button == Qt.MiddleButton) {
          if (mediaMenuLoader.item) {
            for (var i = 0; i < mediaMenuLoader.item.mediaMenuVariants.instances.length; i++) {
              var instance = mediaMenuLoader.item.mediaMenuVariants.instances[i]
              if (instance.modelData.name === currentScreen) {
                instance.toggleOpen()
                break
              }
            }
          }  
        } else if (mouse.button == Qt.RightButton) {
          rightClickMenu.open()
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

        text: TextServices.truncate(Players.player.trackTitle, 25) + " "
      }

      property int buttonRadius: 5

      BaseButton {
        height: 24
        width: height

        backgroundAlias.radius: row.buttonRadius

        backgroundColor: "transparent"
        hoveredBackgroundColor: Colors.itemDisabledBackground

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 10
        text: ""

        onClicked: Players.player.previous()
      }

      BaseButton {
        height: 24
        width: height

        backgroundAlias.radius: row.buttonRadius

        backgroundColor: "transparent"
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

        backgroundAlias.radius: row.buttonRadius

        backgroundColor: "transparent"
        hoveredBackgroundColor: Colors.itemDisabledBackground

        anchors.verticalCenter: parent.verticalCenter

        fontSize: 10
        text: ""

        onClicked: Players.player.next()
      }
    }
  }
}