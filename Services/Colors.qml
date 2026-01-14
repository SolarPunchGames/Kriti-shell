// Colors.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  // Dark blue / green

  readonly property bool isDark: true
  readonly property color mainPanelBackground: "#091829"
  readonly property color menuBackground: '#2e3e4b'
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

  // readonly property bool isDark: true
  // readonly property color mainPanelBackground: "#181825"
  // readonly property color menuBackground: "#45475a"
  // readonly property color itemBackground: "#313244"
  // readonly property color itemHoveredBackground: '#585b70'
  // readonly property color itemPressedBackground: '#9399b2'
  // readonly property color itemWarningBackground: '#923c54'
  // readonly property color itemHoveredWarningBackground: '#923c54'
  // readonly property color itemPressedWarningBackground: '#923c54'
  // readonly property color itemDisabledBackground: mainPanelBackground
  // readonly property color text: "#cdd6f4"
  // readonly property color bigText: "#cdd6f4"
  // readonly property color smallText: "#a6adc8"
  // readonly property color separator: "#585b70"

  readonly property int colorTransitionTime: 50
}
