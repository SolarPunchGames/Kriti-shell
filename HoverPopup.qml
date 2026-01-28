// Popup.qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs
import qs.Services

PopupWindow {
  id: window

  anchor.edges: Edges.Bottom | Edges.Right

  implicitWidth: background.width + 20
  implicitHeight: background.height + 20

  property bool hovered: false
  property string text: ""

  mask: Region {
    width: 0
    height: 0
  }

  visible: {
    if (background.opacity == 0) {
      false
    } else {
      true
    }
  }

  default property alias data: background.data

  function open() {
    background.state = "open"
    //visible = true
    windowOpened()
  }

  function close() {
    background.state = ""
    //visible = false
    windowClosed()
  }

  function toggleOpen() {
    if (background.state == "open") {
      close()
    } else {
      open()
    }
  }

  signal windowOpened()
  signal windowClosed()

  color: "transparent"

  property alias backgroundAlias: background

  Rectangle {
    id: background

    anchors.top: parent.top
    anchors.left: parent.left

    width: textItem.contentWidth + 20
    height: textItem.contentHeight + 20

    transformOrigin: Item.TopLeft

    color: Colors.menuBackground

    radius: 10
    clip: true

    scale: 0.6
    opacity: 0

    Timer {
      interval: 600
      running: window.hovered & window.text != ""
      onTriggered: background.state = "open"
    }

    Timer {
      interval: 50
      running: !window.hovered
      onTriggered: background.state = ""
    }

    states: [
      State {
        name: "open"
        PropertyChanges {target: background; scale: 1}
        PropertyChanges {target: background; opacity: 1}
      },
      State {
        name: ""
        PropertyChanges {target: background; scale: 0.6}
        PropertyChanges {target: background; opacity: 0}
      }
    ]

    transitions: Transition {
      SpringAnimation {
        property: "scale"
        spring: 5
        damping: 0.3
      }
      PropertyAnimation {
        property: "opacity"
        duration: 250
        easing.type: Easing.OutCubic
      }
    }

    Text {
      id: textItem

      anchors.fill: parent

      font.pointSize: 10
      font.family: Config.style.font.value

      color: Colors.text

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      text: window.text
    }
  }
}
