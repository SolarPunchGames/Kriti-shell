// TextServices.qml
pragma Singleton

import Quickshell

Singleton {
  function truncate(text:string, maxLetters:int) : string {
    if (text.length > maxLetters + 1) {
      return text.slice(0, maxLetters) + ".."
    }
    else {
      return text
    }
  }

  function secondsToMinutesSeconds(time) {
    var minutes = Math.floor(time / 60);
    var seconds = Math.floor(time % 60);
    return (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
  }

  function secondsToHoursMinutesSeconds(time) {
    var hours = Math.floor(time / 3600);
    var minutes = Math.floor(time / 60 - hours * 60);
    var seconds = Math.floor(time % 60);
    return (hours < 10 ? "0" + hours : hours) + ":" +(minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
  }

  function hoursMinutesSecondsToSeconds(time) {
    var hours = time.slice(0,2)
    var minutes = time.slice(3,5)
    var seconds = time.slice(6,8)
    return parseInt(hours) * 3600 + parseInt(minutes) * 60 + parseInt(seconds)
  }
}