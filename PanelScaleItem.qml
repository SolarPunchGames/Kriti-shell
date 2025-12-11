// PanelScaleItem.qml

import QtQuick
import Quickshell

Item {
  id: scaleItem

  scale: 0.6
  opacity: 0

  states: [
    State {
      name: "open"
      PropertyChanges {target: scaleItem; scale: 1}
      PropertyChanges {target: scaleItem; opacity: 1}
    },
    State {
      name: ""
      PropertyChanges {target: scaleItem; scale: 0.6}
      PropertyChanges {target: scaleItem; opacity: 0}
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
}