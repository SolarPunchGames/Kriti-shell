// TrayWidget.qml
import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Services
import qs

Item {
  id: root
  MarginWrapperManager {margin: 5}

  Rectangle {
    implicitHeight: 30

    implicitWidth: {
      if (row.width == 0) {
        0
      } else {
        row.width + 20
      }
    }

    radius: 10

    color: Colors.itemBackground

    Row {
      id: row
      anchors.centerIn: parent
      spacing: 10
      Repeater {
        model: {
          SystemTray.items
        }
        delegate: BaseButton {
          id: button

          backgroundAlias.radius: 5
          implicitHeight: 17
          implicitWidth: implicitHeight

          backgroundAlias.color: "transparent"

          MouseArea {
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            acceptedButtons: Qt.AllButtons

            onClicked: (mouse)=> {
              if (mouse.button == Qt.LeftButton) {
                modelData.activate()
              } else if (mouse.button == Qt.MiddleButton) {
                modelData.secondaryActivate() 
              } else if (mouse.button == Qt.RightButton) {
                modelData.display(QsWindow.window, mapToItem(QsWindow.window.contentItem,mouse.x, mouse.y).x, mapToItem(QsWindow.window.contentItem,mouse.x, mouse.y).y)
              }
            }
          }


          QsMenuAnchor {
            id: menuOpener
            anchor.item: button
            menu: button.menu
          }

          Image {
            id: icon

            anchors.fill: button
            source: modelData.icon

            mipmap: true
            smooth: true
          }

          ColorOverlay {
            anchors.fill: icon
            source: icon
            color: {
              if (!Colors.isDark && modelData.title == "Free Download Manager") {
                "#517ac5"
              } else {
                "transparent"
              }
            }
          }
        }
      }
    }
  }
}
