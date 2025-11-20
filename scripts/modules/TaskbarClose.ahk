#Requires AutoHotkey v2.0



{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}



; Ctrl+MiddleClick on taskbar - Close existing instance
^MButton::
{
    MouseGetPos ,, &winId
    if WinGetClass("ahk_id " winId) = "Shell_TrayWnd" or WinGetClass("ahk_id " winId) = "Shell_SecondaryTrayWnd"
    {
        ; Get the window under the mouse after the click
        Sleep 50
        try {
            hWnd := GetTaskbarWindow()
            if hWnd {
                WinClose "ahk_id " hWnd
            }
        }
    }
    else {
        Send "^{MButton}"
    }
}

; Ctrl+Alt+Shift+Win+MiddleClick on taskbar - Force close ALL instances

/* This section is not currently working, and attempts to close explorer.exe when executed.

^!+#MButton::
{
    MouseGetPos ,, &winId
    if WinGetClass("ahk_id " winId) = "Shell_TrayWnd" or WinGetClass("ahk_id " winId) = "Shell_SecondaryTrayWnd"
    {
        Sleep 50
        try {
            hWnd := GetTaskbarWindow()
            if hWnd {
                processName := WinGetProcessName("ahk_id " hWnd)
                windowTitle := WinGetTitle("ahk_id " hWnd)
                
                ; DEBUG: Show what we detected
                MsgBox "Detected Window: " windowTitle "`nProcess: " processName "`nWindow ID: " hWnd
                
                if processName and processName != "explorer.exe" {
                    Run "taskkill /F /IM " processName,, "Hide"
                    ToolTip "Force closed all instances of: " processName
                    SetTimer () => ToolTip(), -2000
                }
                else if processName = "explorer.exe" {
                    ToolTip "Cannot force close explorer.exe"
                    SetTimer () => ToolTip(), -2000
                }
            }
        }
    }
    else {
        Send "^!+#{MButton}"
    }
}

*/

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