; Provides hotkeys to hide active windows (Hyper+H) and restore them one at a time (Hyper+U) using a stack-based system

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

autorun_hiddenWindows(*) {
	Return
}
/* ------------------------------------------------------------------------------------------------------ */

+!^#h::{
    global HiddenWindows
    ExcludedTitles := ["Program Manager", "", "Start", "Search"]
       try {
           Handle := WinGetID("A")
           Title := WinGetTitle(Handle)
           IsExcluded := false
           If (Title != "Program Manager" && Title != "" && Title != "Start" && Title != "Search") { 
                WinHide(Handle)    
                HiddenWindows.Push(Handle)
            }       
        }
}


+^!#u::{
    global HiddenWindows
    While HiddenWindows.Length > 0 {
        Handle := HiddenWindows.Pop()
        If WinExist(Handle) {
            WinShow(Handle)
            Sleep 50
            WinActivate(Handle)
            Break 
        }       
    }
}