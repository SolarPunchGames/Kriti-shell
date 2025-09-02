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
  }

  property var parsedConfig: JSON.parse(configFile.text())

  property var audio: parsedConfig.audio
  property var media: parsedConfig.media
}