; Collection of reusable utility functions including window management, GUI helpers, application launchers, and system commands

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

autorun_simpleFunctions(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */



IsInArray(needle, haystack) {
    for item in haystack {
        if (item = needle)
            return true
    }
    return false
}


launchQuickNotes(*) {
        global geekWisdomNotebook
        timeNow := FormatTime(A_Now, "yyyy-MM-dd hh꞉mm")
        quickNote := geekWisdomNotebook "\" timeNow " Quick Note.md"
        FileAppend("", quickNote, "UTF-8")
        Run(quickNote)
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
    TrayTip("Reloading Parasomnia...")
    Reload()
}

exitScript(*) {
    TrayTip("All AutoHotKey Scripts have been terminated.")
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
}

launchSublime(*) {
    Run("C:\Program Files\Sublime Text\sublime_text.exe")
}

closeWindow(*) {
    ; Get the active window
    activeWindow := WinGetID("A")
    ; Send WM_CLOSE message (0x0010) to gracefully close the window
    PostMessage(0x0010, 0, 0, , activeWindow)
}

launchCommandPalette(*) {
    ; Send the command to open the Power Toys Command Palette
    SendInput("#!{Space}")
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




windowProbe(*) {
    ahk_class := WinGetClass("A")
    ahk_id := WinGetID("A")
    ahk_pid := WinGetPID("A")
    ahk_exe := WinGetProcessName("A")
    title := WinGetTitle("A") 
    myGui := Gui()
    myGui.SetFont("s12 w500", "Cascadia Code")
    myGui.AddText("y+m-10", "Title:       " title)
    myGui.AddText("y+m-10", "ahk_exe:     " ahk_exe)
    myGui.AddText("y+m-10", "ahk_class:   " ahk_class)
    myGui.AddText("y+m-10", "ahk_id:      " ahk_id)
    myGui.AddText("y+m-10", "ahk_pid:     " ahk_pid)
    okButton := myGui.AddButton("w80 Default", "OK")
    okButton.OnEvent("Click", (*) => myGui.Destroy())
    myGui.Show()
    ; Center the button after showing the GUI
    myGui.GetPos(&guiX, &guiY, &guiW, &guiH)
    okButton.GetPos(&btnX, &btnY, &btnW, &btnH)
    okButton.Move((guiW - btnW) / 2)
}


windowProbeMouse(*) {
    MouseGetPos , , &id, &control
    ahk_class := WinGetClass(id)
    ahk_id := WinGetID(id)
    ahk_pid := WinGetPID(id)
    ahk_exe := WinGetProcessName(id)
    title := WinGetTitle(id) 
    myGui := Gui()
    myGui.SetFont("s12 w500", "Cascadia Code")
    myGui.AddText("y+m-10", "Title:       " title)
    myGui.AddText("y+m-10", "ahk_exe:     " ahk_exe)
    myGui.AddText("y+m-10", "ahk_class:   " ahk_class)
    myGui.AddText("y+m-10", "ahk_id:      " ahk_id)
    myGui.AddText("y+m-10", "ahk_pid:     " ahk_pid)
    okButton := myGui.AddButton("w80 Default", "OK")
    okButton.OnEvent("Click", (*) => myGui.Destroy())
    myGui.Show()
    ; Center the button after showing the GUI
    myGui.GetPos(&guiX, &guiY, &guiW, &guiH)
    okButton.GetPos(&btnX, &btnY, &btnW, &btnH)
    okButton.Move((guiW - btnW) / 2)
}

GuiDisableMove(Handle)
{
    static SC_MOVE      := 0xF010
    static MF_BYCOMMAND := 0x00000000

    hMenu := DllCall("user32\GetSystemMenu", "Ptr", Handle, "Int", False, "Ptr")
    DllCall("user32\RemoveMenu", "Ptr", hMenu, "UInt", SC_MOVE, "UInt", MF_BYCOMMAND)
    return DllCall("user32\DrawMenuBar", "Ptr", Handle)
}

GuiDisableCloseButton(Handle)
{
    static SC_CLOSE    := 0xF060
    static MF_GRAYED   := 0x00000001
    static MF_DISABLED := 0x00000002

    hMenu := DllCall("user32\GetSystemMenu", "Ptr", Handle, "Int", False, "Ptr")
    DllCall("user32\EnableMenuItem", "Ptr", hMenu, "UInt", SC_CLOSE, "UInt", MF_GRAYED | MF_DISABLED)
    return DllCall("user32\DrawMenuBar", "Ptr", Handle)
}

/* 
 CheckCommandPalette() {
    cmdPalPath := "C:\Program Files\WindowsApps\Microsoft.CommandPalette_0.6.2882.0_x64__8wekyb3d8bbwe\Microsoft.CmdPal.UI.exe"
    
    ; Check if Microsoft.CmdPal.UI.exe is running
    if (!ProcessExist("Microsoft.CmdPal.UI.exe")) {
        ; Command Palette is not running, launch it
        try {
            Run(cmdPalPath)
            ; Wait a moment for it to start
            Sleep(2000)
        } catch as err {
            ToolTip("Failed to launch PowerToys Command Palette: " . err.Message)
            SetTimer(() => ToolTip(), -3000)
        }
    }
}
*/

