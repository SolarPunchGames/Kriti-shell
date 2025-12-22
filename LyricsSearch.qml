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
        loadingDots.running = false
      }
    }
  }

  ColumnLayout {
    id: column
    anchors.fill: parent
    anchors.margins: 5
    anchors.topMargin: 0
    spacing: 10
    Item {
      Layout.fillWidth: true
      Layout.preferredHeight: 60

      LoadingDots {
        anchors.fill: parent
        running: Players.defaultLyrics == 1 ? true : false
        scaleMult: 0.5
      }

      RowLayout {
        anchors.fill: parent
        visible: Players.defaultLyrics.plainLyrics ? true : false

        Text {
          Layout.fillWidth: true
          Layout.leftMargin: 35

          text: "Default \nlyrics:"

          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignTop

          font.pointSize: 8
          font.family: "JetBrainsMono Nerd Font"

          color: Colors.text
        }
        BaseButton {
          id: result

          Layout.fillWidth: true
          Layout.rightMargin: 35

          text: TextServices.truncate(Players.defaultLyrics.name, (width - 20) / fontSize)

          padding: 10

          fontSize: 10

          clip: true

          backgroundAlias.border.color: Colors.separator
          backgroundAlias.border.width: 1

          onClicked: {
            Players.areLyricsCustom = false
            Players.lyricsChanged()
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

                font.pointSize: 6
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

                text: Players.trackLyrics.artistName ? TextServices.truncate(Players.trackLyrics.name, (column.width) / font.pointSize) : ""

                visible: Players.trackLyrics.artistName ? true : false
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

                text: Players.trackLyrics.duration ? TextServices.secondsToMinutesSeconds(Players.trackLyrics.duration) : ""

                visible: Players.trackLyrics.duration ? true : false
              }
            }
          }
        }
      }
    }
    Text {
      Layout.fillWidth: true

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
      rightPadding: 45

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
          results = []
          if (searchField.text != "") {  
            searchProc.running = false
            searchProc.running = true
            loadingDots.running = true
          } 
        }
      }
    }

    ListView {
      Layout.fillWidth: true
      Layout.fillHeight: true

      model: results

      clip: true

      spacing: 5

      populate: Transition {
        id: lyricAddTrans
        SequentialAnimation {
          PropertyAnimation { properties: "x"; to: 1000; duration: 0 }
          PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
          PropertyAnimation { 
            properties: "x"
            from: 20
            to: 0
            duration: 250
            easing.type: Easing.OutCubic
          }
        }
        SequentialAnimation {
          PropertyAnimation { properties: "opacity"; to: 0; duration: 0 }
          PauseAnimation { duration: lyricAddTrans.ViewTransition.index * 50}
          PropertyAnimation { 
            properties: "opacity"
            from: 0
            to: 1
            duration: 250
            easing.type: Easing.OutCubic
          }
        }
      }

      LoadingDots {
        id: loadingDots
        anchors.fill: parent
        running: false
      }

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