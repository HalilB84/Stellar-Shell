import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import "../Services"
import "../CustomComponents"

//really basic implementation of a password input
//copied from caelestia's lock screen for now

AnimatedBorder {
    id: input

    clip: true //meh
    
    required property WlSessionLock lock
    property string passwordBuffer: ""
    
    width: 200
    height: 50
    lineColor: Colors.cluGlow
    lineWidth: 2
    
    focus: true
    
    Keys.onPressed: event => {
        if (pam.active)
            return;

        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if (passwordBuffer.length > 0) {
                pam.start();
            }
        } else if (event.key === Qt.Key_Backspace) {
            if (event.modifiers & Qt.ControlModifier) {
                input.passwordBuffer = "";
            } else {
                input.passwordBuffer = input.passwordBuffer.slice(0, -1);
            }
        } else if (" abcdefghijklmnopqrstuvwxyz1234567890`~!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?".includes(event.text.toLowerCase())) {
            input.passwordBuffer += event.text;
        }
    }
    
    PamContext {
        id: pam

        onResponseRequiredChanged: {
            if (!responseRequired)
                return;

            respond(input.passwordBuffer);
            input.passwordBuffer = "";
        }

        onCompleted: res => {
            if (res === PamResult.Success) {
                return input.lock.locked = false;
            }

            if (res === PamResult.Error)
                placeholder.pamState = "error";
            else if (res === PamResult.MaxTries)
                placeholder.pamState = "max";
            else if (res === PamResult.Failed)
                placeholder.pamState = "fail";

            placeholderDelay.restart();
        }
    }
    
    Timer {
        id: placeholderDelay
        interval: 3000
        onTriggered: placeholder.pamState = ""
    }
    
    Text {
        id: placeholder
        property string pamState: ""
        anchors.centerIn: parent
        
        text: {
            if (pam.active)
                return "Loading...";
            if (pamState === "error")
                return "An error occurred";
            if (pamState === "max")
                return "Maximum tries reached";
            if (pamState === "fail")
                return "Incorrect password";
            return "Enter your password";
        }
        
        color: {
            if (pamState) return "red"
            return Colors.cluGlow
        }
        font.pixelSize: parent.height * 0.30
        
        opacity: input.passwordBuffer ? 0 : 1
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
    
    // dots
    Row {
        anchors.centerIn: parent
        spacing: 8
        opacity: input.passwordBuffer ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
        
        Repeater {
            model: input.passwordBuffer.length
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: Colors.cluGlow
            }
        }
    }
}