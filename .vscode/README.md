# OmniScript - AutoHotkey v2.0 Utility Suite

A comprehensive AutoHotkey v2.0 script collection for Windows automation, hotkeys, and quality-of-life improvements.

## Features

### Key Combinations
- **KC_MEH**: `Alt+Ctrl+Shift` - Meh key modifier
- **KC_HYPR**: `Win+Alt+Ctrl+Shift` - Hyper key modifier

### Critical Functions
- **watchDog.ahk**: Monitors the main script and restarts it if it crashes
- **exitHandler.ahk**: Ensures all hidden windows are restored when the script exits

### Quality of Life
- **dontSleep.ahk**: Mouse jiggler that keeps your system active during work hours (7:45 AM - 6:00 PM)
- **forcekill.ahk**: Force terminate applications with `Hyper+F4` hotkey
- **killTaskbarMouse3.ahk**: Middle-click taskbar buttons to close windows

### Standard Functions
- **hotkeys.ahk**: Custom hotkey definitions
- **hotstrings.ahk**: Text replacement and expansion

## Installation

1. Install [AutoHotkey v2.0](https://www.autohotkey.com/v2/) or later
2. Clone or download this repository
3. Run `omni.ahk` (requires administrator privileges)

## Usage

The script automatically:
- Runs with administrator privileges (will prompt if needed)
- Disables CapsLock, enables NumLock
- Loads all component scripts
- Starts the watchdog monitor
- Creates a system tray icon with quick actions

### System Tray Menu
- **Open Scripts Folder**: Browse the scripts directory
- **Reload**: Restart the script
- **Exit**: Terminate all AutoHotkey instances

## Script Structure

```
omni/
├── omni.ahk                    # Main entry point
├── scripts/
│   ├── criticalFunctions/      # Essential monitoring scripts
│   │   ├── watchDog.ahk
│   │   └── exitHandler.ahk
│   ├── qualityOfLife/          # User convenience features
│   │   ├── dontSleep.ahk
│   │   ├── forcekill.ahk
│   │   └── killTaskbarMouse3.ahk
│   └── standardFunctions/      # Hotkeys and hotstrings
│       ├── hotkeys.ahk
│       └── hotstrings.ahk
└── README.md
```

## Configuration

Edit individual script files in the `scripts/` folder to customize:
- Work hours for the mouse jiggler (in `dontSleep.ahk`)
- Custom hotkeys (in `hotkeys.ahk`)
- Text replacements (in `hotstrings.ahk`)

## Key Bindings Reference

### AutoHotkey Modifier Symbols
- `#` - Windows key
- `!` - Alt key
- `^` - Ctrl key
- `+` - Shift key

### Current Hotkeys
- `Hyper+F4` - Force kill application under cursor
- `Middle Click` (on taskbar) - Close window

## Requirements

- Windows 10/11
- AutoHotkey v2.0 or later
- Administrator privileges (for some features)

## License

MIT License - Feel free to modify and distribute as needed.
