// AppMenu.qml
// MediaMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import qs.Services
import qs

Scope {
  id: root
  property alias appMenuVariants: variants

  IpcHandler {
    target: "appMenu"

    function toggle(): void {
      for (var i = 0; i < appMenuVariants.instances.length; i++) {
        var instance = appMenuVariants.instances[i]
        if (Hyprland.monitorFor(instance.modelData) == Hyprland.focusedMonitor) {
          instance.toggleOpen()
        } else {
          instance.close()
        }
      }
    }
  }
  
  Variants {
    id: variants
    model: Quickshell.screens

    ScalePanelWindow {
      id: window

      property var modelData
      screen: modelData

      WlrLayershell.keyboardFocus: scaleItemAlias.state == "open" ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

      onWindowOpened: {
        searchField.clear()
        appsView.updateApps("")
      }

      Timer {
        running: true
        interval: 1000
        repeat: true
        onTriggered: searchField.forceActiveFocus()
      }

      scaleItemAlias: scaleItem
      mainPanelAlias: mainPanel

      PanelScaleItem {
        id: scaleItem

        anchors.fill: parent

        transformOrigin: Item.Bottom

        InvertedRounding {
          anchors.bottom: mainPanel.bottom
          anchors.right: mainPanel.left
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: 90
          y: -13
        }

        InvertedRounding {
          anchors.bottom: mainPanel.bottom
          anchors.left: mainPanel.right
          roundingColor: mainPanel.color
          opacity: mainPanel.opacity
          rounding: 13
          rotation: 180
          y: -13
        }

        Rectangle {
          id: mainPanel

          width: 600
          height: {
            if (searchField.height + 5510 + appsView.count * 50 < 500) {
              searchField.height + 55 + appsView.count * appsView.currentItem.height
            } else {
              500
            }
          }

          color: Colors.mainPanelBackground

          topLeftRadius: 13
          topRightRadius: topLeftRadius

          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: parent.bottom

          layer.enabled: true

          ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.bottomMargin: 5

            Rectangle {
              Layout.fillWidth: true
              Layout.fillHeight: true

              radius: 10

              clip: true

              color: Colors.itemBackground

              ListView {
                id: appsView
                anchors.fill: parent

                topMargin: 20
                bottomMargin: 20

                maximumFlickVelocity: 2000

                property string searchQuery: ""

                function updateApps(query) {
                  model = AppSearch.searchApplications(query)
                  appsView.currentIndex = 0
                }

                verticalLayoutDirection: ListView.BottomToTop

                header: null
                footer: null

                cacheBuffer: 1000

                add: Transition {
                  id: appAddTrans
                  SequentialAnimation {
                    PropertyAnimation { properties: "x"; to: 1000; duration: 0 }
                    PauseAnimation { duration: appAddTrans.ViewTransition.index * 50}
                    PropertyAnimation { 
                      properties: "x"
                      from: 100
                      to: 0
                      duration: 250
                      easing.type: Easing.OutCubic
                    }
                  }
                }

                delegate: BaseButton {
                  id: app

                  width: appsView.width - 10

                  anchors.horizontalCenter: parent.horizontalCenter

                  backgroundColor: {
                    if (ListView.isCurrentItem) {
                      Colors.itemHoveredBackground
                    } else {
                      Colors.itemBackground
                    }
                  }

                  topPadding: 10
                  bottomPadding: 10

                  text: modelData.name

                  fontSize: 11

                  onClicked: {
                    modelData.execute()
                    window.close()
                  }
                }
              }
            }

            TextField {
              id: searchField

              Layout.fillWidth: true
              Layout.preferredHeight: 50

              font.pointSize: 12

              leftPadding: 10
              rightPadding: 10

              color: Colors.text

              onTextEdited: {
                appsView.searchQuery = searchField.text
                appsView.updateApps(appsView.searchQuery)
              }

              Keys.onReturnPressed: {
                appsView.currentItem.click()
              }

              Keys.onUpPressed: {
                appsView.incrementCurrentIndex()
              }

              Keys.onDownPressed: {
                appsView.decrementCurrentIndex()
              }

              Keys.onEscapePressed: {
                window.close()
              }

              background: Rectangle {
                radius: 10
                color: Colors.itemBackground
              }
            }
          }
        }
      }
    }
  }
}
