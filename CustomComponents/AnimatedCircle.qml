import QtQuick 
import QtQuick.Shapes
import QtQuick.Effects
import "../Services"

//more like random animations
//supposed to be a tron like circle? like the disk thing

Shape {
    id: circle
    preferredRendererType: Shape.CurveRenderer

    property real radius
    property real startAngle
    property real sweepAngle
    property real centerX
    property real centerY 

    Component.onCompleted: {
        chaosAnimation.restart();
        rotationAnimation.restart();
        sweepAnimation.restart();
    }

    function randomDuration() { 
        return Math.random() * 1000 + 300; // 300-1300ms
    }

     ShapePath {     

        fillColor: "transparent"
        strokeColor: "white"
        strokeWidth: 2
        //capStyle: ShapePath.RoundCap

        PathAngleArc {
            centerX: circle.centerX
            centerY: circle.centerY
            radiusX: circle.radius
            radiusY: circle.radius
            startAngle: circle.startAngle 
            sweepAngle: circle.sweepAngle
        }   
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        brightness: 1
        saturation: 4
        blurEnabled: true
        blur: 0.2
    }
        
    // Flicker animation
    SequentialAnimation {
        id: chaosAnimation
        loops: Animation.Infinite
        NumberAnimation { 
            target: circle
            property: "opacity"
            to: 0.3
            duration: randomDuration() * 0.3
            //easing.type: randomEasing()
        }
        NumberAnimation { 
            target: circle
            property: "opacity"
            to: 1.0
            duration: randomDuration() * 0.2
            //easing.type: randomEasing()
        }
        NumberAnimation { 
            target: circle
            property: "opacity"
            to: 0.1
            duration: randomDuration() * 0.1
            //easing.type: randomEasing()
        }
        NumberAnimation { 
            target: circle
            property: "opacity"
            to: 1.0
            duration: randomDuration() * 0.4
            //easing.type: randomEasing()
        }
        PauseAnimation { 
            duration: Math.random() * 500 + 100
        }
    }

    SequentialAnimation {
        id: rotationAnimation
        loops: Animation.Infinite
        NumberAnimation {
            target: circle
            property: "startAngle"
            from: 0
            to: 120
            duration: randomDuration() * 1.5
            //easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: circle 
            property: "startAngle"
            from: 120
            to: 240
            duration: randomDuration() * 0.6
            //easing.type: Easing.OutExpo
        }
        NumberAnimation {
            target: circle
            property: "startAngle"
            from: 240
            to: 360
            duration: randomDuration() * 1.2
            //easing.type: Easing.InQuad
        }
        PropertyAction { target: circle; property: "startAngle"; value: 0 }
    }

    SequentialAnimation {
        id: sweepAnimation
        loops: Animation.Infinite
        NumberAnimation {
            target: circle
            property: "sweepAngle"
            from: 0
            to: 360
            duration: randomDuration() * 3
            //easing.type: Easing.OutQuad
        }

        /*NumberAnimation {
            target: circle
            property: "sweepAngle"
            from: 360
            to: 0
            duration: randomDuration() * 3
            //easing.type: Easing.OutQuad
        }*/
    } 
}
