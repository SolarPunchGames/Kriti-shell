// Config.qml
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  FileView {
    id: configFile
    path: Qt.resolvedUrl("../settings.json")
    blockLoading: true

    watchChanges: true
    onFileChanged: this.reload()

    onLoadFailed: (error) => {
      if (error == FileViewError.FileNotFound) {
        copyDefaultsProc.running = true
      }
    }
  }

  Process {
    id: copyDefaultsProc
    running: true
    command: [ "sh", "-c", "cp " + Quickshell.shellDir + "/defaultSettings.json " + Quickshell.shellDir + "/settings.json" ]
    stdout: StdioCollector {
      onStreamFinished: {
        configFile.reload
      }
    }
  }

  property var parsedConfig: JSON.parse(configFile.text())

  property var audio: parsedConfig.audio
  property var media: parsedConfig.media
}