// SettingsWindow.qml

import Quickshell
import QtQuick
import qs.Services

FloatingWindow {
  id: root

  color: Colors.mainPanelBackground

  function getSettingsModel(source = {}) {
    listModel = []

    for (const key of Object.keys(source)) {
      for (const key2 of Object.keys(source[key])) {
        for (const key3 of Object.keys(source[key][key2])) {
          const key3Object = source[key][key2][key3]
          console.log(key3Object.name)
          listModel.push({
            text: key3Object.name,
            type: key3Object.type
          })
        }
      }
    }

    console.log(JSON.stringify(listModel, null, 2))
  }

  Component.onCompleted: getSettingsModel(Config.parsedConfig)

  property var listModel: []

  Connections {
    target: Config
    function onConfigChanged() {
      getSettingsModel(Config.parsedConfig)
    }
  }

  ListView {
    anchors.fill: parent
    model: listModel

    delegate: Text {
      property var data: modelData

      text: data.text
    }
  }
}