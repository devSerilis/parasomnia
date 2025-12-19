; Automatically closes the Command Palette window when it loses focus to prevent it from staying open unintentionally

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

autorun_comPalGuard(*){
    ; Ask Windows to notify us about window events
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
; Get the message number Windows will use for notifications
MsgNumber := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
; Tell AHK to call ShellEvent when that message arrives
OnMessage(MsgNumber, ShellEvent)

ShellEvent(wParam, lParam, msg, hwnd) {
    ; wParam=1 means a window was just created
    if (wParam = 1) {
        title := WinGetTitle("ahk_id " lParam)
        ; Is it the Command Palette?
        if (title = "Command Palette") {
            ; Start checking for focus loss 20 times per second
            SetTimer(MonitorCommandPalette, 50)
           }
        }
    }

; Ask Windows to notify us about window events
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
; Get the message number Windows will use for notifications
MsgNumber := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
; Tell AHK to call ShellEvent when that message arrives
OnMessage(MsgNumber, ShellEvent)



}
/* ------------------------------------------------------------------------------------------------------ */


ShellEvent(wParam, lParam, msg, hwnd) {
    ; wParam=1 means a window was just created
    if (wParam = 1) {
        title := WinGetTitle("ahk_id " lParam)
        ; Is it the Command Palette?
        if (title = "Command Palette") {
            ; Start checking for focus loss 20 times per second
            SetTimer(MonitorCommandPalette, 50)
        }
    }
}

MonitorCommandPalette() {
    ; Does Command Palette still exist?
    if WinExist("Command Palette") {
        ; Does it NOT have focus?
        if !WinActive("Command Palette") {
            ; Close it and stop monitoring
            WinClose("Command Palette")
            SetTimer(MonitorCommandPalette, 0)
        }
    }
    else {
        ; Window gone, stop monitoring
        SetTimer(MonitorCommandPalette, 0)
    }
}



