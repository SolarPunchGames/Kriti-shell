// InvertedRounding.qml
import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
  id: root
  implicitWidth: rounding
  implicitHeight: rounding

  property color roundingColor
  property int rounding: 10

  MultiEffect {
    source: background
    anchors.fill: background
    maskEnabled: true
    maskSource: mask

    layer.smooth: true

    maskThresholdMin: 0.5
    maskSpreadAtMin: 1.0
  }

  Rectangle {
    id: background
    anchors.fill: parent
    visible: false
    smooth: true
    color: root.roundingColor
  }

  Shape {
    id: mask
    anchors.fill: parent

    visible: false
    layer.enabled: true

    preferredRendererType: Shape.CurveRenderer
    ShapePath {
      strokeColor: "transparent"

      startX: 0
      startY: 0
      PathArc {
        radiusX: root.width
        radiusY: root.height
        x: root.width
        y: root.height
      }
      PathLine {x: root.width; y: 0}
      PathLine {x: 0; y: 0}
    }
  }
}