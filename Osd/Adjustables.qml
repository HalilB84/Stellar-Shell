import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import "../Services"
import "../CustomComponents"    

Item{

    implicitWidth: sliderRow.implicitWidth + 40
    implicitHeight: sliderRow.implicitHeight + 40

    Row {  
        id: sliderRow 
        anchors.centerIn: parent
        spacing: 20   
        
        VerticalSlider {
            from: 0
            //value: 50
            to: 100
            label: "VOL"
            glowColor: Colors.cluGlow
        }

        VerticalSlider {
            from: 0
            //value: 75
            to: 100
            label: "BRIGHT"
            glowColor: Colors.cluGlow
        }

        VerticalSlider {
            from: 0
            //value: 28
            to: 100
            label: "TST"
            glowColor: Colors.cluGlow
        } 
    }
}