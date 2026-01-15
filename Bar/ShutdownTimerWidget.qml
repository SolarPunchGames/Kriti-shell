// ShutdownTimerWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import qs

Item {
  MarginWrapperManager { margin: 5 }

  TextIconButton {
    id: button

    text: {
      if (Config.miscellaneous.shutdownWidget) {
        if (shutdown.timeToTargetTimeSeconds <= 900 && Config.miscellaneous.shutdownWidget.enableShutdown.value) {
          if (shutdown.timeToTargetTimeSeconds <= shutdown.responseTime) {
            shutdown.timeToTargetTime + "!"
          } else {
            shutdown.timeToTargetTime
          }
        }
      }
    }

    bigTextItem.text: "󰒲"
    bigTextItem.font.pointSize: 15

    implicitHeight: 30
    implicitWidth: textAlias.contentWidth ? textAlias.contentWidth + 20 : 0

    backgroundColor: Colors.itemWarningBackground

    readonly property var shutdown: Time.shutdown

    FrameAnimation {
      running: true

      onTriggered: {
        if (Config.miscellaneous.shutdownWidget) {
          if (button.shutdown.timeToTargetTimeSeconds < 0 && Config.miscellaneous.shutdownWidget.enableShutdown.value) {
            Quickshell.execDetached(["systemctl", "poweroff"])
          }
        }
      }
    }
    
    onClicked: {
      if (shutdown.timeToTargetTimeSeconds < shutdown.responseTime) {
        shutdown.targetTime = TextServices.secondsToHoursMinutesSeconds(shutdown.timeSeconds + shutdown.responseTime)
      }
    }
  }
}
