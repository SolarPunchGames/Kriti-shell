import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Services
import qs

Item {
  id: root

  property var results

  signal lyricsFound()

  Process {
    id: searchProc
    running: false
    command: [ "curl", "https://lrclib.net/api/search?q=" + encodeURI(searchField.text)]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        results = JSON.parse(text)
      }
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 10
    spacing: 10
    Text {
      Layout.fillWidth: true
      
      topPadding: 40

      Layout.preferredHeight: 70

      text: "Search for lyrics"

      horizontalAlignment: Text.AlignHCenter

      font.pointSize: 14
      font.family: "JetBrainsMono Nerd Font"
      font.weight: 700

      color: Colors.text
    }

    TextField {
      id: searchField

      Layout.fillWidth: true

      Layout.preferredHeight: 40

      font.pointSize: 11

      leftPadding: 15
      rightPadding: 15

      text: Players.player.trackTitle

      color: Colors.text

      Keys.onReturnPressed: {
        searchButton.click()
      }

      background: Rectangle {
        radius: 10
        color: "transparent"
        border.color: Colors.separator
        border.width: 1
      }

      clip: true

      BaseButton {
        id: searchButton
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.margins: 5

        backgroundAlias.radius: 5

        backgroundAlias.border.color: Colors.separator
        backgroundAlias.border.width: 1

        width: height

        text: ""

        onClicked: {
          searchProc.running = true
          results = []
        }
      }
    }

    ListView {
      Layout.fillWidth: true
      Layout.fillHeight: true

      model: results

      clip: true

      spacing: 5

      delegate: BaseButton {
        id: result

        width: parent.width

        property var data: modelData

        text: data.name

        padding: 10

        fontSize: 12

        backgroundAlias.border.color: Colors.separator
        backgroundAlias.border.width: 1

        onClicked: {
          Players.loadCustomLyrics(data.id)
          root.lyricsFound()
        }

        contentItem: Column {
          Text {
            id: textItem
            font.pointSize: result.fontSize
            font.family: "JetBrainsMono Nerd Font"

            width: parent.width

            color: Colors.text

            topPadding: result.textTopPadding
            bottomPadding: result.textBottomPadding
            leftPadding: result.textLeftPadding
            rightPadding: result.textRightPadding

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.WordWrap

            text: result.text
          }
          RowLayout {
            width: parent.width
            Text {
              id: artistItem

              Layout.fillWidth: true

              font.pointSize: 7
              font.family: "JetBrainsMono Nerd Font"

              color: Colors.text
              opacity: 0.7

              topPadding: result.textTopPadding
              bottomPadding: result.textBottomPadding
              leftPadding: result.textLeftPadding
              rightPadding: result.textRightPadding

              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter

              wrapMode: Text.WordWrap

              text: result.data.artistName ? result.data.artistName : ""

              visible: result.data.artistName ? true : false
            }
            Text {
              id: duration

              Layout.fillWidth: true

              font.pointSize: 7
              font.family: "JetBrainsMono Nerd Font"

              color: Colors.text
              opacity: 0.7

              topPadding: result.textTopPadding
              bottomPadding: result.textBottomPadding
              leftPadding: result.textLeftPadding
              rightPadding: result.textRightPadding

              horizontalAlignment: Text.AlignRight
              verticalAlignment: Text.AlignVCenter

              wrapMode: Text.WordWrap

              text: result.data.duration ? TextServices.secondsToMinutesSeconds(result.data.duration) : ""

              visible: result.data.duration ? true : false
            }
          }
        }
      }
    }
  }
}