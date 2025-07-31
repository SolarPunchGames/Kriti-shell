// Bar.qml
import QtQuick
import Quickshell
import "../PowerMenu/"
import "Workspaces"
import ".."

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

      InvertedRounding {
        roundingColor: mainWindow.color
      }

      color: "#d1ddbe"

      implicitHeight: 36
      
      // Left widgets
      Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        Separator {}
        WorkspaceWidget {currentScreen: screen}
        Separator {}
        CurrentAppWidget {}
      }

      // Right widgets
      Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        Separator {}
        VolumeWidget {}
        ClockWidget {}
        DateWidget {}
        PowerButtonWidget {currentScreen: screen.name}
        Separator {}
        Separator {}
      }
    }
  }
}