; Standalone launcher script to restart all AutoHotkey processes and reload Parasomnia - can be triggered via hotkey

#Requires AutoHotkey v2.0

#NoTrayIcon

Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
Sleep 1000 
Run("C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe Z:\Code\Parasomnia\parasomnia.ahk")

!^+#Space::{
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkey64.exe`"",, "Hide")
    Run("PowerShell.exe -Command `"taskkill /f /im AutoHotkeyUX.exe`"",, "Hide")
    Sleep 1000
    Run("C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe Z:\Code\Parasomnia\parasomnia.ahk")
}

