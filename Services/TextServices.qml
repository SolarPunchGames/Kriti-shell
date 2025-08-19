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

  function formatSecondsToMinutesAndSeconds(seconds) {
    var minutes = Math.floor(seconds / 60);
    var secs = seconds % 60;
    return (minutes < 10 ? "0" + minutes : minutes) + ":" + (secs < 10 ? "0" + secs : secs);
  }
}