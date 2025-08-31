// Bar.qml
import QtQuick
import Quickshell
import qs.Services
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

      color: Colors.mainPanelBackground

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

      // Center widgets
      Row {
        anchors.centerIn: parent
        //LegacyMediaPlayerWidget {}
        MediaPlayerWidget {currentScreen: screen.name}
      }

      // Right widgets
      Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        ShutdownTimerWidget {}
        Separator {}
        VolumeWidget {}
        ClockWidget {}
        DateWidget {}
        PowerButtonWidget {currentScreen: screen.name}
        Separator {}
        TrayWidget {}
        Separator {}
      }
    }
  }
}