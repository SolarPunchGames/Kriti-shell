// InvertedRounding.qml
import Quickshell
import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

Item {
  id: root
  implicitWidth: rounding
  implicitHeight: rounding

  property color roundingColor
  property int rounding: 10

  Rectangle {
    id: background
    anchors.fill: parent

    color: root.roundingColor

    visible: false
  }
  
  Shape {
    id: mask
    anchors.fill: parent

    visible: false

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

  OpacityMask {
    anchors.fill: parent
    source: background
    maskSource: mask
  }
}