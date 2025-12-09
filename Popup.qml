// Popup.qml
import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs
import qs.Services

PopupWindow {
  id: window

  anchor.edges: Edges.Top | Edges.Left

  implicitWidth: 200
  implicitHeight: list.contentHeight

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

    anchors.fill: parent

    transformOrigin: Item.TopLeft

    color: Colors.itemBackground

    radius: 5

    scale: 0.6
    opacity: 0

    states: State {
      name: "open"
      PropertyChanges {target: background; scale: 1}
      PropertyChanges {target: background; opacity: 1}
    }

    transitions: Transition {
      PropertyAnimation {
        property: "scale"
        duration: 250
        easing.type: Easing.OutCubic
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

      delegate: BaseButton {
        id: listButton

        anchors.left: parent.left
        anchors.right: parent.right

        property var data: modelData
        
        padding: 5

        backgroundAlias.radius: rightClickMenu.backgroundAlias.radius

        contentItem: Column {
          Text {
            id: textItem
            font.pointSize: listButton.fontSize
            font.family: "JetBrainsMono Nerd Font"

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

            color: Colors.text
            opacity: 0.7

            topPadding: listButton.textTopPadding
            bottomPadding: listButton.textBottomPadding
            leftPadding: listButton.textLeftPadding
            rightPadding: listButton.textRightPadding

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.WordWrap

            text: listButton.data.description ? listButton.data.description : ""

            visible: listButton.data.description ? true : false
          }
        }

        text: {
          if (data.customText) {
            data.getText()
          } else {
            data.text
          }
        }
        onClicked: {
          data.activate()
          if (!data.dontCloseOnActivate) {
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