import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects 
import "../CustomComponents"

Variants{
    model: Quickshell.screens

    PanelWindow {
        required property var modelData

        id: launcher
      
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: loader.active ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None //not ideal temp fix till i switch to one panelwindow
        
        color: "transparent"
        screen: modelData
        
        anchors { 
            right: true
            top: true
            bottom: true
            left: true
        }

        mask: Region{
            item: loader.item
        }

        Loader {
            id: loader
            active: false
            asynchronous: true
            anchors.centerIn: parent
            
            sourceComponent: Component {
                Item { //only here for specifiying the size of the launcher
                    id: contentArea
                    implicitWidth: 450
                    implicitHeight: 550                

                    AnimatedBorderV2 {
                       anchors.centerIn: parent
        
                       actualWidth: contentArea.implicitWidth //this is done so we can clip things. There is probably a better way to do this.
                       actualHeight: contentArea.implicitHeight

                        Interface{
                            anchors.centerIn: parent
                            implicitWidth: contentArea.implicitWidth
                            implicitHeight: contentArea.implicitHeight
                            z: -1
                        }
                    }
                    
                    HyprlandFocusGrab{
                        active: loader.active
                        windows: [launcher] 
                    }
                }
            }
        }

        GlobalShortcut{
            appid: "test"
            name: "launcher"
            onPressed: {
                loader.active = !loader.active
                //console.log("launcher, active:", loader.active)
            }
        }
    }
}