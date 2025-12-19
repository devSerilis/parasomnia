; Automatically keeps HereSphere VR game focused to prevent freezing by continuously checking and reactivating the game window

#Requires AutoHotkey v2.0

/* ------------------------------------------------------------------------------------------------------ */
{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}

autorun_VRGameFocusManager(*){
    SetTimer CheckGameFocus, 500  ; Check every 500ms (adjust if needed)
}
/* ------------------------------------------------------------------------------------------------------ */





CheckGameFocus() {
    ; HereSphere VR game process
    gameProcess := "HereSphere-Win64-Shipping.exe"
    
    ; Check if the game process is running
    if !ProcessExist(gameProcess)
        return
    
    ; Get the active window's process name
    try {
        activeProcess := WinGetProcessName("A")
    } catch {
        return
    }
    
    ; If the active window is NOT HereSphere, activate it
    if (activeProcess != gameProcess) {
        try {
            WinActivate("ahk_exe " . gameProcess)
        }
    }
}

