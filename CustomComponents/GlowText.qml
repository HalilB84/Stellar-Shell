import QtQuick
import QtQuick.Effects
import "../Services"

Text {
    id: text
    
    property string animatedText: ""
    
    text: animatedText
    font.family: "JetBrains Mono, monospace"
    font.pixelSize: 14
    font.weight: Font.Bold
    
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowOpacity: 1
        shadowBlur: 1.0 
        shadowColor: color
        shadowScale: 1
    }
    
} 