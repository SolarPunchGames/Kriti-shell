// TextIconButton.qml
import QtQuick
import qs.Services

BaseButton {
  id: button

  property alias bigTextItem: bigText

  Text {
    id: bigText

    anchors.centerIn: parent

    scale: 0

    color: Colors.bigText

    font.pointSize: 60

    states: State{
      name: "hovered"
      when: button.buttonHovered
      PropertyChanges {target: bigText; scale: 1}
    }

    transitions: Transition {
      PropertyAnimation {
      property: "scale"
      duration: 250
      easing.type: Easing.OutCubic
      }
    }
  }

  states: State{
    name: "hovered"
    when: button.buttonHovered
    PropertyChanges {target: button; textAlias.scale: 0}
  }

  transitions: Transition {
    PropertyAnimation {
        property: "textAlias.scale"
        duration: 250
        easing.type: Easing.OutCubic
    }
  }
}