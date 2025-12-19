; Provides functions to forcefully terminate applications - handles active windows, windows under mouse cursor, and special cases like File Explorer

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

autorun_forceKill(*){
    Return
}
/* ------------------------------------------------------------------------------------------------------ */

; Force kill the active window
forceKill(*) {
    try {
        activeClass := WinGetClass("A")
        processName := WinGetProcessName("A")

        KillWindowByClassAndProcess(activeClass, processName)
    } catch as err {
        ToolTip("Error: " . err.Message)
        SetTimer(() => (ToolTip(), ""), -3000)
    }
}

; Force kill the window under the mouse cursor
forceKillUnderMouse(*) {
    try {
        MouseGetPos(, , &hWnd)

        if (hWnd == 0) {
            ToolTip("No window found under the cursor.")
            SetTimer(() => (ToolTip(), ""), -3000)
            return
        }

        windowClass := WinGetClass(hWnd)
        processName := WinGetProcessName(hWnd)

        KillWindowByClassAndProcess(windowClass, processName)
    } catch as err {
        ToolTip("Error: " . err.Message)
        SetTimer(() => (ToolTip(), ""), -3000)
    }
}

; Shared logic for killing windows by class and process
KillWindowByClassAndProcess(windowClass, processName) {
    ; File Explorer window - close all File Explorer windows (without killing shell)
    if (windowClass == "CabinetWClass") {
        closedCount := 0
        windows := WinGetList("ahk_class CabinetWClass")
        for hwnd in windows {
            WinClose(hwnd)
            closedCount++
        }
        ; Give windows a moment to close gracefully
        Sleep(100)
        ; Force close any that remain
        remainingWindows := WinGetList("ahk_class CabinetWClass")
        if (remainingWindows.Length > 0) {
            for hwnd in remainingWindows {
                try WinKill(hwnd)
            }
        }
        ToolTip("Closed " . closedCount . " File Explorer window(s)")
        SetTimer(() => (ToolTip(), ""), -3000)
    }
    ; Shell (taskbar/desktop) - kill and restart
    else if (StrLower(processName) == "explorer.exe") {
        Run(A_ComSpec . " /c taskkill /F /IM explorer.exe",, "Hide")
        ToolTip("Killing explorer.exe shell... restarting in 3 seconds")
        SetTimer(() => (ToolTip(), ""), -3000)
        SetTimer(() => (Run("explorer.exe"), ""), -3000)
    }
    ; Any other process - kill all instances
    else {
        Run(A_ComSpec . " /c taskkill /F /IM " . processName,, "Hide")
        ToolTip("Killed all instances of " . processName)
        SetTimer(() => (ToolTip(), ""), -3000)
    }
}

