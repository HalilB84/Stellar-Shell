import QtQuick
import QtQuick.Particles
import "../Services"


//this is just an experiment but looks cool so i'll keep it

Item {
    id: particles
    
    property int regularEmitRate: 400
    property int speederEmitRate: 100 
    property real regularSpeed: 8
    property real speederSpeed: 25
    property bool enabled: true //just switch this to a loader?
    
    ParticleSystem {
        id: spaceTraffic
        anchors.fill: parent
        running: particles.enabled
        
        Emitter {
            id: regularTraffic
            system: spaceTraffic
            group: "regular"
            
            x: 0
            y: parent.height - 5
            width: parent.width
            height: 5
            
            emitRate: particles.regularEmitRate
            lifeSpan: 12000
            
            velocity: AngleDirection {
                angle: 0
                angleVariation: 15
                magnitude: particles.regularSpeed
                magnitudeVariation: 30
            }
            
            acceleration: AngleDirection {
                angle: 0
                angleVariation: 3
                magnitude: 1
                magnitudeVariation: 1
            }
            
            size: 8
            sizeVariation: 1
        }
        
        Emitter {
            id: speeders
            system: spaceTraffic
            group: "fast"
            
            x: 0
            y: parent.height / 2
            width: parent.width
            height: 5
            
            emitRate: particles.speederEmitRate 
            lifeSpan: 8000
            
            velocity: AngleDirection {
                angle: 0
                angleVariation: 5
                magnitude: 300
                magnitudeVariation: 50
            }
            
            acceleration: AngleDirection {
                angle: 0
                angleVariation: 0
                magnitude: 0   
                magnitudeVariation: 0
            }
            
            size: 25
            sizeVariation: 0
        }
        
        ImageParticle {
            system: spaceTraffic
            groups: ["regular"]
            source: "qrc:///particleresources/star.png"
            color: "white"
            opacity: 1
        }
        
        ImageParticle {
            system: spaceTraffic
            groups: ["fast"]
            source: "qrc:///particleresources/star.png" 
            color: "white"
            opacity: 1   
        }
    }
}