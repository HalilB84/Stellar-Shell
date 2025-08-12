import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects 
import "../CustomComponents"


Item{ //temp solution to get the size of the launcher

    anchors.centerIn: parent
    implicitWidth: loader.active ? loader.item.implicitWidth : 0
    implicitHeight: loader.active ? loader.item.implicitHeight : 0

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

                HyprlandFocusGrab{ //unloads automatically
                    active: loader.active
                    windows: [QsWindow.window] 
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

