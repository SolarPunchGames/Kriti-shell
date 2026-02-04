// MediaPlayerWidget.qml
import QtQuick
import QtQuick.Layouts
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
            return "Show widget"
          } else {
            return "Hide widget"
          }
        },
        activate() {
          rect.toggleOpen()
        },
      },
      {
        description: "(Left mouse button)",
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
      },
      {
        separator: true,
      },
      {
        text: "Change player",
        activate() {
          if (Players.players.length == 2 && Config.media.widget.quickPlayerChange.value) {
            if (Players.playerId == 1) {
              Players.customPlayerId = 0
            } else {
              Players.customPlayerId = 1
            }
          } else {
            playersPopup.toggleOpen()
          }
        },
      },
      {
        separator: true
      },
      {
        description: "(Middle mouse button)",
        customText: true,
        getText() {
          if (Players.player.isPlaying) {
            return "Pause"
          } else {
            return "Play"
          }
        },
        activate() {
          Players.player.togglePlaying()
        },
      },
      {
        description: "(Scroll up)",
        text: "Previous",
        activate() {
          Players.player.previous()
        },
      },
      {
        description: "(Scroll down)",
        text: "Next",
        activate() {
          Players.player.next()
        },
      },
    ]
  }

  PlayersPopup {
    id: playersPopup
    anchor.item: rect
    anchor.edges: Edges.Bottom | Edges.Left
  }

  Row {
    id: mainRow
    spacing: -20
    Item {
      MarginWrapperManager { margin: 3 }
      BaseButton {
        implicitWidth: Players.playerToSwitchTo && !Players.tempDisableSwitchSuggestion && Config.media.widget.suggestPlayerChange.value && rect.state != "closed" ? textAlias.contentWidth + rightPadding + leftPadding : 0
        implicitHeight: 24

        Behavior on implicitWidth {
          SpringAnimation {
            spring: 5
            damping: 0.3
          }
        }

        clip: true

        text: Players.playerToSwitchTo ? TextServices.truncate(Players.playerToSwitchTo.trackTitle, 10) + " ♪" : ""

        rightPadding: 25
        leftPadding: 10

        fontSize: 8

        backgroundAlias.radius: 0

        backgroundAlias.bottomLeftRadius: 10
        backgroundAlias.topLeftRadius: 10

        backgroundAlias.border.color: Colors.itemHoveredBackground
        backgroundAlias.border.width: 1

        MouseArea {
          anchors.fill: parent

          cursorShape: Qt.PointingHandCursor

          acceptedButtons: Qt.AllButtons

          onClicked: (mouse)=> {
            if (mouse.button == Qt.LeftButton) {
              Players.customPlayerId = Players.players.indexOf(Players.playerToSwitchTo)
            } else {
              Players.tempDisableSwitchSuggestion = true
            }
          }

          onPressed: (mouse)=> {
            if (mouse.button != Qt.LeftButton) {
              parent.hoveredBackgroundColor = Colors.itemHoveredWarningBackground
            }
          }

          onExited: {
            parent.hoveredBackgroundColor = Colors.itemHoveredBackground
          }
        }

        BaseButton {
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.margins: 2
          anchors.rightMargin: 17

          width: height

          opacity: parent.buttonHovered ? 1 : 0

          Behavior on opacity {
            PropertyAnimation {
              duration: Colors.colorTransitionTime
            }
          }

          backgroundAlias.radius: height / 2
          
          hoveredBackgroundColor: Colors.itemHoveredWarningBackground
          pressedBackgroundColor: Colors.itemPressedWarningBackground

          text: ""

          tooltipText: "Temporarily disable suggestion"

          onClicked: Players.tempDisableSwitchSuggestion = true
        }
      }
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

        Timer {
          running: true
          repeat: true
          interval: 50
          onTriggered: {
            parent.width = parent.parent.width * ((Players.player.position - Players.pausedTime) / Players.player.length)
          }
        }

        Behavior on width {
          PropertyAnimation {
            duration: 100
          }
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

      height: 30
      width: {
        if (Players.player) {
          row.width + 20
        } else {
          0
        }
      }

      clip: true

      Behavior on width {
        SpringAnimation {
          spring: 5
          damping: 0.4
        }
      }

      function open() {
        state = ""
        windowOpened()
      }

      function close() {
        state = "closed"
        windowClosed()
      }

      function toggleOpen() {
        if (rect.state == "closed") {
          open()
        } else {
          close()
        } 
      }

      signal windowOpened()
      signal windowClosed()

      states: State {
        name: "closed"
        PropertyChanges {target: mainRow; y: -25}
      }

      transitions: Transition {
        SpringAnimation {
          property: "y"
          spring: 6
          damping: 0.4
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
          if (mouse.button == Qt.MiddleButton) {
            Players.player.togglePlaying()
          } else if (mouse.button == Qt.LeftButton) {
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
          font.family: Config.style.font.value

          leftPadding: 5

          text: TextServices.truncate(Players.player.trackTitle, 25) + " "
        }

        property int buttonRadius: 5

        BaseButton {
          height: 24
          width: height

          backgroundAlias.radius: row.buttonRadius

          backgroundColor: "transparent"

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

          anchors.verticalCenter: parent.verticalCenter

          fontSize: 10
          text: ""

          onClicked: Players.player.next()
        }
      }
    }
  }
  
}