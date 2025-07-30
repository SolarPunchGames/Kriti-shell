// PowerMenu.qml
import QtQuick
import Quickshell

Scope {
  PanelWindow {
    anchors {
      top: true
      right: true
    }

    color: "transparent"

    implicitHeight: quarterCircle.height / 2
    implicitWidth: quarterCircle.width / 2

    mask: Region {  
      x: quarterCircle.x  
      y: quarterCircle.y  
      width: quarterCircle.width  
      height: quarterCircle.height  
      shape: RegionShape.Ellipse  // This might get you closer to a rounded shape  
    }

    Rectangle {
      id: quarterCircle

      anchors.right: parent.right
      anchors.top: parent.top

      anchors.topMargin: -height / 2
      anchors.rightMargin: -height / 2
      
      implicitHeight: 630
      implicitWidth: implicitHeight

      color: "#d1ddbe"

      radius: height / 2

      property bool open: false

      ScaleAnimator {
        id: openAnimation
        target: quarterCircle;
        from: 0;
        to: 1;
        duration: 500
        running: true
        easing.type: Easing.OutCubic
      }

      ScaleAnimator {
        id: closeAnimation
        target: quarterCircle;
        from: 1;
        to: 0;
        duration: 500
        running: false
        easing.type: Easing.OutCubic
      }
    }
  }
}
