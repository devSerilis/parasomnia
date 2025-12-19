; Initialization script that runs on startup - requests admin privileges, defines global variables, registers exit handler, and executes autorun functions from all modules

#Requires AutoHotkey v2.0

{
    DetectHiddenWindows True
    ScriptFileName := SubStr(A_LineFile, InStr(A_LineFile, "\",, -1) + 1)
    if (WinExist(ScriptFileName " ahk_class AutoHotkey")) {
        MsgBox("This is a sub-module of parasomnia.ahk and is not intended to be run independently. Forcibly Terminating Now.")
        ExitApp
    }
}

if !A_IsAdmin {                                ; Verify script is running with priveledges.                                                                        
    try {
        Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
    } catch {
    MsgBox("Failed to attain administrator privilege level. Please run the script as an administrator.")    
    }
}


; Locations
global geekWisdomNotebook := "Z:\Notebooks\geekwisdom\"
global A_UserProfile := EnvGet("USERPROFILE")

; Modifier Keys
global KC_MEH := "!^+"         
global KC_HYPR := "#!^+"  

; Initiate Global Variables
global isTimerActive := false
global HiddenWindows := []
global explorerKillCounter := 0
global explorerKillTimerHandle := 0

; Setup ExitFunc for damage control if script crashes.                
OnExit(ExitFunc)                               


; Start watchdog script. 
Run(A_ScriptDir "\scripts\core\watchDog.ahk")  


; Execute code from the autorun section of each module. 
autorun_HyperBlock()
autorun_exitHandler()
autorun_simpleFunctions()
autorun_hotkeys()
autorun_hotstrings()
autorun_hiddenWindows()
autorun_TaskbarClose()
autorun_dontSleep()
autorun_forcekill()
autorun_VRGameFocusManager()
autorun_comPalGuard()
autorun_toggleWindowsTitlebar()
autorun_HealthCheck()