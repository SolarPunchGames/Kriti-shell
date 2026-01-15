// Time.qml
pragma Singleton

import Quickshell
import QtQuick
import qs.Services

Singleton {
  id: root
  readonly property string date: {
    Qt.formatDateTime(clock.date, "ddd d MMM")
  }
  readonly property string time: {
    Qt.formatDateTime(clock.date, "hh:mm")
  }
  readonly property string hoursMinutesSeconds: {
    Qt.formatDateTime(clock.date, "hh:mm:ss")
  }
  readonly property string hours: {
    Qt.formatDateTime(clock.date, "hh")
  }
  readonly property string minutes: {
    Qt.formatDateTime(clock.date, "mm")
  }
  readonly property string seconds: {
    Qt.formatDateTime(clock.date, "ss")
  }

  readonly property bool isLate: {
    var start = TextServices.hoursMinutesSecondsToSeconds(Config.miscellaneous?.clockWidget?.lateStartTime?.value)
    var end = TextServices.hoursMinutesSecondsToSeconds(Config.miscellaneous?.clockWidget?.lateEndTime?.value)
    var secs = TextServices.hoursMinutesSecondsToSeconds(hoursMinutesSeconds)

    if (Config.miscellaneous?.clockWidget?.changeToRedWhenLate?.value ?? false) {
      if (start <= end) {
        secs > start && secs < end 
      } else {
        secs > start || secs < end 
      }
    } else {
      false
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  property alias shutdown: shutdownObject

  Timer {
    running: true
    interval: 1000
    repeat: true

    onTriggered: {
      if (Config.miscellaneous?.shutdownWidget?.enableShutdown?.value) {
        if (shutdownObject.timeToTargetTimeSeconds == 900) {
          Quickshell.execDetached(["notify-send", " 15 minutes", " Your PC will shut down in 15 minutes"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 600) {
          Quickshell.execDetached(["notify-send", " 10 minutes", " Your PC will shut down in 10 minutes"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 300) {
          Quickshell.execDetached(["notify-send", " 5 minutes", " Your PC will shut down in 5 minutes"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 180) {
          Quickshell.execDetached(["notify-send", " 3 minutes", " Your PC will shut down in 3 minutes"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 120) {
          Quickshell.execDetached(["notify-send", " 2 minutes", " Your PC will shut down in 2 minutes"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 60) {
          Quickshell.execDetached(["notify-send", " 1 minutes", " Your PC will shut down in 1 minute"])
        } else if (shutdownObject.timeToTargetTimeSeconds == 15) {
          Quickshell.execDetached(["notify-send", " 15 seconds", " Your PC will shut down in 15 seconds"])
        }
      }
    }
  }

  QtObject {
    id: shutdownObject

    property int responseTime: Config.miscellaneous?.shutdownWidget?.responseTime?.value ?? 120

    property string targetTime: Config.miscellaneous?.shutdownWidget?.shutdownTime?.value ?? "25:00:00"

    readonly property int targetTimeSeconds: TextServices.hoursMinutesSecondsToSeconds(targetTime)
    readonly property int timeSeconds: TextServices.hoursMinutesSecondsToSeconds(Time.hoursMinutesSeconds)
    readonly property int timeToTargetTimeSeconds: targetTimeSeconds - timeSeconds
    readonly property string timeToTargetTime: TextServices.secondsToMinutesSeconds(timeToTargetTimeSeconds)
  }
}
