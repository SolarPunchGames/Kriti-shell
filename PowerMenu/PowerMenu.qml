// PowerMenu.qml
import QtQuick
import QtQuick.Shapes
import Quickshell

Scope {
  PanelWindow {
    anchors {
      top: true
      right: true
    }

    color: "transparent"

    implicitHeight: quarterCircle.height
    implicitWidth: quarterCircle.width

    mask: Region {  
      x: quarterCircle.x
      y: quarterCircle.y - quarterCircle.height
      width: quarterCircle.width * 2
      height: quarterCircle.height * 2
      shape: RegionShape.Ellipse
    }

    Shape {
      id: quarterCircle

      width: 315
      height: 315

      anchors.right: parent.right
      anchors.top: parent.top

      preferredRendererType: Shape.CurveRenderer

      ShapePath {
        fillColor: "#d1ddbe"
        strokeColor: "transparent"

        startX: quarterCircle.width
        startY: 0
        PathLine {x: quarterCircle.width; y: quarterCircle.height}
        PathArc {
          radiusX: quarterCircle.width
          radiusY: quarterCircle.height
          x: 0
          y: 0
        }
        PathLine {x: quarterCircle.width; y: 0}
      }
    }
  }
}
