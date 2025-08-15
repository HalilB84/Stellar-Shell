import QtQuick
import Quickshell


import "../Services"

//diamond grid I can't say it looks great...

Item {
	anchors.fill: parent

	property real tile: 50
	property real gap: 10
	readonly property real step: tile + gap

	readonly property real diag: Math.hypot(width, height)

    clip: true

	Item {
		id: rotLayer
		width: diag
		height: diag
		anchors.centerIn: parent
		rotation: 45

		readonly property int cols: Math.ceil(width / step) + 2
		readonly property int rows: Math.ceil(height / step) + 2

		Repeater {
			model: rotLayer.rows
			Row {
                id: row
				y: index * step
				spacing: gap

				Repeater {
					model: rotLayer.cols
					Rectangle {
                        required property int modelData
                        id: app
						width: tile
						height: tile
						color: "red"
                        opacity: 0.9
                        scale: 0

                        Component.onCompleted: {
                            anim.restart()
                        }

                        SequentialAnimation{
                            id: anim
                            loops: Animation.Infinite

                            PauseAnimation{
                                duration: app.modelData * 10
                            }

                            NumberAnimation{
                                target: app
                                property: "scale"
                                from: 0
                                to: 1
                                duration: 1000 
                            }

                            NumberAnimation{
                                target: app
                                property: "scale"
                                from: 1
                                to: 0
                                duration: 1000 
                            }
                        }
					}
				}
			}
		}
	}
}