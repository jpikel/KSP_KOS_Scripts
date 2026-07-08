> Source: https://ksp-kos.github.io/KOS/general/settingsWindows.html (mirrored offline copy for local reference)

# kOS Settings Windows Documentation

## Overview

This documentation page describes two main configuration interfaces for kOS version 1.4.0.0:

1. **kOS Control Panel** - A launcher-based display panel
2. **KSP Difficulty Settings Window** - In-game configuration menu

## kOS Control Panel

The control panel functions similarly to other KSP launcher display panels, operating on a mutual exclusivity basis. Opening one panel automatically closes others.

### Key Features (from annotated image):

- Lists all currently loaded vessels with associated kOS processors
- Displays kOS version number
- Shows processor part names and name tags
- Indicates power status (non-interactive display)
- Provides terminal window toggle button
- Includes toolbar button for panel visibility control
- Telnet activation toggle
- Telnet port configuration display
- Loopback address enforcement toggle
- Processor highlighting on cursor hover

**Important Note:** Unloaded processors beyond physics range don't appear, as they cannot execute.

## KSP Difficulty Settings Window

Introduced in version 1.0.2, this window moved settings from the App Launcher to KSP's save-file-based system. Access it via:
- New game: "Difficulty Options" button
- Existing game: Escape menu → Settings → "Difficulty Options"

### Configurable Settings:

1. CPU execution speed (instructions per physics tick)
2. Local volume compression and base64 encoding
3. Program profiling output display
4. Default volume initialization behavior
5. Terminal hide UI synchronization
6. Infinity/NaN error detection
7. Audio error notification
8. Extended error message descriptions
9. Blizzy Toolbar exclusivity option
10. Opcode execution debug logging
11. Connectivity manager selection
12. Terminal brightness slider

All settings are save-game specific and can be modified mid-game without penalty.
