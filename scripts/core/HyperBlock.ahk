; Blocks Office 365 hyperkey shortcuts by temporarily registering hotkeys during Explorer restart to prevent unwanted Office app launches

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

autorun_HyperBlock(*){
    RegWrite("rundll32", "REG_SZ", "HKCU\Software\Classes\ms-officeapp\Shell\Open\Command")
    HyperBlock()
}
/* ------------------------------------------------------------------------------------------------------ */

HyperBlock(*) {
    MOD_NOREPEAT := 0x4000
    HYPER_MOD := 0x000F | MOD_NOREPEAT

    office_keys := [0x57, 0x54, 0x59, 0x4F, 0x50, 0x44, 0x4C, 0x58, 0x4E, 0x20]

    ; Test if Office hotkeys are still registered by trying to register one
    ; RegisterHotKey returns TRUE if successful, FALSE if already taken
    ; We use a test ID (999) to avoid conflicting with our normal registration IDs
    testResult := DllCall("RegisterHotKey", "Ptr", 0, "Int", 999, "UInt", HYPER_MOD, "UInt", office_keys[1])

    if (testResult) {
        ; Registration succeeded - Office shortcuts are already blocked
        ; Unregister our test hotkey and return early
        DllCall("UnregisterHotKey", "Ptr", 0, "Int", 999)
        return
    }

    ; Registration failed - Office has the hotkeys, need to restart Explorer

    ; Force kill explorer immediately
    Run(A_ComSpec . " /c taskkill /F /IM explorer.exe",, "Hide")
    Sleep(500)

    ; Register hotkeys
    for index, vk in office_keys {
        DllCall("RegisterHotKey", "Ptr", 0, "Int", index, "UInt", HYPER_MOD, "UInt", vk)
    }

    ; Start explorer as shell
    Run(A_ComSpec . " /c explorer.exe",, "Hide")
    Sleep(3000)

    ; Unregister hotkeys
    for index, vk in office_keys {
        DllCall("UnregisterHotKey", "Ptr", 0, "Int", index)
    }
}




