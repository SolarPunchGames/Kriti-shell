// Popup.qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs
import qs.Services

PopupWindow {
  id: window

  anchor.edges: Edges.Top | Edges.Left

  implicitWidth: background.width + 20
  implicitHeight: background.height + 20

  mask: Region { 
    width: background.width
    height: background.height
  }

  property bool focusGrab: true

  visible: {
    if (background.opacity == 0) {
      false
    } else {
      true
    }
  }

  default property alias data: background.data

  function open() {
    background.state = "open"
    //visible = true
    windowOpened()
  }

  function close() {
    background.state = ""
    //visible = false
    windowClosed()
  }

  function toggleOpen() {
    if (background.state == "open") {
      close()
    } else {
      open()
    }
  }

  signal windowOpened()
  signal windowClosed()

  HyprlandFocusGrab {
    id: focusGrab

    active: background.state == "open" && window.focusGrab ? true : false

    onCleared: window.close()

    windows: [ window ]
  }

  color: "transparent"

  property alias backgroundAlias: background
  property alias listAlias: list

  Rectangle {
    id: background

    anchors.top: parent.top
    anchors.left: parent.left

    width: 200
    height: list.contentHeight

    transformOrigin: Item.TopLeft

    color: Colors.itemBackground

    radius: 5
    clip: true

    scale: 0.6
    opacity: 0

    states: [
      State {
        name: "open"
        PropertyChanges {target: background; scale: 1}
        PropertyChanges {target: background; opacity: 1}
      },
      State {
        name: ""
        PropertyChanges {target: background; scale: 0.6}
        PropertyChanges {target: background; opacity: 0}
      }
    ]

    transitions: Transition {
      SpringAnimation {
        property: "scale"
        spring: 5
        damping: 0.3
      }
      PropertyAnimation {
        property: "opacity"
        duration: 250
        easing.type: Easing.OutCubic
      }
    }

    ListView {
      id: list
      anchors.fill: parent

      boundsBehavior: Flickable.StopAtBounds

      populate: Transition {
        id: populateTransition
        SequentialAnimation {
          PropertyAnimation { properties: "x"; to: 1000; duration: 0 }
          PauseAnimation { duration: populateTransition.ViewTransition.index * 50}
          PropertyAnimation { 
            properties: "x"
            from: 100
            to: 0
            duration: 250
            easing.type: Easing.OutCubic
          }
        }
      }

      delegate: Item {
        id: listItem

        anchors.left: parent.left
        anchors.right: parent.right

        height: {
          var sum = 0

          for (const child of children) {
            if (child.visible) {
              sum += child.height + child.anchors.topMargin + child.anchors.bottomMargin
            }
          }

          sum
        }

        property var dataStuff: modelData

        Rectangle {
          id: separator
          anchors.left: listItem.left
          anchors.right: listItem.right
          anchors.verticalCenter: listItem.verticalCenter
          anchors {
            leftMargin: 10
            rightMargin: 10
            topMargin: 2
            bottomMargin: 2
          }
          height: 1
          color: Colors.separator
          visible: {
            if (listItem.dataStuff.separator) {
              true
            } else {
              false
            }
          }
        }

        BaseButton {
          id: listButton

          anchors.left: listItem.left
          anchors.right: listItem.right

          visible: listItem.dataStuff.separator ? false : true

          padding: 5

          backgroundAlias.radius: rightClickMenu.backgroundAlias.radius

          contentItem: Column {
            Text {
              id: textItem
              font.pointSize: listButton.fontSize
              font.family: "JetBrainsMono Nerd Font"

              width: parent.width

              color: Colors.text

              topPadding: listButton.textTopPadding
              bottomPadding: listButton.textBottomPadding
              leftPadding: listButton.textLeftPadding
              rightPadding: listButton.textRightPadding

              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter

              wrapMode: Text.WordWrap

              text: listButton.text
            }
            Text {
              id: descriptionItem
              font.pointSize: 6
              font.family: "JetBrainsMono Nerd Font"

              width: parent.width

              color: Colors.text
              opacity: 0.7

              topPadding: listButton.textTopPadding
              bottomPadding: listButton.textBottomPadding
              leftPadding: listButton.textLeftPadding
              rightPadding: listButton.textRightPadding

              horizontalAlignment: Text.AlignLeft
              verticalAlignment: Text.AlignVCenter

              wrapMode: Text.WordWrap

              text: listItem.dataStuff.description ? listItem.dataStuff.description : ""

              visible: listItem.dataStuff.description ? true : false
            }
          }

          text: {
            if (listItem.dataStuff.customText) {
              listItem.dataStuff.getText()
            } else {
              listItem.dataStuff.text
            }
          }

          onClicked: {
            listItem.dataStuff.activate()
            if (!listItem.dataStuff.dontCloseOnActivate) {
              rightClickMenu.close()
            }
          }

          textLeftPadding: 10
        }
      }
    }
    
    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.RightButton

      cursorShape: Qt.PointingHandCursor

      onClicked: rightClickMenu.close()
    }
  }
}