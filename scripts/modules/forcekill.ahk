#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}


; Global counter for explorer.exe force kill attempts
explorerKillCounter := 0
explorerKillTimerHandle := 0

forceKill(*) {    
    {
        try {
            mouseX := 0
            mouseY := 0
            hWnd := 0
            MouseGetPos(&mouseX, &mouseY, &hWnd)

                        if (hWnd == 0) {
                ToolTip("No window found under the cursor.")
                SetTimer(() => ToolTip(), -3000)
                return
            }

            pid := Buffer(4, 0)  ; Create a buffer to store the process ID
            DllCall("GetWindowThreadProcessId", "Ptr", hWnd, "Ptr", pid)
            pid := NumGet(pid, 0, "UInt")  ; Extract the process ID from the buffer

            if (pid != 0) {
                processName := GetProcessName(pid)

                                ; Check if the process is explorer.exe
                isExplorer := (StrLower(processName) == "explorer.exe")
                
                if (isExplorer) {
                    ; Handle explorer.exe with counter logic
                    global explorerKillCounter
                    global explorerKillTimerHandle
                    
                    ; Increment counter
                    explorerKillCounter++
                    
                    ; Clear existing reset timer
                    if (explorerKillTimerHandle != 0) {
                        SetTimer(explorerKillTimerHandle, 0)
                    }
                    
                    if (explorerKillCounter == 1) {
                        ; First press: Force kill all File Explorer windows (CabinetWClass)
                        closedCount := 0
                        try {
                            ; Loop through all windows with CabinetWClass and kill their PIDs
                            windows := WinGetList("ahk_class CabinetWClass")
                            for hwnd in windows {
                                ; Get PID for this window
                                windowPid := Buffer(4, 0)
                                DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", windowPid)
                                windowPid := NumGet(windowPid, 0, "UInt")
                                
                                if (windowPid != 0) {
                                    ; Force kill this specific PID
                                    RunWait(A_ComSpec . " /c taskkill /F /PID " . windowPid,, "Hide")
                                    closedCount++
                                }
                            }
                            
                                                        if (closedCount > 0) {
                                ToolTip("Force killed " . closedCount . " File Explorer window(s).`nPress again to kill and restart explorer.exe.")
                                SetTimer(() => ToolTip(), -3000)
                            } else {
                                ToolTip("No File Explorer windows found.`nPress again to kill and restart explorer.exe.")
                                SetTimer(() => ToolTip(), -3000)
                            }
                        } catch as err {
                            ToolTip("Failed to kill File Explorer windows. Error: " . err.Message)
                            SetTimer(() => ToolTip(), -3000)
                        }
                        
                        ; Set timer to reset counter after 5 seconds of inactivity
                        explorerKillTimerHandle := () => ResetExplorerCounter()
                        SetTimer(explorerKillTimerHandle, -5000)
                        
                                        } else if (explorerKillCounter >= 2) {
                        ; Second press: Kill all explorer.exe and restart
                        try {
                            ; Use taskkill to forcefully terminate all instances
                            RunWait(A_ComSpec . " /c taskkill /F /IM explorer.exe",, "Hide")
                            
                            ToolTip("All instances of explorer.exe terminated.`nRestarting in 3 seconds...")
                            SetTimer(() => ToolTip(), -3000)
                            
                            ; Wait 3 seconds then restart explorer
                            SetTimer(() => Run("explorer.exe"), -3000)
                            
                            ; Reset counter
                            explorerKillCounter := 0
                        } catch as err {
                            ToolTip("Failed to terminate explorer.exe. Error: " . err.Message)
                            SetTimer(() => ToolTip(), -3000)
                        }
                    }
                                } else {
                    ; Non-explorer process: kill immediately with tooltip
                    try {
                        ; Use taskkill to forcefully terminate all instances
                        RunWait(A_ComSpec . " /c taskkill /F /IM " . processName,, "Hide")
                        ToolTip("All instances of " . processName . " terminated.")
                        SetTimer(() => ToolTip(), -3000)
                    } catch as err {
                        ToolTip("Failed to terminate processes. Error: " . err.Message)
                        SetTimer(() => ToolTip(), -3000)
                    }
                }
                        } else {
                ToolTip("Failed to get process ID.")
                SetTimer(() => ToolTip(), -3000)
            }
                } catch as err {
            ToolTip("An error occurred: " . err.Message)
            SetTimer(() => ToolTip(), -3000)
        }
    }
}

GetProcessName(pid) {
    try {
        for process in ComObject("WbemScripting.SWbemLocator").ConnectServer().ExecQuery("SELECT * FROM Win32_Process WHERE ProcessId=" . pid) {
            return process.Name
        }
    } catch as err {
        return "Unknown (Error: " . err.Message . ")"
    }
    return "Unknown"
}

ResetExplorerCounter() {
    global explorerKillCounter
    global explorerKillTimerHandle
    explorerKillCounter := 0
    explorerKillTimerHandle := 0
}
