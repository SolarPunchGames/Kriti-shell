// Audio.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  readonly property bool muted: sink?.audio?.muted ?? false
  property real volume

  function setVolume(volume: real): void {
    if (sink?.ready && !isNaN(sink?.audio?.volume)) {
      sink.audio.muted = false;
      sink.audio.volume = volume;
    } else {
      // I have a device that doesn't like the approach above, so this is here as a backup
      Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_SINK@", volume])
    }
  }

  // I have a device that doesn't like the other approach, so this is here as a backup
  Process {
    id: getVolProc

    command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]

    running: false

    stdout: StdioCollector {
      onStreamFinished: {
        root.volume = this.text.slice(8, 12) // ik this looks dumb, but 0.58 * 100 is apparently 57.9999999.. this fixes that.
      }
    }
  }

  Timer {
    interval: 50

    running: true

    repeat: true

    onTriggered: {
      if (!isNaN(sink?.audio?.volume)) {
        root.volume = sink?.audio?.volume ?? 0
      } else {
        getVolProc.running = true
      }
    }
  }

  PwObjectTracker {
    objects: [root.sink, root.source]
  }
}