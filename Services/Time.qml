// Time.qml
pragma Singleton

import Quickshell
import QtQuick

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

  readonly property bool isLate: Time.hours >= 20 || Time.hours <= 6

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  property alias shutdown: shutdownObject

  QtObject {
    id: shutdownObject

    property int responseTime: 60

    property string targetTime: "23:00:00"
    readonly property int targetTimeSeconds: TextServices.hoursMinutesSecondsToSeconds(targetTime)
    readonly property int timeSeconds: TextServices.hoursMinutesSecondsToSeconds(Time.hoursMinutesSeconds)
    readonly property int timeToTargetTimeSeconds: targetTimeSeconds - timeSeconds
    readonly property string timeToTargetTime: TextServices.secondsToMinutesSeconds(timeToTargetTimeSeconds)
  }
}