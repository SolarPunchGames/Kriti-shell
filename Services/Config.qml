// Config.qml
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs

Singleton {
  id: root

  FileView {
    id: configFile
    path: Qt.resolvedUrl("../settings.json")
    blockLoading: true

    watchChanges: true
    onFileChanged: {
      this.reload()
      root.configChanged()
    }

    onLoadFailed: (error) => {
      if (error == FileViewError.FileNotFound) {
        windowComponent.createObject(root)
      }
    }
  }

  signal configChanged()

  FileView {
    id: defaultsConfigFile
    path: Qt.resolvedUrl("../defaultSettings.json")
    blockLoading: true

    watchChanges: true
    onFileChanged: this.reload()
  }

  Component {
    id: windowComponent
    FloatingWindow {
      id: confirmationWindow
      color: Colors.mainPanelBackground

      minimumSize: Qt.size(400, 200)
      maximumSize: Qt.size(400, 200)
      ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        Text {
          Layout.fillWidth: true
          Layout.fillHeight: true
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          text: "No config file found. Copy defaults?"
          color: Colors.text
          font.pointSize: 11
          font.family: "JetBrainsMono Nerd Font"
        }
        RowLayout {
          Layout.fillWidth: true
          Layout.fillHeight: true
          uniformCellSizes: true
          spacing: 10
          BaseButton {
            text: "Yes"
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
              copyDefaultsProc.running = true
              confirmationWindow.destroy()
            }
          }
          BaseButton {
            text: "No"
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: confirmationWindow.destroy()
          }
        }
      }
    }
  }

  Process {
    id: copyDefaultsProc
    running: false
    command: [ "sh", "-c", "cp " + Quickshell.shellDir + "/defaultSettings.json " + Quickshell.shellDir + "/settings.json" ]
    stdout: StdioCollector {
      onStreamFinished: {
        configFile.reload
      }
    }
  }

  property var parsedConfig: JSON.parse(configFile.text())
  property var parsedDefaultConfig: JSON.parse(defaultsConfigFile.text())

  property var audio: parsedConfig.audio
  property var media: parsedConfig.media
  property var miscellaneous: parsedConfig.miscellaneous
  property var style: parsedConfig.style

  function isPlainObject(x) {
    return typeof x === 'object' && x !== null && !Array.isArray(x);
  }

  function needsMerge(target = {}, source = {}) {
    if (!isPlainObject(source)) return false;
    for (const key of Object.keys(source)) {
      if (!(key in target)) return true;
      const sVal = source[key];
      const tVal = target[key];
      if (isPlainObject(sVal) && isPlainObject(tVal)) {
        if (needsMerge(tVal, sVal)) return true;
      }
    }
    return false;
  }

  function nonDestructiveMerge(target = {}, source = {}) {
    const result = Array.isArray(target) ? target.slice() : target;
    if (!isPlainObject(source)) return result;
    for (const key of Object.keys(source)) {
      var sVal = source[key];
      var tVal = result[key];
      if (!(key in result)) {
        result[key] = sVal;
      } else if (isPlainObject(tVal) && isPlainObject(sVal)) {
        result[key] = nonDestructiveMerge(tVal, sVal);
      }
    }
    return result;
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      if (needsMerge(parsedConfig, parsedDefaultConfig)) {
        configFile.setText(JSON.stringify(nonDestructiveMerge(parsedConfig, parsedDefaultConfig), null, 2))
      }
    }
  }
}
