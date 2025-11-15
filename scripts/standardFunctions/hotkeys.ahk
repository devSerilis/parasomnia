#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of omni.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}


; *=========== DEFINE CUSTOM MODIFIER KEYS ===========*
KC_MEH := "!^+" ; Define the Meh key combination as Alt+Ctrl+Shift
KC_HYPR := "#!^+" ; Define the Hyper key combination as Win+Alt+Ctrl+Shift




; =========== DEFINE HOTKEY & WHICH FUNCTION THEY CALL ===========*

Hotkey(KC_HYPR "SPACE", launchClaude)
Hotkey(KC_HYPR "Q", forceKill) 
Hotkey(KC_HYPR "V", advancedPaste)

; KC_MEH Combinations (RSUPER)
; These hotkeys are purposefully designed to be difficult to trigger accidentally. 
Hotkey(KC_MEH "o", openScriptsFolder)
Hotkey(KC_MEH "r", reloadScript)
Hotkey(KC_MEH "F4", exitScript)
Hotkey(KC_MEH "x", emergencyReboot)


Hotkey("#Q", closeWindow)
Hotkey("F13", launchCommandPalette)
Hotkey("^J", gotoDownloads) 
Hotkey("#Enter", launchTerminal)
Hotkey("^!T", launchTerminal)



