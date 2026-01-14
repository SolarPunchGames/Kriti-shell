// PowerButtonWidget.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs

Item {
  MarginWrapperManager { margin: 5 }

  property var currentScreen

  BaseButton {
    anchors.centerIn: parent
    fontSize: 9.5
    text: "⏻"

    implicitHeight: 30
    implicitWidth: 30

    textRightPadding: 3

    LazyLoader {  
      id: powerMenuLoader  
      source: "PowerMenu.qml"
      loading: true 
    }
 
    onClicked: {  
      if (powerMenuLoader.item) {          
        // Find the variant instance that matches this screen 
        for (var i = 0; i < powerMenuLoader.item.powerMenuVariants.instances.length; i++) {  
          var instance = powerMenuLoader.item.powerMenuVariants.instances[i]  
          if (instance.modelData.name === currentScreen) {  
            instance.toggleOpen()  
            break  
          }  
        }  
      }  
    }  
  }
}
