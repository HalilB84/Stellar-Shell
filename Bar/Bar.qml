import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles
import "../Services"
import "../CustomComponents"



Item{
    id: bar
        

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    anchors.topMargin: 5
    anchors.leftMargin: 5
    anchors.rightMargin: 5 
    

    //this is the border
    AnimatedBorder {
        id: border
        anchors.fill: parent
        lineColor: Colors.cluGlow
        lineWidth: 1
        isSolid: true

        clip: true

            Galaxy {
                anchors.fill: parent
                regularEmitRate: 400
                speederEmitRate: 10
                regularSpeed: 8
                speederSpeed: 15
                enabled: true
        }  
    }


    

    Workspaces {
        id: workspaces
        anchors.left: parent.left      
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
    }

    // Music visualization - Dots //experimenting with this
    Repeater {            
        model: 30 

        Column {
            id: dotColumn

            required property int modelData
            
            readonly property int value: Math.max(0, Math.min(100, Cava.values[modelData] || 0))
            readonly property int maxDots: 10
            readonly property int activeDots: Math.ceil((value / 100) * maxDots)

            spacing: 1
                
            anchors.left: workspaces.right       
            anchors.leftMargin: 10 + (modelData * 6)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
            
            Repeater {
                model: dotColumn.maxDots
                Rectangle {
                    required property int modelData
                    
                    width: 4
                    height: 4
                    radius: 0
                    color: Colors.cluGlow
                    
                    opacity: (dotColumn.maxDots - modelData) <= dotColumn.activeDots ? 1.0 :0
                    
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }
            }
        }
    }

    GlowText { // fix displaying over other elements
        anchors.centerIn: parent
        text: Hyprland.activeToplevel?.title ?? ""
        font.pixelSize: bar.implicitHeight * 0.35 // why does parent not work lol?
        color: Colors.cluGlow
        //center the text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        width: bar.width / 4
    }

    GlowText {
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: bar.implicitHeight * 0.35
        color: Colors.cluGlow
        text: Time.time
    }
}
