import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Particles
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "Bar"
import "Dashboard"
import "Osd"
import "Launcher"


Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        PanelWindow{
            id: exclusion

            screen: scope.modelData
            color: "transparent"

            anchors.top: true
            exclusiveZone: scope.modelData.height / 25 + 5 //not good
            mask: Region {}   
        }

        PanelWindow { 
            id: surface
            screen: scope.modelData
            
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
    
            color: "transparent"
            
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            mask: Region {
                regions: [
                    Region { item: bar },
                    Region { item: dashboard },
                    Region { item: osd },
                    Region { item: launcher }
                ]
            }

            Bar{
                id: bar
                implicitHeight: scope.modelData.height / 25
            }

            Dashboard{
                id: dashboard
            }

            Osd{
                id: osd
            }

            Launcher{
                id: launcher
            }
        }
    }
}