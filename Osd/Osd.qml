import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import "../Services"
import "../CustomComponents"    


// Content container snapped to the right edge //might be simplified?
Item {
    id: contentArea
    anchors.right: parent.right   
    anchors.verticalCenter: parent.verticalCenter 
    property bool expanded: true
    
    implicitWidth: Math.max(expandedContent.implicitWidth, 5) 
    implicitHeight: expandedContent.implicitHeight

    HoverHandler {            
        onHoveredChanged: {
            expanded = hovered       
        }
    }
    
    Item {
        id: expandedContent
        
        visible: implicitWidth > 0 //not necessary, but we ball
        clip: true  // Enable clipping to prevent overflow
        
        anchors.right: parent.right //?????????
        
        // Calculate size based on actual content
        implicitWidth: expanded ? adjustables.implicitWidth : 0
        implicitHeight: adjustables.implicitHeight  

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutCubic
            }
        }

        Rectangle { // background. most likely shouldnt be here, background should be set by the child
            anchors.fill: parent
            color: "black"
        }   

        Adjustables {
            id: adjustables
            anchors.right: parent.right
        }

        AnimatedBorder {     
            anchors.fill: parent
            
            lineWidth: 2
            lineColor: Colors.cluGlow

            onAnimationFinished: {
                expanded = false

            }
        }       
    }                    
}
