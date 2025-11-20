#Requires AutoHotkey v2.0
#SingleInstance Force
#WinActivateForce
#NoTrayIcon 

SetTimer(CheckMainScript, 5000)  ; Check every 5 seconds
SetTimer(CheckCommandPalette, 5000)  ; Check Command Palette every 5 seconds

CheckMainScript() {
    ; Get the full path of our target script
    targetScript := A_ScriptDir . "\parasomnia.ahk"
    
    ; Use ProcessExist to check if our script is still running
    ; We'll need to look at the command line of each AutoHotkey process
    ProcessWait("AutoHotkey64.exe", 1)  ; Wait up to 1 second for any AutoHotkey process
    scriptFound := false
    
    try {
        ; Get the list of running processes using built-in commands
        DetectHiddenWindows(true)
        SetTitleMatchMode(2)  ; Partial match
        
        ; Check if our script window exists
        if (!WinExist("parasomnia.ahk ahk_exe AutoHotkey64.exe")) {
            Sleep(1000)  ; Brief delay before restart
            Run(targetScript)
        }
    }
}

CheckCommandPalette() {
    ; Check if PowerToys Command Palette is running
    if (!ProcessExist("Microsoft.CmdPal.UI.exe")) {
        ; Command Palette is not running, launch it
        cmdPalPath := "C:\Program Files\WindowsApps\Microsoft.CommandPalette_0.6.2882.0_x64__8wekyb3d8bbwe\Microsoft.CmdPal.UI.exe"
        try {
            Run(cmdPalPath)
        }
    }
}
