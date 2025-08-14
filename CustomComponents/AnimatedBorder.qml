import QtQuick
import QtQuick.Effects

Item { //assumes the size never changes, gotta fix that somehow, for now dont change size when animating
    id: border
    
    property color lineColor: Colors.cluGlow
    property real lineWidth: 2
    property int animationDuration: 500
    property bool isSolid: false
    property bool autoStart: true
    property bool isFlickering: true

    signal animationFinished()

    Component.onCompleted: { 
        if (autoStart) {
            startAnimation();
        }
    }

    function startAnimation() {        
        if (isFlickering) {
            flickerAnimation.restart(); 
        } 
        borderSequence.restart();
    }
    
    Rectangle { //to delete
        anchors.fill: parent
        color: isSolid ? "black" : "transparent"  //make the whole rectangle optional like wtf
    }
    
    Rectangle {  
        id: leftEdge 
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter //for the funzies
        implicitWidth: lineWidth 
        color: lineColor
    }
    
    Rectangle {
        id: topEdge
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: lineWidth
        implicitHeight: lineWidth
        color: lineColor
    }
    
    Rectangle {
        id: bottomEdge
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: lineWidth
        implicitHeight: lineWidth
        color: lineColor
    }
    
    Rectangle {
        id: rightEdge
        anchors.right: parent.right
        anchors.top: parent.top 
        implicitWidth: lineWidth       
        color: lineColor
    }

    SequentialAnimation { //seperate in case i want to use it standalone
        id: flickerAnimation
        loops: 3
        
        NumberAnimation { 
            targets: [leftEdge, topEdge, bottomEdge, rightEdge]
            property: "opacity" 
            to: 0
            duration: 100
        }                  
        NumberAnimation { 
            targets: [leftEdge, topEdge, bottomEdge, rightEdge]
            property: "opacity"
            to: 1.0
            duration: 100
        }
        NumberAnimation { 
            targets: [leftEdge, topEdge, bottomEdge, rightEdge]
            property: "opacity"
            to: 0.2
            duration: 100
        }     
        NumberAnimation { 
            targets: [leftEdge, topEdge, bottomEdge, rightEdge]
            property: "opacity" 
            to: 1.0  
            duration: 100
        }
    }    
    
    SequentialAnimation { 
        id: borderSequence

        PropertyAction { target: leftEdge; property: "implicitHeight"; value: 0 } //debind during animation? i mean it shouldnt move during it anyways
        PropertyAction { target: topEdge; property: "implicitWidth"; value: 0 }
        PropertyAction { target: bottomEdge; property: "implicitWidth"; value: 0 }
        PropertyAction { target: rightEdge; property: "implicitHeight"; value: 0 }
        
        NumberAnimation {
            target: leftEdge
            property: "implicitHeight"
            from: 0
            to: border.height
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            targets: [topEdge, bottomEdge]
            property: "implicitWidth"
            from: 0
            to: border.width - lineWidth * 2   
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: rightEdge
            property: "implicitHeight"
            from: 0
            to: border.height
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        onFinished: { //for the case that the size change but this should be rewritten in the long run
            topEdge.implicitWidth = Qt.binding(function() { return border.width - lineWidth * 2})
            bottomEdge.implicitWidth = Qt.binding(function() { return border.width - lineWidth * 2})
            leftEdge.implicitHeight = Qt.binding(function() { return border.height })
            rightEdge.implicitHeight = Qt.binding(function() { return border.height })
            border.animationFinished()
        }
    }
}
