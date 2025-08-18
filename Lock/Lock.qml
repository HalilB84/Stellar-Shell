pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Hyprland
import QtQuick 
import QtQuick.Effects
import Quickshell.Services.Pam

import "../CustomComponents"
import "../Services"

Scope { 

    LazyLoader {
        id: loader
        
        WlSessionLock {
            id: lock

            property bool unlocked

            locked: true
            onLockedChanged: {
                if (!locked)
                    loader.active = false;
            }

            WlSessionLockSurface {
                id: lockSurface
                color: "transparent"

                /*ScreencopyView {
                id: background

                anchors.fill: parent
                captureSource: lockSurface.screen

                layer.enabled: true
                layer.effect: MultiEffect {
                    autoPaddingEnabled: false
                    blurEnabled: true
                    blur: 1
                    blurMax: 64
                    blurMultiplier: 1

                    
                }
            }*/
               
                Input {
                    lock: lock
                    anchors.centerIn: parent
                }

                Button { //safety button
                    text: "unlock me"
                    onClicked: lock.locked = false
                }
            }
        }
    }

    GlobalShortcut{
        appid: "test"
        name: "lock"
        onPressed: loader.active = true
    }
}