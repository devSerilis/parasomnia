; Handles script exit events - restores hidden windows on normal exit, force-kills AutoHotkey processes on system shutdown/logoff

#Requires AutoHotkey v2.0



{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}

autorun_exitHandler(*){
    Return
}




ExitFunc(ExitReason, ExitCode) {
    global HiddenWindows
    ; If shutting down/logging off, exit immediately without restoring windows
    if (ExitReason = "Logoff" or ExitReason = "Shutdown") {
        Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
        Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
    }
    else {
        DetectHiddenWindows True
        for Handle in HiddenWindows {
            WinShow(Handle)
        }
    }
}

