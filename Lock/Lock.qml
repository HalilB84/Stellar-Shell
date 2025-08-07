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
                color: "black"

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

                property int numRectangles: 8
                property real baseWidth: 300
                property real maxWidth: screen.width
                property real widthIncrement: (maxWidth - baseWidth) / (numRectangles - 1)

                Repeater {
                    model: numRectangles
                    AnimatedBorder {
                        id: rect
                        required property int modelData
                        
                        property real aspectRatio: screen.width / screen.height
                        property real currentWidth: baseWidth + (modelData * widthIncrement)
                        property real currentHeight: currentWidth / aspectRatio
                        
                         width: currentWidth
                         height: currentHeight
                         anchors.centerIn: parent
                         isFlickering: false 
                                                  
                         rotation: modelData % 2 === 1 ? 180 : 0
                         

                         animationDuration: 500 + (modelData * 50)
                        
                        lineColor: Colors.cluGlow
                        opacity: 0
                                                 
                        SequentialAnimation {
                            id: lightUpAnimation
                            loops: 1
                            
                            PauseAnimation {
                                duration: modelData * 200 
                            }
                            
                            NumberAnimation {
                                target: rect
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 600
                            }
                        }
                        
                        Component.onCompleted: {
                            lightUpAnimation.start()
                        }
                    }
                }

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