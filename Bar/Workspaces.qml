import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
 import QtQuick.Layouts
import "../Services"
import "../CustomComponents"

Row {
    id: workspaces
    spacing: 4
    
    readonly property int currentWorkspace: Hyprland.focusedWorkspace?.id //uhhhhhhhhhhhhh defaults null for a sec? das ok i think since isActive updates anyways
    readonly property int workspaceLevel: (currentWorkspace - 1) / 5 //I like this from caelestia

    Repeater {
        model: 5
        
        Workspace {
            required property int modelData

            workspaceNumber: modelData + 1 + (workspaces.workspaceLevel * 5)
            isActive: workspaces.currentWorkspace === workspaceNumber
            
            onClicked: { // It is better that this is here makes more sense
                if (workspaceNumber !== workspaces.currentWorkspace) {
                    Hyprland.dispatch(`workspace ${workspaceNumber}`);
                }
            }
        }
    }
} 