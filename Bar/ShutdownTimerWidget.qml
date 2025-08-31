// ShutdownTimerWidget.qml
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Services
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  TextIconButton {
    id: button

    text: {
      if (shutdown.timeToTargetTimeSeconds <= 900) {
        if (shutdown.timeToTargetTimeSeconds <= shutdown.responseTime) {
          shutdown.timeToTargetTime + "!"
        } else {
          shutdown.timeToTargetTime
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
        if (button.shutdown.timeToTargetTimeSeconds <= 0) {
          Quickshell.execDetached(["systemctl", "poweroff"])
        }
      }
    }
    
    onClicked: {
      //if (shutdown.timeToTargetTimeSeconds < shutdown.responseTime) {
        shutdown.targetTime = TextServices.secondsToHoursMinutesSeconds(shutdown.timeSeconds + shutdown.responseTime)
      //}
    }
  }
}
