; =========== SET RECCOMENDED DEFAULT SETTINGS ===========

#Requires AutoHotkey v2.0
#SingleInstance Force
#WinActivateForce
SendMode("InputThenPlay")
InstallKeybdHook()
SetWorkingDir(A_ScriptDir)
ProcessSetPriority("High")
SetTitleMatchMode(2)
TraySetIcon("parasomnia.ico")
SetCapsLockState("AlwaysOff")
SetNumLockState("AlwaysOn")
SetScrollLockState("AlwaysOff")
Persistent





; =========== REGISTER EXIT HANDLER ===========

OnExit(ExitFunc)                                                                                                      



; =========== VERIFY THE SCRIPT IS RUNNING WITH ADMIN PRIVILEGES ===========

if !A_IsAdmin {                                                                                                       
     try {
         Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
     } catch {
         MsgBox("Failed to attain administrator privilege level. Please run the script as an administrator.")    
     }
}






; =========== LAUNCH WATCHDOG SCRIPT ===========

Run(A_ScriptDir "\scripts\core\watchDog.ahk") 




; =========== DEFINE CUSTOM MODIFIER KEYS ===========
KC_MEH := "!^+"         ; Define the Meh key combination as Alt+Ctrl+Shift
KC_HYPR := "#!^+"       ; Define the Hyper key combination as Win+Alt+Ctrl+Shift



; =========== IMPORT SMALLER SCRIPTS AND MODULES ===========

#Include scripts/core/exitHandler.ahk                         ; Unhide all Hidden Windows When Script Exits
#Include scripts/hotkeys/hotkeys.ahk                          ; General Purpose Hotkey Creation
#Include scripts/hotkeys/hotstrings.ahk                       ; General Purpose Hotstring Creation
#Include scripts/reusableFunctions/simpleFunctions.ahk        ; Single Purpose Functions called by Hotkeys and other more complex scripts
#Include scripts/reusableFunctions/advancedFunctions.ahk      ; Single Purpose Functions called by Hotkeys and other more complex scripts
#Include scripts/modules/TaskbarClose.ahk                     ; Ctrl+Middle Click on Taskbar to Close Window
#Include scripts/modules/dontSleep.ahk                        ; Mouse Jiggler / Keep Alive
#Include scripts/modules/forcekill.ahk                        ; Allows the forceful termination of applications
#Include scripts/modules/VRGameFocusManager.ahk               ; Ensures Game Focus for HereSphere





; =========== VERIFY THE COMMAND PALETTE IS RUNNING ===========

CheckCommandPalette()







;! Define tray/menu functions before including other scripts so hotkey files can reference them
;! --------------------------------------------------------------------------------------------------------------------------------
A_TrayMenu.Delete() ; Clear default menu
A_TrayMenu.Add("Open Scripts Folder", openScriptsFolder)
A_TrayMenu.Add() ;
A_TrayMenu.Add("Reload", reloadScript) 
A_TrayMenu.Add("Exit", exitScript)




