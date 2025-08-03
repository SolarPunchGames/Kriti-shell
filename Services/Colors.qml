// Colors.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Main colors
  readonly property color mainPanelBackground: "#d1ddbe"
  readonly property color itemBackground: "#fbfff4"
  readonly property color itemHoveredBackground: "#efffd3"
  readonly property color itemPressedBackground: "#efffd3"
  readonly property color text: "#000000"
  readonly property color itemText: text
  readonly property color separator: "#8b9973"
}