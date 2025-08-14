import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import "../Services"

Column {
    id: verticalSlider
    
    property string label: ""
    property color glowColor: Colors.cluGlow
    property var from: 0
    property var to: 100
     
    spacing: 10

    Rectangle {
        color: "red"
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: 40
        implicitWidth: 40 

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: 1
            shadowBlur: 1.5 
            shadowColor: "red"
            shadowScale: 1.1  
        }    

        AnimatedText {
            anchors.centerIn: parent
            animatedText: Math.round(slider.value).toString()
            animationStyle: AnimatedText.AnimationStyle.Matrix
            font.pixelSize: parent.width * 0.35
            color: verticalSlider.glowColor
        }
       
    }

    Slider {
        id: slider
        
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: Qt.Vertical
        implicitWidth: 60
        implicitHeight: 200

        from: parent.from
        to: parent.to

        value: Audio.volume * 100  
        onMoved: Audio.setVolume(value / 100.0)  //lols



        handle: null

        background: Rectangle {
            color: "black"
            anchors.fill: parent

            Rectangle {
                color: verticalSlider.glowColor
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: slider.value/slider.to * parent.height

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowOpacity: 1
                    shadowBlur: 1.5
                    shadowColor: verticalSlider.glowColor
                    shadowScale: 1.05  
                }


                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutExpo
                    }
                }
            }

            AnimatedBorder {
                anchors.fill: parent
                lineColor: verticalSlider.glowColor
                lineWidth: 2
            }
        }
    }
} 