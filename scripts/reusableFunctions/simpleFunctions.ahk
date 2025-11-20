#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}

IsInArray(needle, haystack) {
    for item in haystack {
        if (item = needle)
            return true
    }
    return false
}

aSyncMsgBox(Message) {
     MsgBox Message, "Alert!"
}

UnhideAllWindows(*) {                   
    WinShow("ahk_state Hidden")
}

openScriptsFolder(*) {
    Run("explorer.exe " A_ScriptDir "\scripts")
}

reloadScript(*) {
    ToolTip("Reloading Parasomnia...")
    Reload()
}

exitScript(*) {
    TrayTip("All AutoHotKey Scripts have been terminated.")
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
}


closeWindow(*) {
    ; Get the active window
    activeWindow := WinGetID("A")
    ; Send WM_CLOSE message (0x0010) to gracefully close the window
    PostMessage(0x0010, 0, 0, , activeWindow)
}

launchCommandPalette(*) {
    ; Send the command to open the Power Toys Command Palette
    SendInput("!^+{Space}")
}

launchClaude(*) {
    ; Send the command to open the Power Toys Command Palette
    SendInput("^!{Space}")
}

launchTerminal(*) {
    Run("C:\Users\Andrew\AppData\Local\Microsoft\WindowsApps\wt.exe")
}

testMessage(*) {
    MsgBox("You pressed Alt + A")
}


emergencyReboot(*) {
    Run(A_ComSpec . " /c shutdown /r /f /t 0",, "Hide")
}

gotoDownloads(*) {
Run("explorer shell:downloads")
}

gotoExplorer(*) {
    Run("explorer.exe shell: ")
}


advancedPaste(*) {
    ; PowerToys Advanced Paste hotkey is Win+Shift+V by default which conflicts with "Cycle through notifications"; which we will overwrite and ignore.
    Send "#+v"
    return
}
