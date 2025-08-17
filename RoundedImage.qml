// RoundedImage.qml
import QtQuick
import Qt5Compat.GraphicalEffects

Image {
  id: img
  source: Players.player.trackArtUrl

  fillMode: Image.PreserveAspectCrop

  anchors.fill: parent

  property bool rounded: true
  property int radius: 10
  property bool adapt: true

  layer.enabled: rounded
  layer.effect: OpacityMask {
    maskSource: Item {
      width: img.width
      height: img.height
      Rectangle {
        anchors.centerIn: parent
        width: img.adapt ? img.width : Math.min(img.width, img.height)
        height: img.adapt ? img.height : width
        radius: img.radius
      }
    }
  }
}