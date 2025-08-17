// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import qs.Services
import ".."

Scope {
  property alias powerMenuVariants: variants
  
  Variants {
    id: variants
    model: Quickshell.screens

    ScalePanelWindow {
      id: window

      property var modelData
      screen: modelData

      scaleItemAlias: scaleItem
      mainPanelAlias: mainPanel

      PanelScaleItem {
        id: scaleItem

        anchors.fill: parent

        transformOrigin: Item.Top

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.right: mainPanel.left
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
        }

        InvertedRounding {
          anchors.top: mainPanel.top
          anchors.left: mainPanel.right
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: -90
        }

        Rectangle {
          id: mainPanel

          width: 580
          height: 400

          color: Colors.mainPanelBackground

          bottomLeftRadius: 13
          bottomRightRadius: bottomLeftRadius

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top

          layer.enabled: true

          Row {
            id: mainRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 5

            padding: 5

            Rectangle {

              implicitWidth: mainPanel.width / 2 - 7.5
              implicitHeight: parent.height - 10

              radius: 10

              ColumnLayout {
                id: mediaColumn
                spacing: 5

                anchors.horizontalCenter: parent.horizontalCenter

                y: 5
                
                Item {
                  Layout.preferredWidth: parent.parent.width - 10
                  Layout.preferredHeight: width

                  Layout.alignment: Qt.AlignHCenter

                  RoundedImage {
                    id: img
                    source: Players.player.trackArtUrl

                    fillMode: Image.PreserveAspectCrop

                    anchors.fill: parent

                    radius: 7
                  }
                }

                Text {
                  text: TextServices.truncate(Players.player.trackTitle, 26)

                  Layout.preferredWidth: parent.width

                  horizontalAlignment: Text.AlignHCenter

                  font.pointSize: 11
                  font.family: "JetBrainsMono Nerd Font"

                  color: Colors.text
                }
                Text {
                  text: TextServices.truncate(Players.player.trackArtist, 35)

                  Layout.preferredWidth: parent.width
                  
                  horizontalAlignment: Text.AlignHCenter

                  font.pointSize: 8
                  font.family: "JetBrainsMono Nerd Font"

                  color: Colors.text
                }

                Row {
                  id: buttonRow
                  spacing: 5

                  Layout.alignment: Qt.AlignHCenter

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: ""

                    onClicked: Players.player.previous()
                  }

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: {
                      if (Players.player.isPlaying){
                        ""
                      } else {
                        ""
                      }
                    }

                    onClicked: Players.player.togglePlaying()
                  }

                  BaseButton {
                    implicitHeight: 50
                    implicitWidth: height

                    backgroundAlias.radius: 10

                    backgroundColor: "transparent"
                    hoveredBackgroundColor: Colors.itemDisabledBackground

                    anchors.verticalCenter: parent.verticalCenter

                    fontSize: 15
                    text: ""

                    onClicked: Players.player.next()
                  }
                }
              }
            }

            Rectangle {
              id: lyricsRect
              implicitWidth: mediaColumn.width + 10
              implicitHeight: parent.height - 10

              radius: 10

              ScrollView {
                id: lyricsScrollView

                anchors.fill: parent
                Column {
                  id: lyricsColumn

                  anchors.fill: parent

                  spacing: 10
                  topPadding: 20
                  bottomPadding: 20

                  FileView {
                    id: minunSuomeniLyrics
                    path: Qt.resolvedUrl("/home/alien/Quickshell-Rice/LyricsCache/Minun Suomeni.txt")

                    blockLoading: true
                  }

                  Repeater {
                    model: ListModel {
                      id: lyricsList
                    }
                    Component.onCompleted: {
                      var lyrics = minunSuomeniLyrics.text()
                      var lines = lyrics.split("\n");
                      for (var i = 0; i < lines.length; i++) {
                        lyricsList.append({ text: lines[i] });
                      }
                    }
                    delegate: Text {
                      required property string modelData
                      text: modelData 

                      font.pointSize: 9
                      font.family: "JetBrainsMono Nerd Font"

                      width: lyricsRect.width
                      height: 20

                      horizontalAlignment: Text.AlignHCenter

                      color: Colors.text
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}