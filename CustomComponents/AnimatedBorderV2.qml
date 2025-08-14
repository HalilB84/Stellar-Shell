import QtQuick
import "../Services"


Item{
    id: border

    property color lineColor: Colors.cluGlow
    property real lineWidth: 2
    property int animationDuration: 350

    property real actualWidth: 0
    property real actualHeight: 0

    implicitWidth: topEdge.implicitWidth
    implicitHeight: Math.max(lineWidth, leftEdge.implicitHeight)

    clip: true

    signal animationFinished()
    signal closingAnimationFinished()

    function openBorderSequence(){
        closingBorderSequence.stop()
        borderSequence.restart()
    }

    function closeBorderSequence(){
        borderSequence.stop()
        closingBorderSequence.restart()
    }

    Rectangle {
        id: leftEdge
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        implicitWidth: lineWidth
        color: lineColor
    }

    Rectangle {
        id: topEdge
        anchors.top: leftEdge.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: lineWidth
        color: lineColor
    }

    Rectangle {
        id: bottomEdge
        anchors.bottom: leftEdge.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: lineWidth
        color: lineColor
    }

    Rectangle {
        id: rightEdge
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        implicitWidth: lineWidth
        color: lineColor
    }


    SequentialAnimation { //I should probably adjust the timings of the animations based on distance but its not a big deal
        id: borderSequence

        NumberAnimation {
            targets: [topEdge, bottomEdge]
            property: "implicitWidth"
            from: topEdge.implicitWidth
            to: actualWidth
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        PauseAnimation { 
            duration: topEdge.implicitWidth < actualWidth ? 50 : 0
        }

        NumberAnimation {
            targets: [leftEdge, rightEdge]
            property: "implicitHeight"
            from: leftEdge.implicitHeight
            to: actualHeight
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        onFinished: { 
            border.animationFinished()
        }
    }

    SequentialAnimation{
        id: closingBorderSequence

        NumberAnimation {
            targets: [topEdge, bottomEdge]
            property: "implicitWidth"
            from: topEdge.implicitWidth
            to: leftEdge.implicitHeight > 0 ? lineWidth : 0
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        PauseAnimation { 
            duration: leftEdge.implicitHeight > 0 ? 50 : 0
        }

        NumberAnimation {
            targets: [leftEdge, rightEdge]
            property: "implicitHeight"
            from: leftEdge.implicitHeight
            to: 0
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        onFinished: { 
            border.closingAnimationFinished()
        }
    }
}