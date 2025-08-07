import QtQuick
import Quickshell.Widgets
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "../Services"
import "../CustomComponents"
import "../Background"
//right now the rings shouldnt exceed their bouding box
//because of how layer and multieffect interacts, but for now it works

//also need to fix the random width dependents
//needs more creative ideas for the slider 

Item {
    implicitWidth: mediaCol.implicitWidth + 130
    implicitHeight: mediaCol.implicitHeight + 150

    FlowingShader {}
   
    ColumnLayout {
        id: mediaCol
        anchors.centerIn: parent
        spacing: 10

        Item {
            id: mainContainer

            Layout.alignment: Qt.AlignHCenter
            implicitWidth: imageContainer.implicitWidth + 80
            implicitHeight: imageContainer.implicitHeight + 80 //acount for rings

            ClippingRectangle {
                id: imageContainer
                color: "transparent"
                anchors.centerIn: parent
                implicitWidth: 200 //basically what sets the size of the entire thing
                implicitHeight: 200
                radius: 999

                Image { 
                    id: image
                    anchors.fill: parent
                    source: Players.active?.trackArtUrl ?? ""
                    onSourceChanged: {
                        //console.log("source", source)
                    }
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                }
            }

            AnimatedCircle {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radius: imageContainer.implicitWidth / 2
            }
            AnimatedCircle {
                centerX: parent.width / 2
                centerY: parent.height / 2
                radius: imageContainer.implicitWidth / 2 + 20
            }
            AnimatedCircle {
                centerX: parent.width / 2
                centerY: parent.height / 2 
                radius: imageContainer.implicitWidth / 2 + 40
            }
        }

        //consider switching to AnimatedText after figuring out why it resizes weirdly
        //also figure out how to resize font size dynamically
        GlowText {
            id: title
            text: (Players.active?.trackTitle ?? "No media") || "Unknown title"
            color: "white"  
            //animationStyle: AnimatedText.AnimationStyle.None ///FIX
            //animationDuration: 50
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: mainContainer.implicitWidth * 0.055
            elide: Text.ElideRight
        }
        GlowText {
            id: album
            text: (Players.active?.trackAlbum ?? "No media") || "Unknown album"
            color: "white"
            //animationStyle: AnimatedText.AnimationStyle.None ///FIX
            //animationDuration: 50
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: mainContainer.implicitWidth * 0.045

            elide: Text.ElideRight
        }
        GlowText {
            id: artist
            text: (Players.active?.trackArtist ?? "No media") || "Unknown artist"
            color: "white"
            //animationStyle: AnimatedText.AnimationStyle.None ///FIX
            //animationDuration: 50
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: mainContainer.implicitWidth * 0.045
            elide: Text.ElideRight
        }

        Slider { 
            id: slider
            Layout.fillWidth: true
            
            from: 0
            to: Players.active?.length || 0
            value: Players.active?.position || 1 
            handle: null

            background: Rectangle {
                color: "white" 
                implicitHeight: mainContainer.implicitHeight / 40

                Rectangle {
                    color: Colors.cluGlow
                    anchors.left: parent.left
                    implicitHeight: parent.implicitHeight
                    implicitWidth: slider.value/slider.to * parent.width

                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.OutExpo
                        }
                    }
                }
            }

            Timer {
                running: Players.active?.isPlaying ?? false
                interval: 1000
                triggeredOnStart: true
                repeat: true
                onTriggered: Players.active?.positionChanged()
            }

            onMoved: {
                const active = Players.active;
                if (active?.canSeek && active?.positionSupported)
                    active.position = value
            }
        }

        //needs work, the items have fixed size which is not idea and yada yada , should not be more than image width bc das the master 
        //also i have to accept the fact that i will most likely end up switching up to icons    
        RowLayout {//WHYYYYYYYYYYYYYYYYYYY IS THIS NOT WORKING I CANT SPEND TIME ON A BASIC THING I QUIT, I HATE LAYOUTS
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
         
            Item {
                implicitWidth: mainContainer.implicitWidth / 11
                implicitHeight: implicitWidth

                
                Text {
                    anchors.centerIn: parent
                    text: "⏮"
                    color: (Players.active?.canGoPrevious ?? false) ? "white" : "gray"
                    font.pixelSize: parent.implicitHeight 
                }
                
                MouseArea {
                    anchors.fill: parent
                    enabled: Players.active?.canGoPrevious ?? false
                    onClicked: Players.active?.previous()
                }
            }
            
            Item {
                implicitWidth: mainContainer.implicitWidth / 11
                implicitHeight: implicitWidth
                
                Text {
                    id: playPause
                    anchors.centerIn: parent
                    text: Players.active?.isPlaying ? "⏸" : "▶"
                    color: Players.active ? "white" : "gray"
                    font.pixelSize: parent.implicitHeight 
                }
                
                MouseArea {
                    anchors.fill: parent
                    enabled: Players.active
                    onClicked: Players.active?.isPlaying
                        ? Players.active.pause && Players.active.pause()
                        : Players.active.play && Players.active.play()
                }
            }
            
            Item {
                implicitWidth: mainContainer.implicitWidth / 11
                implicitHeight: implicitWidth
                
                Text {   
                    anchors.centerIn: parent
                    text: "⏭"
                    color: (Players.active?.canGoNext ?? false) ? "white" : "gray"
                    font.pixelSize: parent.implicitHeight 
                }
                
                MouseArea {
                    anchors.fill: parent
                    enabled: Players.active?.canGoNext ?? false
                    onClicked: Players.active?.next()
                }
            }
        }
        
        Timer {
            running: Players.active?.isPlaying ?? false
            interval: 1000
            triggeredOnStart: true
            repeat: true
            onTriggered: Players.active?.positionChanged()
        }
    }
    

    AnimatedCircle {
        //centerY: parent.height
        radius: parent.width / 5
    }
    AnimatedCircle {
        //centerY: parent.height
        radius: parent.width / 4
    }
    AnimatedCircle {
        centerX: parent.width
        centerY: parent.height
        radius: parent.width / 6
    }
    AnimatedCircle {
        centerX: parent.width
        centerY: parent.height
        radius: parent.width / 7
    }
}