; Main entry point for the Parasomnia AutoHotkey script suite - configures global settings, imports modules, and initializes all functionality

; =========== SET RECCOMENDED DEFAULT SETTINGS ===========

#Requires AutoHotkey v2.0
#SingleInstance Force
#WinActivateForce
SendMode("InputThenPlay")
InstallKeybdHook()
SetWorkingDir(A_ScriptDir)
ProcessSetPriority("High")
SetTitleMatchMode(2)
;TraySetIcon("parasomnia-dark.ico")
SetCapsLockState("AlwaysOff")
SetNumLockState("AlwaysOn")
SetScrollLockState("AlwaysOff")
Persistent

A_MenuMaskKey := "vkFF"

; =========== IMPORT SMALLER SCRIPTS AND MODULES ===========

#Include scripts/core/autorun.ahk                             ; Run all code meant to run when the script starts. 
#Include scripts/core/HyperBlock.ahk
#Include scripts/core/exitHandler.ahk                         ; Unhide all Hidden Windows When Script Exits
#Include scripts/functions/simpleFunctions.ahk              ; Functions that complete a single specific job and are reusable in more than one script. 
#Include scripts/hotkeys/hotkeys.ahk                          ; General Purpose Hotkey Creation
#Include scripts/hotkeys/hotstrings.ahk                       ; General Purpose Hotstring Creation
#Include scripts/modules/hiddenWindows.ahk
#Include scripts/modules/TaskbarClose.ahk                     ; Ctrl+Middle Click on Taskbar to Close Window
#Include scripts/modules/dontSleep.ahk                        ; Mouse Jiggler / Keep Alive
#Include scripts/modules/forcekill.ahk                        ; Allows the forceful termination of applications
#Include scripts/modules/VRGameFocusManager.ahk               ; Ensures Game Focus for HereSphere
#Include scripts/modules/comPalGuard.ahk                      ; Closes Command Pallette when it loses Focus
#Include scripts/modules/toggleWindowsTitlebar.ahk            ; Toggles the Windows Native Titlebar & Border
#Include scripts/modules/HealthCheck.ahk                      ; Function that runs every 5 secs, performing various script health checks.

SetThemeAppropriateIcon()


; =========== VERIFY THE COMMAND PALETTE IS RUNNING ===========

; CheckCommandPalette()







;! Define tray/menu functions before including other scripts so hotkey files can reference them
;! --------------------------------------------------------------------------------------------------------------------------------
A_TrayMenu.Delete() ; Clear default menu
A_TrayMenu.Add("Open Scripts Folder", openScriptsFolder)
A_TrayMenu.Add() ;
A_TrayMenu.Add("Reload", reloadScript) 
A_TrayMenu.Add("Exit", exitScript)




