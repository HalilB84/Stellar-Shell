import QtQuick
import QtQuick.Effects
import Quickshell.Hyprland
import "../Services"
import "../CustomComponents"

Item {
    id: workspace
    
    property int workspaceNumber 
    property bool isActive
    property bool isHovered: false  
    
    signal clicked()
    
    implicitWidth: 75 // bad
    implicitHeight: bar.height - 12
    
    // Global border color because otherwise is breaks? Learn how reactive bindings work, nvm they simple
    property color borderColor: workspace.isActive ? Colors.cluGlow : (workspace.isHovered ? Colors.cluGlow + "60" : Colors.cluGlow + "10")
    property real slideProgress: 0.0
    property real fadeOpacity: 1.0

    
    onIsActiveChanged: {
        if (workspace.isActive) {
            slideProgress = 0.0;
            fadeOpacity = 1.0;
        
            slideAnimation.restart();
            borderAnimation.startAnimation();
            workspaceText.startAnimation();
        } 
    }
    
    
    AnimatedBorder {
        id: borderAnimation
        anchors.fill: parent
        lineColor: workspace.borderColor
        lineWidth: 2
    }


    //aessthetic only wtf am i doing
    Rectangle {
        x: 0; y: 0
        width: workspace.implicitWidth/12; height: width
        color: workspace.borderColor
    }
    
    Rectangle {
        x: 0; y: parent.height - workspace.implicitWidth/12
        width: workspace.implicitWidth/12; height: width
        color: workspace.borderColor
    }
    
    // Diagonal line for aesthetic
    Rectangle {
        x: 0
        y: 0
        implicitWidth: Math.sqrt(parent.width * parent.width + parent.height * parent.height)
        implicitHeight: 1 //actual width
        color: workspace.borderColor
        opacity: 0.7
        transformOrigin: Item.TopLeft
        rotation: Math.atan(parent.height / parent.width) * 180 / Math.PI
    }
    
    // Sliding color animation 
    Rectangle {
        id: slidingColor
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: borderAnimation.lineWidth //this looks cooler

        implicitHeight: (parent.height - borderAnimation.lineWidth * 2) * workspace.slideProgress 
        color: workspace.borderColor
        opacity: 0.4 * workspace.fadeOpacity
    }
    
    AnimatedText {
        id: workspaceText
        anchors.centerIn: parent
        animatedText: `WS_${String(workspace.workspaceNumber).padStart(2, '0')}`
        font.family: "Courier New, monospace"
        font.pixelSize: parent.implicitHeight * 0.35
        font.weight: Font.Bold
        color: {
            if (workspace.isActive) {
                return Colors.cluGlow; 
            } else {
                return Colors.cluGlow + "10"; 
            }
        }
        animationStyle: AnimatedText.AnimationStyle.Matrix 
        animationDuration: 80    
    }
        
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: workspace.clicked() //basically saying that we clikced this workspace which transfers to workspace.qml
        
        onEntered: {
            workspace.isHovered = true;
        }
        
        onExited: {
            workspace.isHovered = false;
        }
    }
    
    SequentialAnimation {
        id: slideAnimation  
        
        NumberAnimation {
            target: workspace
            property: "slideProgress"
            from: 0.0
            to: 1.0
            duration: 400
            easing.type: Easing.OutCubic
     
        }
        
        NumberAnimation {
            target: workspace
            property: "fadeOpacity"
            from: 1.0
            to: 0.2
            duration: 300
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: workspace
            property: "fadeOpacity"
            from: 0.2
            to: 1.0
            duration: 200
            easing.type: Easing.OutCubic
        }
        
        ParallelAnimation {
            NumberAnimation {
                target: workspace
                property: "slideProgress"
                from: 1.0
                to: 0.0
                duration: 300
                easing.type: Easing.InOutCubic
            }
        }        
    }
} 