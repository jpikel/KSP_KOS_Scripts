> Source: https://ksp-kos.github.io/KOS/commands/terminalgui.html (mirrored offline copy for local reference)

# Terminal and Game Environment Documentation

## Overview
This kOS documentation section covers terminal control, screen display, and GUI tools for scripting in Kerbal Space Program.

## Core Terminal Commands

**CLEARSCREEN**
Clears the display and positions the cursor at the top-left corner.

**PRINT**
Outputs text or expression results to the screen. Supports string concatenation and arithmetic expressions.

**Terminal Dimensions**
- `SET TERMINAL:WIDTH` / `GET TERMINAL:WIDTH` — Configure or retrieve terminal width in characters
- `SET TERMINAL:HEIGHT` / `GET TERMINAL:HEIGHT` — Configure or retrieve terminal height in characters

**AT(col, line)**
Positions printed text at specific screen coordinates (column and line numbers start from zero).

## View Control

**MAPVIEW**
Boolean variable that toggles between map view and flight view. Reading it returns current state; setting it switches modes.

## System Control

**REBOOT**
Halts script execution and restarts the kOS module.

**SHUTDOWN**
Halts script execution and powers down the kOS module.

## GUI Display Tools

**VECDRAW / VECDRAWARGS**
Renders visual vectors on-screen for debugging or player information. Complex vectors may only render in map view.

**HUDTEXT**
Displays messages in heads-up display format with customizable position, duration, style, size, and color. Parameters include message text, display duration, screen position (upper-left, upper-center, upper-right, or lower-center), font size, color values, and optional terminal echo.
