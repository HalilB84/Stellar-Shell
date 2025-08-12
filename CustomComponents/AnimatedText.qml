import QtQuick

//there is a bug somewhere, sometimes the text has matrix chars in it when it shouldnt


Text {
    id: text

    property string animatedText: ""
    property string displayedText: ""
    property int animationDuration: 100  // Duration per character
    property bool autoStart: true
    property int animationStyle: AnimatedText.AnimationStyle.Typewriter 
    property int currentIndex: 0
    property bool isAnimating: false  
    property var activeTimers: []  
    
    enum AnimationStyle {
        Typewriter,    
        Matrix         
    }

    text: displayedText
    font.weight: Font.Bold
    
    Component.onCompleted: {
        if (autoStart) {
            startAnimation()
        }
    }
    
    onAnimatedTextChanged: { 
        if (autoStart) {
            startAnimation()
        }
    }
    
    function startAnimation() {
        if (animatedText === "") return
        
        clearAllTimers()
        
        text.isAnimating = false
        text.displayedText = text.animatedText
        
        text.isAnimating = true
        text.currentIndex = 0
        text.displayedText = ""
        
        revealTimer.start()
    }
    
    function clearAllTimers() {
        revealTimer.stop() 
        // Destroy all active setTimeout timers
        for (let i = 0; i < text.activeTimers.length; i++) {
            if (text.activeTimers[i] && text.activeTimers[i].running) {
                text.activeTimers[i].stop()
                text.activeTimers[i].destroy()
            }
        }
        text.activeTimers = []
    }
    
    function stopAnimation() {
        clearAllTimers()
        text.isAnimating = false
        text.displayedText = text.animatedText 
    }
    
    function revealCharacter(index) {
        const chr = text.animatedText[index]
        
        switch (text.animationStyle) {
            case AnimatedText.AnimationStyle.Typewriter:
                text.displayedText += chr
                break
                
            case AnimatedText.AnimationStyle.Matrix:
                showMatrixEffect(index, chr)
                break
        }
    }
    
    function showMatrixEffect(index, finalChar) {
        const matrixChars = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン"
        let iterations = 5 //make it configurable
        
        function cycleChar() {
            if (iterations > 0) {
                const randomChar = matrixChars[Math.floor(Math.random() * matrixChars.length)]
                text.displayedText = text.displayedText.substring(0, index) + randomChar + text.displayedText.substring(index + 1)
                iterations--
                
                Qt.callLater(function() {
                    setTimeout(cycleChar, 50)
                })
            } else {
                text.displayedText = text.displayedText.substring(0, index) + finalChar + text.displayedText.substring(index + 1)
            }
        }
        
        text.displayedText += matrixChars[Math.floor(Math.random() * matrixChars.length)]
        setTimeout(cycleChar, 50)
    }
    
    function setTimeout(callback, delay) {
        const timer = Qt.createQmlObject("import QtQuick; Timer {}", text)
        timer.interval = delay
        timer.repeat = false
        timer.triggered.connect(function() {
            callback()
            const index = text.activeTimers.indexOf(timer)
            if (index > -1) {
                text.activeTimers.splice(index, 1)
            }
            timer.destroy()
        })
        
        text.activeTimers.push(timer)
        timer.start()
    }
    
    Timer { //reveal timer
        id: revealTimer
        interval: text.animationDuration 
        repeat: true
        
        onTriggered: {
            if (text.currentIndex < text.animatedText.length) {
                revealCharacter(text.currentIndex)
                text.currentIndex++
            } else {
                stop()
                text.isAnimating = false
            }
        }
    }
}
