#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of omni.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}



ExitFunc(ExitReason, ExitCode)
{
    ; If shutting down/logging off, exit immediately without restoring windows
    if (ExitReason = "Logoff" or ExitReason = "Shutdown")
    {
        Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
        Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
    }
    ; For all other exit reasons (user closing script, crash, etc.), restore windows
    WinShow("ahk_state Hidden")
}
