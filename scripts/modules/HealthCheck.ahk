; Provides time manipulation utilities - converts time formats, checks time ranges, and calculates minutes since midnight

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

autorun_HealthCheck(*) {
    SetTimer(HealthCheck, 5000)  ; Check every 5 seconds
	Return
}
/* ------------------------------------------------------------------------------------------------------ */


HealthCheck(*) {
    
; Set Approriate Icon Color based on Windows Theme
    static lastMode := IsDarkMode()
    currentMode := IsDarkMode()
    
    if (currentMode != lastMode) {
        SetThemeAppropriateIcon()
        lastMode := currentMode
    }

}