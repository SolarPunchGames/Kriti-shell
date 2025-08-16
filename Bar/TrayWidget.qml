// TrayWidget.qml
import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.Services
import ".."

Item {
  id: root
  MarginWrapperManager {margin: 5}

  Rectangle {
    implicitHeight: 30

    implicitWidth: row.width + 20

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
          implicitHeight: 30 - 11
          implicitWidth: implicitHeight

          backgroundAlias.color: "transparent"

          onClicked: modelData.activate()

          Image {
            id: icon

            anchors.fill: button
            source: modelData.icon
          }

          ColorOverlay {
            anchors.fill: icon
            source: icon
            color: {
              if (!Colors.isDark && modelData.title == "Free Download Manager") {
                "#517ac5"
              }
            }
          }
        }
      }
    }
  }
}
