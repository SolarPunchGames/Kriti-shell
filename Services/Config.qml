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
    onFileChanged: this.reload()

    onLoadFailed: (error) => {
      if (error == FileViewError.FileNotFound) {
        windowComponent.createObject(root)
      }
    }
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