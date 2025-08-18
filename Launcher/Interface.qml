import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets

import "../Services"
import "../CustomComponents"
import "../Services/fuzzysort.js" as Fuzzy

//cool but needs work bc its kinda ugly rn
//fix child boxes randomly clipping?

Rectangle{
    id: background
    color: "black"
    
    function searchApps(query) {
        const allApps = DesktopEntries.applications.values
            .filter(a => !a.noDisplay)
            .sort((a, b) => a.name.localeCompare(b.name));
            
        if (!query || query.trim() === "") {
            return allApps;
        }
        
        const results = Fuzzy.go(query, allApps, {
            keys: ['name', 'comment'],
            all: true
        });
        
        return results.map(r => r.obj);
    }

    function launch(entry: DesktopEntry): void {
        if (entry.runInTerminal)
            Quickshell.execDetached(["app2unit", "--", "foot", "fish", "-C", entry.execString]); //should change im too lazy to do it rn
        else
            Quickshell.execDetached({
                command: ["app2unit", "--", ...entry.command],
                workingDirectory: entry.workingDirectory
            });
    }
    
    Rectangle{
        id: searchBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        
        implicitHeight: parent.height * 0.11
        color: "transparent"
        border.color: "white"
        border.width: 2

        TextField{
            id: searchField
            anchors.fill: parent
            anchors.margins: 5
            
            background: null
            
            Component.onCompleted: {
                forceActiveFocus() //idk why i need this but wont't work otherise
                //console.log("focus") //potential issue with losing focus when clicking other ui elements
            }

            placeholderText: "Search..."
            placeholderTextColor: Colors.cluGlow
            font.pixelSize: parent.height * 0.26
            color: Colors.cluGlow
            
            onTextChanged: {
                listView.model.values = background.searchApps(text);
                listView.currentIndex = 0; 
            }

            Keys.onEscapePressed: {
                loader.shouldBe = false
            }

            Keys.onUpPressed: {
                if (listView.currentIndex > 0) {
                    listView.currentIndex--
                }
            }
            
            Keys.onDownPressed: {
                if (listView.currentIndex < listView.count - 1) {
                    listView.currentIndex++
                }
            }
            
            Keys.onReturnPressed: {
                if(listView.currentItem) {
                    background.launch(listView.currentItem.modelData)
                    loader.shouldBe = false
                }
            }
        }
    }

    Rectangle{

        anchors.top: searchBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        
        color: "transparent"
        border.color: "white"
        border.width: 2

        ListView{
            
            id: listView
            anchors.fill: parent
            anchors.margins: 2

            header: Item { height: 5 }
            footer: Item { height: 5 }

            clip: true
            
            model: ScriptModel { //once again qs saves me :D 
                values: background.searchApps("") // Start with all apps
            }

            Component.onCompleted: {
                listView.positionViewAtIndex(0, ListView.Center) // Need this because preferredHighlightBegin bugs it
            }

            spacing: 5

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 100

            highlightRangeMode: ListView.ApplyRange
            preferredHighlightBegin: height * 0.5 - 25
            preferredHighlightEnd: height * 0.5 + 25

            delegate: Rectangle{
                id: app
                
                anchors.left: parent?.left
                anchors.right: parent?.right

                anchors.rightMargin: 5
                anchors.leftMargin: 5
 
                implicitHeight: 50 //fix 
            
                color: "transparent"
                property bool hovered: false
                property bool active: ListView.isCurrentItem  
                border.color: active || hovered ? Colors.cluGlow : "white"
                border.width: 1
    
                required property var modelData //coming from model
                required property int index //coming from list

                //something in the background that is dynamic
                
                MouseArea {
                    anchors.fill: parent 
                    onClicked: {
                        //console.log("Selected:", app.modelData.name)
                    }
                    
                    hoverEnabled: true
                    onEntered: app.hovered = true
                    onExited: app.hovered = false
                }
                
                //I will fix the styling later bc i give up atp trying to use layouts
                Item {
                    id: content
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    IconImage {
                        id: icon
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        implicitSize: parent.height * 0.7
                        source: Quickshell.iconPath(app.modelData?.icon, "image-missing")
                    }

                    Text {
                        id: nameText
                        anchors.left: icon.right
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        anchors.top: icon.top

                        text: app.modelData.name || "Unknown App"
                        color: "white"
                        font.pixelSize: icon.height * 0.4
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        id: descText
                        anchors.left: icon.right
                        anchors.leftMargin: 10
                        anchors.right: parent.right
                        anchors.bottom: icon.bottom

                        text: app.modelData.comment || app.modelData.genericName || ""
                        color: "lightgray"
                        font.pixelSize: icon.height * 0.3
                        elide: Text.ElideRight
                    }    
                }
            }
        }
    }
}