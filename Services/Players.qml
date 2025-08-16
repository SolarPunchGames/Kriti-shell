// Audio.qml
pragma Singleton

import QtQml
import Quickshell
import Quickshell.Services.Mpris

Singleton {
  id: root

  property int playerId: 0
  readonly property MprisPlayer player: Mpris.players.values[playerId]
}