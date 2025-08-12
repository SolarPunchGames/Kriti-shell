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
  readonly property string hours: {
    Qt.formatDateTime(clock.date, "hh")
  }
  readonly property string minutes: {
    Qt.formatDateTime(clock.date, "mm")
  }
  readonly property string seconds: {
    Qt.formatDateTime(clock.date, "ss")
  }

  readonly property bool isLate: Time.hours >= 21 || Time.hours <= 6

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}