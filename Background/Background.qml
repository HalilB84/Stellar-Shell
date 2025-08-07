import Quickshell
import Quickshell.Wayland
import QtQuick

//just here rn because i dont want to setup a wallpaper manager yet

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData

        screen: modelData
        color: "black"

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        property string wallpaperPath: "file:///home/zenith/Pictures/Wallpapers/tron_legacy5.jpg"

        Image {
            anchors.fill: parent
            source: wallpaperPath
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
        }
    }
}
