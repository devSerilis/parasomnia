; Toggles the title bar and border of the active window using Alt+F3 hotkey

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

autorun_toggleWindowsTitlebar(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */

toggleWindowsTitlebar(*){
    MsgBox("Triggered")
    hwnd := WinGetID("A")
    style := WinGetStyle(hwnd)

    if (style & 0xC00000) {           ; WS_CAPTION present? [web:11][web:21]
        ; Remove caption (title bar + border)
        WinSetStyle("-0xC00000", hwnd)
    } else {
        ; Add caption back
        WinSetStyle("+0xC00000", hwnd)
    }
}