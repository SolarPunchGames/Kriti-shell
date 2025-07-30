// PowerButtonWidget.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  BaseButton {
    anchors.centerIn: parent
    fontSize: 9.5
    text: "⏻"

    onPressed: command("sh", "~/.config/waybar/power-menu/Power-Menu.sh")
  }
}