// PanelScaleItem.qml

import QtQuick
import Quickshell

Item {
  id: scaleItem

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
}