// Colors.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Legacy theme (absolute shit)
  
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


  // Dark blue / green

  readonly property bool isDark: true
  readonly property color mainPanelBackground: "#091829"
  readonly property color itemBackground: "#1c2c3a"
  readonly property color itemHoveredBackground: "#277262"
  readonly property color itemPressedBackground: "#4ea781"
  readonly property color itemWarningBackground: '#bb4037'
  readonly property color itemHoveredWarningBackground: '#e24747'
  readonly property color itemPressedWarningBackground: '#ff756b'
  readonly property color itemDisabledBackground: mainPanelBackground
  readonly property color text: "#ffffff"
  readonly property color bigText: "#ffffff"
  readonly property color smallText: "#ffffff"
  readonly property color separator: "#277262"


  // Catppuccin Mocha

  //readonly property bool isDark: true
  //readonly property color mainPanelBackground: "#1e1e2e"
  //readonly property color itemBackground: "#313244"
  //readonly property color itemHoveredBackground: '#585b70'
  //readonly property color itemPressedBackground: "#b4befe"
  //readonly property color itemWarningBackground: '#923c54'
  //readonly property color itemHoveredWarningBackground: '#923c54'
  //readonly property color itemPressedWarningBackground: '#923c54'
  //readonly property color itemDisabledBackground: mainPanelBackground
  //readonly property color text: "#cdd6f4"
  //readonly property color bigText: "#cdd6f4"
  //readonly property color smallText: "#a6adc8"
  //readonly property color separator: "#999184"

  readonly property int colorTransitionTime: 50
}