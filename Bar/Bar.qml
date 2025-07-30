// Bar.qml
import QtQuick
import Quickshell
import "../PowerMenu/"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: mainWindow
      property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      color: "#d1ddbe"

      implicitHeight: 36
      
      // Left widgets
      Row {

      }

      // Right widgets
      Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        Separator {}
        VolumeWidget {}
        ClockWidget {}
        DateWidget {}
        PowerButtonWidget {currentScreen: screen}
        Separator {}
        Separator {}
      }
    }
  }
}