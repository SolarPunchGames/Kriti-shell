// PowerMenu.qml
import QtQuick
import QtQuick.Shapes
import Quickshell
import ".."

Scope {
  property alias powerMenuVariants: variants
  
  Variants {
    id: variants
    model: Quickshell.screens

    PanelWindow {
      id: window

      property var modelData
      screen: modelData

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
        width: quarterCircle.width * 2 * quarterCircle.scale
        height: quarterCircle.height * 2 * quarterCircle.scale
        shape: RegionShape.Ellipse
      }

      function toggleOpen() {
        if (quarterCircle.state == "open") {
          quarterCircle.state = ""
        } else {
          quarterCircle.state = "open"
        }
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

        transformOrigin: Item.TopRight

        scale: 0

        states: [
          State {
            name: "open"
            PropertyChanges {target: quarterCircle; scale: 1}
          }
        ]

        transitions: Transition {
          PropertyAnimation {
            property: "scale"
            duration: 250
            easing.type: Easing.OutCubic
          }
        }

        BaseButton {
          id: bigButton

          x: quarterCircle.width

          background: Shape {
            ShapePath {
              fillColor: {
                if (bigButton.down) {
                  "#cfff7d"
                }
                else if (bigButton.mouseAreaAlias.hovered) {
                  "#efffd3"
                }
                else {
                  "#fbfff4"
                }
              }
              strokeColor: "transparent"

              startX: -5
              startY: 5
              PathLine {x: -5; y: quarterCircle.height / 2 - 5}
              PathArc {
                radiusX: quarterCircle.width / 2 - 5
                radiusY: quarterCircle.height / 2 - 5
                x: -quarterCircle.width / 2 - 5
                y: 5
              }
              PathLine {x: -5; y: 5}
            }
          }
        }
        
//        BaseButton {
//          id: smallButtonRight
//
//          background: Shape {
//            ShapePath {
//              fillColor: {
//                if (button.down) {
//                  "#cfff7d"
//                }
//                else if (button.mouseAreaAlias.hovered) {
//                  "#efffd3"
//                }
//                else {
//                  "#fbfff4"
//                }
//              }
//              strokeColor: "transparent"
//
//              startX: quarterCircle.width - 5
//              startY: 5
//              PathLine {x: quarterCircle.width - 5; y: quarterCircle.height / 2 - 5}
//              PathArc {
//                radiusX: quarterCircle.width / 2 - 5
//                radiusY: quarterCircle.height / 2 - 5
//                x: quarterCircle.width / 2
//                y: 5
//              }
//              PathLine {x: quarterCircle.width - 5; y: 5}
//            }
//          }
//        }
      }
    }
  }
}
