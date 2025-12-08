// ScalePanelWindow.qml

import QtQuick
import Quickshell

PanelWindow {
  id: window

  property var modelData
  screen: modelData

  property var scaleItemAlias
  property var mainPanelAlias

  anchors {
    top: true
    right: true
    bottom: true
    left: true
  }

  color: "#00000000"

  implicitHeight: mainPanelAlias.height + 50
  implicitWidth: mainPanelAlias.width + 50

  mask: Region {  
    x: mainPanelAlias.x
    y: mainPanelAlias.y
    width: {
      if (scaleItemAlias.state == "open") {
        mainPanelAlias.width
      } else {
        0
      }
    }
    height: {
      if (scaleItemAlias.state == "open") {
        mainPanelAlias.height
      } else {
        0
      }
    }
  }

  signal windowOpened()
  signal windowClosed()

  function toggleOpen() {
    if (scaleItemAlias.state == "open") {
      close()
    } else {
      open()
    }
  }
  function open() {
    scaleItemAlias.state = "open"
    windowOpened()
  }
  function close() {
    scaleItemAlias.state = ""
    windowClosed()
  }
}