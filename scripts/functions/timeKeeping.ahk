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

autorun_timeKeepings(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */


; Core function - returns minutes since midnight
currentTimeInMinutes() {
    return (A_Hour * 60) + (A_Min)
}

; Helper: Check if current time is within a range
IsTimeBetween(startTime, endTime) {
    ; startTime and endTime in "HH:MM" format
    current := currentTimeInMinutes()
    start := TimeToMinutes(startTime)
    end := TimeToMinutes(endTime)
    
    return (current >= start && current <= end)
}

; Helper: Convert "HH:MM" string to minutes since midnight
TimeToMinutes(timeStr) {
    parts := StrSplit(timeStr, ":")
    return (Integer(parts[1]) * 60) + Integer(parts[2])
}

; Helper: Convert minutes back to "HH:MM" format
MinutesToTime(minutes) {
    hours := Floor(minutes / 60)
    mins := Mod(minutes, 60)
    return Format("{:02d}:{:02d}", hours, mins)
}

timeNow(*) {
    FormatTime(A_Now,"hh꞉mm")
}

; Usage examples:
; If (IsTimeBetween("09:00", "17:00"))
;     MsgBox("Work hours!")
;
; If (currentTimeInMinutes () > TimeToMinutes("14:30"))
;     MsgBox("Past 2:30 PM")