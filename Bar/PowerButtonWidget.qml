// PowerButtonWidget.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import ".."

Item {
  MarginWrapperManager { margin: 5 }

  property var currentScreen

  BaseButton {
    anchors.centerIn: parent
    fontSize: 9.5
    text: "⏻"

    textRightPadding: 3

    LazyLoader {  
      id: powerMenuLoader  
      source: "../PowerMenu/PowerMenu.qml"  
      loading: true 
    }
 
    onClicked: {  
      if (powerMenuLoader.item) {          
        // Find the variant instance that matches this screen  
        for (var i = 0; i < powerMenuLoader.item.powerMenuVariants.instances.length; i++) {  
          var instance = powerMenuLoader.item.powerMenuVariants.instances[i]  
          if (instance.modelData === currentScreen) {  
            instance.toggleOpen()  
            break  
          }  
        }  
      }  
    }  
  }
}