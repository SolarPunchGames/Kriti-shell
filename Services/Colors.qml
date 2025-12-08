// Colors.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Main colors
  
  //readonly property bool isDark: false
  //readonly property color mainPanelBackground: "#d1ddbe"
  //readonly property color itemBackground: "#fbfff4"
  //readonly property color itemHoveredBackground: "#dcf3b4"
  //readonly property color itemPressedBackground: "#cfff7d"
  //readonly property color itemDisabledBackground: "#deebce"
  //readonly property color text: "#000000"
  //readonly property color bigText: "#000000"
  //readonly property color smallText: "#000000"
  //readonly property color separator: "#b0be97"

  readonly property bool isDark: true
  readonly property color mainPanelBackground: "#091829"
  readonly property color itemBackground: "#1c2c3a"
  readonly property color itemWarningBackground: "#af4b44"
  readonly property color itemHoveredBackground: "#277262"
  readonly property color itemPressedBackground: "#4ea781"
  readonly property color itemDisabledBackground: mainPanelBackground
  readonly property color text: "#ffffff"
  readonly property color bigText: "#ffffff"
  readonly property color smallText: "#ffffff"
  readonly property color separator: "#255a4d"

  readonly property int colorTransitionTime: 50
}