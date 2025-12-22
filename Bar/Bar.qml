// Bar.qml
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.Services
import qs

Scope {
  id: root
  property alias barVariants: variants

  Component.onCompleted: WindowManager.barVariants = barVariants
  
  IpcHandler {
    target: "bar"

    function openCurrent() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        if (Hyprland.monitorFor(instance.modelData) == Hyprland.focusedMonitor) {
          instance.open()
        }
      }
    }

    function closeCurrent() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        if (Hyprland.monitorFor(instance.modelData) == Hyprland.focusedMonitor) {
          instance.close()
        }
      }
    }

    function toggleCurrent() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        if (Hyprland.monitorFor(instance.modelData) == Hyprland.focusedMonitor) {
          instance.toggleOpen()
        }
      }
    }

    function openAll() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        instance.open()
      }
    }

    function closeAll() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        instance.close()
      }
    }

    function toggleAll() {
      for (var i = 0; i < barVariants.instances.length; i++) {
        var instance = barVariants.instances[i]
        instance.toggleOpen()
      }
    }
  }

  Variants {
    id: variants
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

//      InvertedRounding {
//        roundingColor: mainWindow.color
//      }

      color: Colors.mainPanelBackground

      implicitHeight: 36

      property var state: mainRect.state

      function open() {
        mainRect.state = ""

      }

      function close() {
        mainRect.state = "closed"
        //for (var i = 0; i < WindowManager.mediaMenuVariants.instances.length; i++) {
        //  var instance = WindowManager.mediaMenuVariants.instances[i]
        //  console.log(WindowManager.mediaMenuVariants.instances.length)
        //  if (instance.screen == mainWindow.screen) {
        //    instance.open()
        //    console.log("instance closed on " + instance.screen)
        //  }
        //}
        //for (var i = 0; i < WindowManager.powerMenuVariants.instances.length; i++) {
        //  var instance = WindowManager.powerMenuVariants.instances[i]
        //  if (instance.screen == mainWindow.screen) {
        //    instance.close()
        //  }
        //}
      }

      function toggleOpen() {
        if (mainRect.state == "closed") {
          open()
        } else {
          close()
        }
      }

      function openAll() {
        for (var i = 0; i < barVariants.instances.length; i++) {
          var instance = barVariants.instances[i]
          instance.open()
        }
      }

      function closeAll() {
        for (var i = 0; i < barVariants.instances.length; i++) {
          var instance = barVariants.instances[i]
          instance.close()
        }
      }

      function toggleAll() {
        for (var i = 0; i < barVariants.instances.length; i++) {
          var instance = barVariants.instances[i]
          instance.toggleOpen()
        }
      }

      function isAnyClosed() {
        for (var i = 0; i < barVariants.instances.length; i++) {
          var instance = barVariants.instances[i]
          if (instance.state == "closed") return true;
        }
      }

      MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.RightButton

        onClicked: rightClickMenu.open()
      }

      Rectangle {
        id: mainRect
        anchors.fill: parent
        color: "transparent"

        visible: {
          if (opacity == 0) {
            false
          } else {
            true
          }
        }

        states: [
          State {
            name: "closed"
            PropertyChanges {target: mainWindow; implicitHeight: 3}
            PropertyChanges {target: mainRect; opacity: 0}
          },
          State {
            name: ""
            PropertyChanges {target: mainWindow; implicitHeight: 36}
            PropertyChanges {target: mainRect; opacity: 1}
          }
        ]

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

      Popup {
        id: rightClickMenu
        anchor.item: mainRect

        onWindowOpened: {
          anchor.rect.x = mouseArea.mouseX
          anchor.rect.y = mouseArea.mouseY
        }

        listAlias.model: [
          {
            customText: true,
            getText() {
              if (mainWindow.isAnyClosed()) {
                return "Show all bars"
              } else {
                return "Hide all bars"
              }
            },
            activate() {
              if (mainWindow.isAnyClosed()) {
                mainWindow.openAll()
              } else {
                mainWindow.closeAll()
              }
            },
          },
          {
            customText: true,
            getText() {
              if (mainRect.state == "closed") {
                return "Show bar"
              } else {
                return "Hide bar"
              }
            },
            activate() {
              mainWindow.toggleOpen()
            },
          },
        ]
      }
    }
  }
}