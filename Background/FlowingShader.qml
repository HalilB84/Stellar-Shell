import QtQuick
import QtQuick.Effects
import "../Services"


ShaderEffect {
    id: shader
    anchors.fill: parent
      
    property real beatMultiplier: 9.0
    property real uvScale: 3.5
    property real brightnessMod: 0.2
    property real loopCount: 10
    property real invConst: 1.1
    property real timeSpeed: 1.0
    property real multipleColors: 1.0 

    property vector2d resolution: Qt.vector2d(width, height)
    property vector3d color1: Qt.vector3d(0.3, 0.0, 0.0)
    property vector3d color2: Qt.vector3d(0.2, 0.1, 0.0)
    
    property real customTime: 0.0
    
    property real audio: {
        if (Cava.values && Cava.values.length >= 3) {
            return (Cava.values[0] + Cava.values[1] + Cava.values[2]) / 3.0 / 100.0
        }
        return 0.0
    }
    
    // Custom time idk how stable this is 
    Timer {
        running: true
        repeat: true
        interval: 16 // ~60fps
        onTriggered: {
            let intensity = shader.audio
            let jump = Math.max(1.0, intensity * 8.0) 
            let frametime = 0.016 
            shader.customTime += jump * frametime * shader.timeSpeed
        }
    }
    
    fragmentShader: "../Background/flowing.frag.qsb"
}