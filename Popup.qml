// Popup.qml
import Quickshell
import QtQuick
import qs
import qs.Services

PopupWindow {
  id: playersPopup

  visible: false

  default property alias data: playersPopupBackground.data

  function open() {
    playersPopupBackground.state = "open"
    visible = true
    windowOpened()
  }

  function close() {
    playersPopupBackground.state = ""
    //visible = false
    windowClosed()
  }

  function toggleOpen() {
    if (playersPopupBackground.state == "open") {
      close()
    } else {
      open()
    }
  }

  signal windowOpened()
  signal windowClosed()

  color: "transparent"

  property alias backgroundAlias: playersPopupBackground

  Rectangle {
    id: playersPopupBackground

    anchors.fill: parent

    transformOrigin: Item.TopLeft

    color: Colors.itemBackground

    radius: 5

    scale: 0.6
    opacity: 0

    states: State {
      name: "open"
      PropertyChanges {target: playersPopupBackground; scale: 1}
      PropertyChanges {target: playersPopupBackground; opacity: 1}
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
  }
}