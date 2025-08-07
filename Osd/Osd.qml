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

Variants {
    model: Quickshell.screens

    PanelWindow {
        property var modelData
        property bool expanded: true
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        color: "transparent"
        screen: modelData

        anchors {
            right: true
            top: true
            bottom: true
            left: true
        }

        mask: Region {
            item: contentArea
        }

        // Content container snapped to the right edge //might be simplified?
        Item {
            id: contentArea
            anchors.right: parent.right   
            anchors.verticalCenter: parent.verticalCenter  
            
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
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
          
                AnimatedBorder {     
                    anchors.fill: parent
                    
                    lineWidth: 2
                    isSolid: true
                    lineColor: Colors.cluGlow
 
                    onAnimationFinished: {
                        expanded = false

                    }
                }          

                Adjustables {
                    id: adjustables
                    anchors.right: parent.right
                }
            }                    
        }
    }
}