; Central hotkey registry defining all keyboard shortcuts used throughout the Parasomnia script suite

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

autorun_hotkeys(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */


; All Hotkeys in the entire script should be defined on this page. Other #Included scripts are for the variables, timers, and functions that these hotkeys call upon. 
; This provides a single place to look up what hotkey does what, as well as where to go if you want to rebind something. 
; The functions called here should be named to describe their effect as best as possible while keeping it to 2-3 words maximum. 

; Generally speaking I want to define hotkeys using this syntax because it reads as 1 hotkey per line, and you can easily see which function is called by which hotkey and infer what the hotkey does. 
; Additionally, this method means the function of the hotkey may be called at any time by other modules , without requiring a hotkey being pressed by the user. 
; White space does not matter so I have taken care to create columns to improve readability. 

; KC_HYPR Combinations (LSUPER + RSUPER)

Hotkey(KC_HYPR "SPACE",     launchClaude)
Hotkey(KC_HYPR "r",         reloadScript)
Hotkey(KC_HYPR "Q",         forceKill) 
Hotkey(KC_HYPR "MBUTTON",   forceKillUnderMouse) 
Hotkey(KC_HYPR "V",         advancedPaste)
Hotkey(KC_HYPR "Enter",     launchQuickNotes)



; KC_MEH Combinations (RSUPER)

Hotkey(KC_MEH "o",          openScriptsFolder)
Hotkey(KC_MEH "F4",         exitScript)
Hotkey(KC_MEH "x",          emergencyReboot)

; Standard Modifier Hotkeys

Hotkey("#Q",                closeWindow)
Hotkey("F13",               launchCommandPalette)
Hotkey("^J",                gotoDownloads) 
Hotkey("#Enter",            launchTerminal)
Hotkey("^!T",               launchTerminal)
Hotkey("#MBUTTON",          windowProbeMouse)
Hotkey("#/",                windowProbe)
Hotkey("!F3",               toggleWindowsTitlebar)

; However, very simple hotkeys that can run on a single line and be easily read may be included using standard syntax. 
; Consider whether or not the function of your hotkey might ever be needed by another script before building your hotkey this way.

!/::                    SendInput("⁄")      ; Sends a "fake" forward slash using Unicode
!SC027::                SendInput("꞉")      ; Sends a "fake" colon using Unicode
