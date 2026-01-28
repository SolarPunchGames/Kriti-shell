// PlayersPopup.qml

import QtQuick
import QtQuick.Layouts
import qs.Services
import qs

Popup {
  id: playersPopup

  backgroundAlias.width: 11 * 15

  listAlias.model: Players.players

  listAlias.delegate: BaseButton {
    id: playersListButton

    property var data: modelData

    text: TextServices.truncate(modelData.identity, 13)

    backgroundColor: Colors.menuBackground

    contentItem: RowLayout {
      Text {
        id: checkItem
        font.pointSize: playersListButton.fontSize
        font.family: Config.style.font.value

        Layout.fillWidth: true

        color: Colors.text

        topPadding: playersListButton.textTopPadding
        bottomPadding: playersListButton.textBottomPadding
        leftPadding: playersListButton.textLeftPadding
        rightPadding: playersListButton.textRightPadding

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        wrapMode: Text.WordWrap

        text: "󰸞"

        opacity: {
          if (playersListButton.data == Players.player) {
            1
          } else {
            0
          }
        }
      }
      Column {
        Layout.fillWidth: true
        Text {
          id: textItem
          font.pointSize: playersListButton.fontSize
          font.family: Config.style.font.value


          color: Colors.text

          topPadding: playersListButton.textTopPadding
          bottomPadding: playersListButton.textBottomPadding
          leftPadding: playersListButton.textLeftPadding
          rightPadding: playersListButton.textRightPadding

          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          wrapMode: Text.WordWrap

          text: playersListButton.text
        }
        Text {
          id: descriptionItem
          font.pointSize: 6
          font.family: Config.style.font.value

          width: playersListButton.width

          color: Colors.text
          opacity: 0.7

          topPadding: playersListButton.textTopPadding
          bottomPadding: playersListButton.textBottomPadding
          leftPadding: playersListButton.textLeftPadding
          rightPadding: playersListButton.textRightPadding

          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          wrapMode: Text.WordWrap

          text: TextServices.truncate(playersListButton.player.trackTitle, 25)
        }
      }
    }

    textLeftPadding: 5

    anchors.left: parent.left
    anchors.right: parent.right

    backgroundAlias.radius: playersPopup.backgroundAlias.radius - playersList.anchors.margins
    padding: 5

    property var player: Players.players[index]

    onClicked: {
      playersPopup.close()
      Players.customPlayerId = index
    }
  }
}