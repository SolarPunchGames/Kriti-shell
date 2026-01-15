// Colors.qml
pragma Singleton

import Quickshell
import QtQuick
import qs.Services

Singleton {
  id: root

  property var themes: {
    "legacy": {
      "isDark": true,
      "mainPanelBackground": "#091829",
      "menuBackground": '#2e3e4b',
      "itemBackground": "#1c2c3a",
      "itemHoveredBackground": "#277262",
      "itemPressedBackground": "#4ea781",
      "itemWarningBackground": '#bb4037',
      "itemHoveredWarningBackground": '#e24747',
      "itemPressedWarningBackground": '#ff756b',
      "itemDisabledBackground": "#091829",
      "text": "#ffffff",
      "bigText": "#ffffff",
      "smallText": "#ffffff",
      "separator": "#277262"
    },
    "catppuccinLatte": {
      "isDark": false,
      "mainPanelBackground": "#dce0e8", //Crust
      "menuBackground": "#e6e9ef", //Mantle
      "itemBackground": "#eff1f5", //Base
      "itemHoveredBackground": "#ccd0da", //Surface 0
      "itemPressedBackground": "#bcc0cc", //Surface 1
      "itemWarningBackground": "#d20f39", //Red
      "itemHoveredWarningBackground": "#d20f39", //Red
      "itemPressedWarningBackground": "#d20f39", //Red
      "itemDisabledBackground": "#dce0e8", //Crust
      "text": "#4c4f69", //Text
      "bigText": "#4c4f69", //Text
      "smallText": "#6c6f85", //Subtext 0
      "separator": "#acb0be" //Surface 2
    },
    "catppuccinFrappe": {
      "isDark": true,
      "mainPanelBackground": "#292c3c", //Mantle
      "menuBackground": "#51576d", //Surface 1
      "itemBackground": "#414559", //Surface 0
      "itemHoveredBackground": "#626880", //Surface 2
      "itemPressedBackground": "#949cbb", //Overlay 2
      "itemWarningBackground": "#e78284", //Red
      "itemHoveredWarningBackground": "#e78284", //Red
      "itemPressedWarningBackground": "#e78284", //Red
      "itemDisabledBackground": "#292c3c", //Mantle
      "text": "#c6d0f5", //Text
      "bigText": "#c6d0f5", //Text
      "smallText": "#a5adce", //Subtext 0
      "separator": "#626880" //Surface 2
    },
    "catppuccinMacchiato": {
      "isDark": true,
      "mainPanelBackground": "#1e2030", //Mantle
      "menuBackground": "#494d64", //Surface 1
      "itemBackground": "#363a4f", //Surface 0
      "itemHoveredBackground": "#5b6078", //Surface 2
      "itemPressedBackground": "#939ab7", //Overlay 2
      "itemWarningBackground": "#ed8796", //Red
      "itemHoveredWarningBackground": "#ed8796", //Red
      "itemPressedWarningBackground": "#ed8796", //Red
      "itemDisabledBackground": "#1e2030", //Mantle
      "text": "#cad3f5", //Text
      "bigText": "#cad3f5", //Text
      "smallText": "#a5adcb", //Subtext 0
      "separator": "#5b6078" //Surface 2
    },
    "catppuccinMocha": {
      "isDark": true,
      "mainPanelBackground": "#181825", //Mantle
      "menuBackground": "#45475a", //Surface 1
      "itemBackground": "#313244", //Surface 0
      "itemHoveredBackground": "#585b70", //Surface 2
      "itemPressedBackground": "#9399b2", //Overlay 2
      "itemWarningBackground": "#f38ba8", //Red
      "itemHoveredWarningBackground": "#f38ba8", //Red
      "itemPressedWarningBackground": "#f38ba8", //Red
      "itemDisabledBackground": "#181825", //Mantle
      "text": "#cdd6f4", //Text
      "bigText": "#cdd6f4", //Text
      "smallText": "#a6adc8", //Subtext 0
      "separator": "#585b70" //Surface 2
    },

  }

  property var theme: {
    if (themes[Config.style.theme.value]) {
      themes[Config.style.theme.value]
    } else {
      themes[Config.parsedDefaultConfig.style.theme.value]
    }
  }

  readonly property bool isDark: theme.isDark
  readonly property color mainPanelBackground: theme.mainPanelBackground
  readonly property color menuBackground: theme.menuBackground
  readonly property color itemBackground: theme.itemBackground
  readonly property color itemHoveredBackground: theme.itemHoveredBackground
  readonly property color itemPressedBackground: theme.itemPressedBackground
  readonly property color itemWarningBackground: theme.itemWarningBackground
  readonly property color itemHoveredWarningBackground: theme.itemHoveredWarningBackground
  readonly property color itemPressedWarningBackground: theme.itemPressedWarningBackground
  readonly property color itemDisabledBackground: theme.itemDisabledBackground
  readonly property color text: theme.text
  readonly property color bigText: theme.bigText
  readonly property color smallText: theme.smallText
  readonly property color separator: theme.separator

  readonly property int colorTransitionTime: 50

  Component.onCompleted: console.log(catppuccinMocha.mainPanelBackground)
}
