#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
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
