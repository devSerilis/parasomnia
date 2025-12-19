# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Project

Parasomnia is an AutoHotkey v2.0 script suite for Windows automation, productivity enhancement, and quality-of-life improvements. It runs as a single main script (`parasomnia.ahk`) that includes and initializes multiple sub-modules.

## Running and Testing

**Start the script:**
```bash
# Run with AutoHotkey v2.0 (requires admin privileges)
# The script will auto-elevate if not running as administrator
"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe" parasomnia.ahk
```

**Important:** This script requires AutoHotkey v2.0 or later. It will not work with v1.x.

**Reload after changes:**
- Use the system tray icon → Reload
- Or press `Hyper+R` (Win+Alt+Ctrl+Shift+R)
- The script automatically reloads when the main file changes

## Architecture Overview

### Module System and Autorun Pattern

All modules follow a strict pattern to prevent standalone execution and enable centralized initialization:

1. **Standalone Execution Prevention**: Each module begins with a guard block that checks if it's running independently and terminates if so. Modules MUST be included by `parasomnia.ahk`.

2. **Autorun Functions**: Every module exports an `autorun_<modulename>()` function that is called during initialization by `scripts/core/autorun.ahk`. Even if a module has no initialization code, it must provide an empty autorun function that returns immediately.

3. **Include Order**: `parasomnia.ahk` includes modules in a specific order:
   - Core modules first (`autorun.ahk`, `HyperBlock.ahk`, `exitHandler.ahk`)
   - Function libraries (`simpleFunctions.ahk`)
   - Hotkey/hotstring definitions
   - Feature modules (TaskbarClose, dontSleep, forcekill, etc.)

### Core Architecture Components

**parasomnia.ahk** - Main entry point:
- Sets global AutoHotkey settings (SendMode, WorkingDir, TitleMatchMode, etc.)
- Disables CapsLock, enables NumLock
- Includes all sub-modules
- Defines system tray menu
- Does NOT contain business logic

**scripts/core/autorun.ahk** - Initialization orchestrator:
- Requests administrator privileges if not already elevated
- Defines global variables (modifier keys, paths, state flags)
- Registers the exit handler (`ExitFunc`)
- Launches the watchdog script
- Calls all module autorun functions in sequence

**scripts/core/watchDog.ahk** - Process monitor:
- Standalone script that runs independently
- Checks every 5 seconds if `parasomnia.ahk` is still running
- Automatically restarts the main script if it crashes
- Uses `#NoTrayIcon` to stay hidden

**scripts/core/exitHandler.ahk** - Cleanup manager:
- Defines `ExitFunc()` which handles script termination
- On normal exit: restores all hidden windows from the `HiddenWindows` array
- On shutdown/logoff: force-kills all AutoHotkey processes immediately

**scripts/core/HyperBlock.ahk** - Office 365 blocker:
- Prevents Windows Office 365 shortcuts from launching during Explorer restart
- Temporarily registers Hyper key hotkeys (Win+Alt+Ctrl+Shift combinations) via DllCall to block Office apps
- Kills and restarts Explorer.exe with the hotkeys active

### Global Variables

Defined in `scripts/core/autorun.ahk`:

```ahk
; Modifier Keys (used throughout all modules)
global KC_MEH := "!^+"         ; Alt+Ctrl+Shift (Meh key)
global KC_HYPR := "#!^+"       ; Win+Alt+Ctrl+Shift (Hyper key)

; Paths
global geekWisdomNotebook := "Z:\Notebooks\geekwisdom\"
global A_UserProfile := EnvGet("USERPROFILE")

; State tracking
global isTimerActive := false           ; Used by dontSleep.ahk
global HiddenWindows := []              ; Stack of hidden window handles
global explorerKillCounter := 0         ; Used for Explorer restart logic
global explorerKillTimerHandle := 0
```

### Module Categories

**Core modules** (`scripts/core/`):
- System initialization, process monitoring, exit handling

**Function libraries** (`scripts/functions/`):
- Reusable utility functions (window management, GUI helpers, launchers)
- Do not define hotkeys directly

**Hotkey definitions** (`scripts/hotkeys/`):
- `hotkeys.ahk`: Centralized hotkey registry using `Hotkey()` function
- `hotstrings.ahk`: Text replacement/expansion rules
- All hotkeys should be defined here, not scattered across modules

**Feature modules** (`scripts/modules/`):
- Self-contained features with their own logic
- Each provides an autorun function
- Examples: TaskbarClose, dontSleep, forcekill, hiddenWindows, etc.

## Key Modules and Their Behavior

### TaskbarClose (`scripts/modules/TaskbarClose.ahk`)

Enables closing windows via taskbar button clicks:
- `Ctrl+MButton`: Close single window instance
- `Ctrl+Alt+MButton`: Force close all instances of an application

**Complex logic:**
1. Detects if click is on taskbar by checking window class (`Shell_TrayWnd` or `Shell_SecondaryTrayWnd`)
2. Saves pre-click active window state
3. Sends click, waits 100ms
4. Checks post-click window state
5. Determines target window by comparing pre/post states and window minimize status
6. Protects `explorer.exe` from being closed
7. Logs all actions to `TaskbarClose_debug.log` for debugging

### dontSleep (`scripts/modules/dontSleep.ahk`)

Mouse jiggler that prevents screen lock during work hours:
- Active only between 7:45 AM and 6:00 PM
- Moves mouse randomly (-10 to 10 pixels) every 3-5 minutes
- Returns mouse to original position after 50ms
- Automatically enables/disables based on time of day

### hiddenWindows (`scripts/modules/hiddenWindows.ahk`)

Stack-based window hiding system:
- `Hyper+H`: Hide active window (pushed onto `HiddenWindows` array)
- `Hyper+U`: Restore most recently hidden window (pop from stack)
- Excludes certain windows: "Program Manager", "", "Start", "Search"
- All hidden windows are automatically restored on script exit via `ExitFunc()`

### forcekill (`scripts/modules/forcekill.ahk`)

Force terminate applications with special handling:
- **File Explorer windows** (`CabinetWClass`): Closes all Explorer windows gracefully, then force closes remaining
- **Explorer.exe shell**: Kills process, waits 3 seconds, restarts Explorer
- **Other processes**: Force kills all instances via `taskkill /F`

Functions: `forceKill()` (active window), `forceKillUnderMouse()` (window under cursor)

### VRGameFocusManager (`scripts/modules/VRGameFocusManager.ahk`)

Keeps HereSphere VR game focused:
- Timer checks every 500ms if `HereSphere-Win64-Shipping.exe` is running
- If running and not active, automatically activates it
- Prevents VR freezing issues

### comPalGuard (`scripts/modules/comPalGuard.ahk`)

Automatically closes Command Palette when focus is lost:
- Registers shell hook to detect new windows
- When "Command Palette" window is created, starts monitoring at 50ms intervals
- Closes window immediately when focus is lost

### toggleWindowsTitlebar (`scripts/modules/toggleWindowsTitlebar.ahk`)

Toggle window title bars:
- `Alt+F3`: Toggle title bar and border on active window
- Manipulates WS_CAPTION style (0xC00000) using `WinSetStyle`

## Code Patterns and Conventions

### Module Template

Every module should follow this structure:

```ahk
; Brief description of what this module does

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

autorun_modulename(*) {
    ; Initialization code here, or just Return if nothing needed
    Return
}
/* ------------------------------------------------------------------------------------------------------ */

; Module code here
```

### Hotkey Definition Pattern

Hotkeys are defined centrally in `scripts/hotkeys/hotkeys.ahk`:

```ahk
; Preferred: Using Hotkey() function (allows function to be called elsewhere)
Hotkey(KC_HYPR "SPACE",     launchClaude)
Hotkey(KC_HYPR "r",         reloadScript)

; Acceptable for simple single-line hotkeys
!/::                    SendInput("⁄")
```

Functions called by hotkeys are defined in `scripts/functions/simpleFunctions.ahk` or within feature modules.

### Function Naming

- Use descriptive verb-noun names: `forceKill()`, `launchQuickNotes()`, `windowProbe()`
- Keep to 2-3 words maximum
- Functions meant for hotkeys should accept `*` parameter: `functionName(*)`

## Adding New Modules

1. Create file in appropriate directory (`scripts/modules/`, `scripts/functions/`, etc.)
2. Add standalone execution guard block
3. Define `autorun_modulename(*)` function
4. Add `#Include` line in `parasomnia.ahk`
5. Call `autorun_modulename()` in `scripts/core/autorun.ahk`
6. Define hotkeys in `scripts/hotkeys/hotkeys.ahk` (not in the module itself)

## Debugging

**TaskbarClose logging:**
Check `TaskbarClose_debug.log` in the root directory for detailed click event logs.

**Window information:**
- `Hyper+/` (`Win+Alt+Ctrl+Shift+/`): Show info for active window
- `Win+MButton`: Show info for window under mouse cursor

Both display: Title, ahk_exe, ahk_class, ahk_id, ahk_pid

**Reloading:**
Always reload after making changes. Use `Hyper+R` or tray menu → Reload.

## File Paths and Environment

- Script uses absolute paths, not relative
- Working directory is set to `A_ScriptDir` (script root)
- User profile path available via `A_UserProfile` global variable
- Notebook path: `geekWisdomNotebook` global variable
