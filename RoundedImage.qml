// RoundedImage.qml
import QtQuick
import QtQuick.Effects

Item {
  id: root
  property var source
  property var radius
  property var fillMode

  smooth: true

  MultiEffect {
    source: image
    anchors.fill: image
    maskEnabled: true
    maskSource: mask

    layer.smooth: true

    maskThresholdMin: 0.5
    maskSpreadAtMin: 1.0
  }

  Image {
    id: image
    anchors.fill: root
    source: root.source
    fillMode: root.fillMode
    visible: false
    smooth: true
  }

  Item {
    id: mask
    anchors.fill: image
    layer.enabled: true
    visible: false
    smooth: true
    Rectangle { anchors.fill: parent; radius: root.radius }
  }
}
