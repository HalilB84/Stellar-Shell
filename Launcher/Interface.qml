import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls

Rectangle{
    id: background
    color: "black"
    
    Rectangle{
        id: searchBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        
        implicitHeight: 60
        color: "transparent"
        border.color: "white"
        border.width: 2

        TextField{
            anchors.fill: parent
            
            background: null

            Component.onCompleted: {
                forceActiveFocus() //idk why i need this but work work otherise
                //console.log("focus") //potential issue with losing focus when clicking other ui elements
            }

            placeholderText: "Search..."
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
    }
}