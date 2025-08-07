import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets 
import "../Services"
import "../CustomComponents"    


//for now dashboard is media only

Variants {
    model: Quickshell.screens

    PanelWindow {
        property var modelData
        property bool expanded: true 
        id: dashboard
      
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

        Item {
            id: contentArea
            anchors.left: parent.left   
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
                
                visible: implicitWidth > 0

                clip: true  
                                
                implicitWidth: expanded ? media.implicitWidth  : 0 // will fix 
                implicitHeight: media.implicitHeight 

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

                Media {
                    id: media
                }
            }

            //Should this be here? The answer to that is probably no, but idk how to do it otherwise
            Repeater {            
                model: 30         
                Rectangle {
                    id: visualizerBar

                    required property int modelData
                    
                    readonly property int value: Math.max(0, Math.min(100, Cava.values[modelData]))
                    property real mvalue: Math.round(value) * 1.5 //to stop the micro stutter
                    property real actualWidth: expanded ? mvalue : 0

                    implicitHeight: (expandedContent.implicitHeight - 58) / 30
                    implicitWidth: expanded ? mvalue : actualWidth
                    color: "white" 
                     
                    anchors.left: expandedContent.right   
                    anchors.top: parent.top
                    anchors.topMargin: modelData * (implicitHeight + 2)  
                    

                    Behavior on actualWidth {
                        NumberAnimation {
                            duration: 500
                        }
                    }
                    
                    //very cpu intensive, consider disabling it, but the very least it should be configurable
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: visualizerBar.color
                        shadowBlur: 1
                        shadowScale: 1
                    }
                }
            }
        }
    }
}