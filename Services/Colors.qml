// Colors.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Main colors
  readonly property bool isDark: false
  readonly property color mainPanelBackground: "#d1ddbe"
  readonly property color itemBackground: "#fbfff4"
  readonly property color itemHoveredBackground: "#e9facb"
  readonly property color itemPressedBackground: "#cfff7d"
  readonly property color itemDisabledBackground: "#deebce"
  readonly property color text: "#000000"
  readonly property color bigText: "#000000"
  readonly property color smallText: "#000000"
  readonly property color separator: "#b0be97"
}