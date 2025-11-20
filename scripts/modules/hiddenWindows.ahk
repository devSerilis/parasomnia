#Requires AutoHotkey v2.0

HiddenWindows := []


^!h::{
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


^!u::{
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