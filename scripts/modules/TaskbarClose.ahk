; Enables closing windows via Ctrl+MiddleClick on taskbar buttons (single instance) or Ctrl+Alt+MiddleClick (all instances)

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

autorun_TaskbarClose(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */


; Logging function for TaskbarClose debugging
LogTaskbarClose(message) {
    logFile := A_ScriptDir "\TaskbarClose_debug.log"
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    FileAppend timestamp " - " message "`n", logFile
}



; Ctrl+MiddleClick on taskbar - Close existing instance
^MButton::
{
    LogTaskbarClose("========== CTRL+MBUTTON TRIGGERED ==========")

    ; Check if we're on the taskbar first
    MouseGetPos ,, &winId
    taskbarClass := WinGetClass("ahk_id " winId)
    LogTaskbarClose("Window class under cursor: " taskbarClass)

    if (taskbarClass = "Shell_TrayWnd" or taskbarClass = "Shell_SecondaryTrayWnd")
    {
        LogTaskbarClose("Confirmed on taskbar - proceeding")

        ; STEP 1: Save the currently active window before clicking
        try {
            preClickActiveId := WinGetID("A")
            preClickTitle := WinGetTitle("ahk_id " preClickActiveId)
            preClickProcess := WinGetProcessName("ahk_id " preClickActiveId)
            LogTaskbarClose("Before click - Active window ID: " preClickActiveId " | Title: " preClickTitle " | Process: " preClickProcess)
        } catch {
            preClickActiveId := 0
            LogTaskbarClose("Before click - No active window detected")
        }

        ; STEP 2: Send the click
        Click
        Sleep 100
        LogTaskbarClose("Click sent, waited 100ms")

        ; STEP 3: Get the currently active window after clicking
        try {
            postClickActiveId := WinGetID("A")
            postClickTitle := WinGetTitle("ahk_id " postClickActiveId)
            postClickProcess := WinGetProcessName("ahk_id " postClickActiveId)
            LogTaskbarClose("After click - Active window ID: " postClickActiveId " | Title: " postClickTitle " | Process: " postClickProcess)
        } catch {
            postClickActiveId := 0
            LogTaskbarClose("After click - No active window detected")
        }

        ; STEP 4: Check if the pre-click window was minimized
        if (preClickActiveId != 0) {
            try {
                isMinimized := WinGetMinMax("ahk_id " preClickActiveId) = -1
                LogTaskbarClose("Pre-click window minimized? " (isMinimized ? "YES" : "NO"))

                if (isMinimized) {
                    ; The window we clicked is the one that was active and is now minimized
                    LogTaskbarClose("Decision: Clicked window minimized it. Closing pre-click window.")

                    if (preClickProcess = "explorer.exe") {
                        LogTaskbarClose("BLOCKED: Cannot close explorer.exe")
                        ToolTip "Cannot close explorer.exe"
                        SetTimer () => ToolTip(), -2000
                    } else {
                        WinClose "ahk_id " preClickActiveId
                        LogTaskbarClose("SUCCESS: Closed window - " preClickTitle)
                        ToolTip "Closed: " preClickTitle
                        SetTimer () => ToolTip(), -2000
                    }
                    LogTaskbarClose("========== COMPLETED ==========`n")
                    return
                }
            } catch {
                LogTaskbarClose("ERROR: Could not check if pre-click window was minimized")
            }
        }

        ; STEP 5: Window wasn't minimized, check if active window changed
        if (preClickActiveId != postClickActiveId and postClickActiveId != 0) {
            ; A different window became active - we gave focus to something new
            LogTaskbarClose("Decision: Active window changed. Closing post-click window.")

            if (postClickProcess = "explorer.exe") {
                LogTaskbarClose("BLOCKED: Cannot close explorer.exe")
                ToolTip "Cannot close explorer.exe"
                SetTimer () => ToolTip(), -2000
            } else {
                WinClose "ahk_id " postClickActiveId
                LogTaskbarClose("SUCCESS: Closed window - " postClickTitle)
                ToolTip "Closed: " postClickTitle
                SetTimer () => ToolTip(), -2000
            }
        } else {
            ; Window state didn't change meaningfully
            LogTaskbarClose("Decision: No meaningful window state change detected.")
            ToolTip "Unable to determine clicked window - no state change detected"
            SetTimer () => ToolTip(), -3000
        }

        LogTaskbarClose("========== COMPLETED ==========`n")
    }
    else {
        LogTaskbarClose("Not on taskbar - passing through hotkey")
        Send "^{MButton}"
        LogTaskbarClose("========== PASSED THROUGH ==========`n")
    }
}

; Ctrl+Alt+MiddleClick on taskbar - Force close ALL instances
^!MButton::
{
    LogTaskbarClose("========== CTRL+ALT+MBUTTON TRIGGERED ==========")

    ; Check if we're on the taskbar first
    MouseGetPos(&mouseX, &mouseY, &winId)
    LogTaskbarClose("Mouse position: " mouseX ", " mouseY " | Window ID under cursor: " winId)

    taskbarClass := WinGetClass("ahk_id " winId)
    LogTaskbarClose("Window class under cursor: " taskbarClass)

    if (taskbarClass = "Shell_TrayWnd" or taskbarClass = "Shell_SecondaryTrayWnd")
    {
        LogTaskbarClose("Confirmed on taskbar - proceeding")

        ; STEP 1: Save the currently active window before clicking
        try {
            preClickActiveId := WinGetID("A")
            preClickTitle := WinGetTitle("ahk_id " preClickActiveId)
            preClickProcess := WinGetProcessName("ahk_id " preClickActiveId)
            LogTaskbarClose("Before click - Active window ID: " preClickActiveId " | Title: " preClickTitle " | Process: " preClickProcess)
        } catch {
            preClickActiveId := 0
            preClickProcess := ""
            LogTaskbarClose("Before click - No active window detected")
        }

        ; STEP 2: Send the click
        Click
        Sleep 100
        LogTaskbarClose("Click sent, waited 100ms")

        ; STEP 3: Get the currently active window after clicking
        try {
            postClickActiveId := WinGetID("A")
            postClickTitle := WinGetTitle("ahk_id " postClickActiveId)
            postClickProcess := WinGetProcessName("ahk_id " postClickActiveId)
            LogTaskbarClose("After click - Active window ID: " postClickActiveId " | Title: " postClickTitle " | Process: " postClickProcess)
        } catch {
            postClickActiveId := 0
            postClickProcess := ""
            LogTaskbarClose("After click - No active window detected")
        }

        ; Variable to store which process we want to kill
        targetProcess := ""

        ; STEP 4: Check if the pre-click window was minimized
        if (preClickActiveId != 0) {
            try {
                isMinimized := WinGetMinMax("ahk_id " preClickActiveId) = -1
                LogTaskbarClose("Pre-click window minimized? " (isMinimized ? "YES" : "NO"))

                if (isMinimized) {
                    ; The window we clicked is the one that was active and is now minimized
                    LogTaskbarClose("Decision: Clicked window minimized it. Killing pre-click process.")
                    targetProcess := preClickProcess
                }
            } catch {
                LogTaskbarClose("ERROR: Could not check if pre-click window was minimized")
            }
        }

        ; STEP 5: If window wasn't minimized, check if active window changed
        if (targetProcess = "" and preClickActiveId != postClickActiveId and postClickActiveId != 0) {
            ; A different window became active - we gave focus to something new
            LogTaskbarClose("Decision: Active window changed. Killing post-click process.")
            targetProcess := postClickProcess
        }

        ; STEP 6: Execute the kill if we identified a target
        if (targetProcess != "") {
            if (targetProcess = "explorer.exe") {
                LogTaskbarClose("BLOCKED: Cannot kill explorer.exe")
                ToolTip "Cannot force close explorer.exe"
                SetTimer () => ToolTip(), -2000
            } else {
                LogTaskbarClose("Executing: taskkill /F /IM " targetProcess)
                Run "taskkill /F /IM " targetProcess,, "Hide"
                LogTaskbarClose("SUCCESS: Killed all instances of " targetProcess)
                ToolTip "Force closed all instances of: " targetProcess
                SetTimer () => ToolTip(), -2000
            }
        } else {
            ; Window state didn't change meaningfully
            LogTaskbarClose("Decision: No meaningful window state change detected.")
            ToolTip "Unable to determine clicked window - no state change detected"
            SetTimer () => ToolTip(), -3000
        }

        LogTaskbarClose("========== COMPLETED ==========`n")
    }
    else {
        LogTaskbarClose("Not on taskbar - passing through hotkey")
        Send "^!{MButton}"
        LogTaskbarClose("========== PASSED THROUGH ==========`n")
    }
}


; Function to get the window associated with taskbar button under mouse
GetTaskbarWindow()
{
    ; Click to activate and return the window
    Click
    Sleep 100
    activeWin := WinGetID("A")
    return activeWin
}

; Helper function to check if window should be on taskbar
IsWindowOnTaskbar(hWnd)
{
    try {
        exStyle := WinGetExStyle("ahk_id " hWnd)
        style := WinGetStyle("ahk_id " hWnd)
        
        ; Check if window is visible and has proper styles for taskbar
        if (style & 0x10000000) ; WS_VISIBLE
        {
            ; Exclude tool windows and windows with no taskbar button
            if !(exStyle & 0x80) and !(exStyle & 0x40000) ; Not WS_EX_TOOLWINDOW and not WS_EX_NOACTIVATE
            {
                return true
            }
        }
    }
    return false
}