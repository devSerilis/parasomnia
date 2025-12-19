; Mouse jiggler that automatically moves the mouse during work hours (7:45 AM - 6:00 PM) to prevent screen lock and inactivity timeouts

#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}

autorun_dontSleep(*){
    Return
}


; Global variable to track if the timer is active
; global isTimerActive := false -- moved to globalVariables.ahk

; Function to check if current time is within work hours (7:45 AM to 6:00 PM)
IsWorkHours2() {
    currentHour := FormatTime(, "HH")
    currentMinute := FormatTime(, "mm")
    
    ; Convert current time to minutes since midnight
    currentTimeInMinutes := (currentHour * 60) + currentMinute
    
    ; Convert work hours to minutes (7:45 = 465 minutes, 18:00 = 1080 minutes)
    workStartMinutes := (7 * 60) + 45
    workEndMinutes := 18 * 60
    
    return currentTimeInMinutes >= workStartMinutes && currentTimeInMinutes < workEndMinutes
}

; Function to manage timer state
CheckAndUpdateTimerState() {
    global isTimerActive  ; Add this line to access the global variable
    if IsWorkHours2() {
        if !isTimerActive {
            SetTimer(MoveMouseRandomly, Random(180000, 300000))
            isTimerActive := true
        }
    } else {
        if isTimerActive {
            SetTimer(MoveMouseRandomly, 0)  ; Disable timer
            isTimerActive := false
        }
    }
    ; Check again in 1 minute
    SetTimer(CheckAndUpdateTimerState, 60000)
}

MoveMouseRandomly() {
    ; Get current mouse position
    MouseGetPos(&currentX, &currentY)
    
    ; Generate random small movements (-10 to 10 pixels)
    moveX := Random(-10, 10)
    moveY := Random(-10, 10)
    
    ; Move the mouse
    MouseMove(currentX + moveX, currentY + moveY, 2)  ; '2' is a slow movement speed

    ; Optional: Move mouse back to original position after a short delay
    ; Capture the original position before the timer
    origX := currentX
    origY := currentY
    SetTimer(() => (MouseMove(origX, origY, 2), ""), -50)  ; Move back after 50ms
    
    ; Set the next timer for a random interval between 3-5 minutes
    if isTimerActive {
        SetTimer(MoveMouseRandomly, Random(180000, 300000))
    }
}

; Start the time checker when script launches
CheckAndUpdateTimerState()