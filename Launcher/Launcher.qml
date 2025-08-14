import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects 
import "../CustomComponents"

//should be rewritten bc rn full spagetti code
//focus wont go back if cursor doesnt move -> fix

Item{ //temp solution to get the size of the launcher

    anchors.centerIn: parent
    implicitWidth: loader.shouldBe ? loader.item.implicitWidth : 0
    implicitHeight: loader.shouldBe ? loader.item.implicitHeight : 0

    Loader {
        id: loader
        active: false
        property bool shouldBe: false
        asynchronous: true  
        anchors.centerIn: parent

        onShouldBeChanged: {
            if (!shouldBe) {
                item.children[0].closeBorderSequence()
            }
            else if (shouldBe && status === Loader.Ready) {
                item.children[0].openBorderSequence()
            }
        }

        onLoaded: {
            if (shouldBe) {
                item.children[0].openBorderSequence()
            }
        }
        
        sourceComponent: Component {
            Item { //only here for specifiying the size of the launcher
                id: contentArea
                implicitWidth: 450
                implicitHeight: 550                

                AnimatedBorderV2 {
                    id: border
                    anchors.centerIn: parent

                    actualWidth: contentArea.implicitWidth //this is done so we can clip things. There is probably a better way to do this.
                    actualHeight: contentArea.implicitHeight

                    Interface{
                        anchors.centerIn: parent
                        implicitWidth: contentArea.implicitWidth
                        implicitHeight: contentArea.implicitHeight
                        z: -1
                    }

                    onClosingAnimationFinished: { 
                        loader.active = false 
                    }
                }

                Keys.onEscapePressed: loader.shouldBe = false

                HyprlandFocusGrab{ //unloads automatically
                    active: loader.active && loader.shouldBe
                    windows: [QsWindow.window]
                    onCleared: loader.shouldBe = false
                }
            }
        }
    }

    GlobalShortcut{
        appid: "test"
        name: "launcher"
        onReleased: {
            if(!loader.active) loader.active = true
            loader.shouldBe = !loader.shouldBe
        }
    }
}

