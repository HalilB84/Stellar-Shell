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

    Component.onCompleted: {
        borderSequence.restart();
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


    SequentialAnimation { 
        id: borderSequence

        NumberAnimation {
            targets: [topEdge, bottomEdge]
            property: "implicitWidth"
            from: 0
            to: actualWidth
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        PauseAnimation { duration: 50 }

        NumberAnimation {
            targets: [leftEdge, rightEdge]
            property: "implicitHeight"
            from: 0
            to: actualHeight
            duration: animationDuration
            easing.type: Easing.OutCubic
        }

        onFinished: { 
            border.animationFinished()
        }
    }
}