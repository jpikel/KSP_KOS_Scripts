> Source: https://ksp-kos.github.io/KOS/commands/flight/pilot.html (mirrored offline copy for local reference)

# Pilot Input — kOS 1.4.0.0 Documentation

## Overview

Pilot Input refers to the suffixes of `ship:control` that represent the player's actual input controls, distinct from kOS's autopilot controls. These suffixes allow scripts to read what the player is attempting to do and, in some cases, to set trim values.

### Key Distinction

As the documentation notes, "these suffixes refer to the player's actual input controls, rather than kOS's own controls that are layered on top of them." Breaking Ground DLC parts respond exclusively to pilot inputs, not autopilot settings.

## Read-Only vs. Settable Controls

Most pilot input controls are **read-only** because KSP automatically resets player inputs to match the actual input device. However, trim controls (which "stay put" rather than resetting to center) are settable, enabling scripts to adjust trim while allowing pilot override.

## Control Reference Table

| Suffix | Get/Set | Type | Keyboard Equivalent |
|--------|---------|------|-------------------|
| PILOTMAINTHROTTLE | Get and Set | scalar [0,1] | LEFT-CTRL, LEFT-SHIFT |
| PILOTYAW | Get-only | scalar [-1,1] | D, A |
| PILOTPITCH | Get-only | scalar [-1,1] | W, S |
| PILOTROLL | Get-only | scalar [-1,1] | Q, E |
| PILOTROTATION | Get-only | Vector | (YAW, PITCH, ROLL) |
| PILOTYAWTRIM | Get and Set | scalar [-1,1] | ALT+D, ALT+A |
| PILOTPITCHTRIM | Get and Set | scalar [-1,1] | ALT+W, ALT+S |
| PILOTROLLTRIM | Get and Set | scalar [-1,1] | ALT+Q, ALT+E |
| PILOTFORE | Get-only | scalar [-1,1] | N, H |
| PILOTSTARBOARD | Get-only | scalar [-1,1] | L, J |
| PILOTTOP | Get-only | scalar [-1,1] | I, K |
| PILOTTRANSLATION | Get-only | Vector | (STARBOARD, TOP, FORE) |
| PILOTWHEELSTEER | Get-only | scalar [-1,1] | A, D |
| PILOTWHEELTHROTTLE | Get and Set | scalar [-1,1] | W, S |
| PILOTWHEELSTEERTRIM | Get and Set | scalar [-1,1] | ALT+A, ALT+D |
| PILOTWHEELTHROTTLETRIM | Get and Set | scalar [-1,1] | ALT+W, ALT+S |
| PILOTNEUTRAL | Get-only | Boolean | Zeroed controls check |

## Individual Control Descriptions

**PILOTMAINTHROTTLE**: Retrieves or sets the pilot's throttle input. When set, an active `lock throttle` will override it, but the value affects the throttle position upon release.

**PILOTYAW**: Returns rotation input about the vertical axis (left: -1, right: +1).

**PILOTPITCH**: Returns rotation input about the starboard axis (up: +1, down: -1).

**PILOTROLL**: Returns rotation input about the longitudinal axis (left-wing-down: -1, left-wing-up: +1).

**PILOTROTATION**: Returns all rotational inputs as a Vector with components (YAW, PITCH, ROLL).

**PILOTYAWTRIM, PILOTPITCHTRIM, PILOTROLLTRIM**: Settable trim values for respective rotation axes, enabling autopilot control while permitting player adjustment.

**PILOTFORE**: Returns forward/backward translation input (+1 forward, -1 backward).

**PILOTSTARBOARD**: Returns right/left translation input (+1 right, -1 left).

**PILOTTOP**: Returns up/down translation input (+1 up, -1 down).

**PILOTTRANSLATION**: Returns all translation inputs as a Vector (STARBOARD, TOP, FORE).

**PILOTWHEELSTEER**: Returns wheel steering input (-1 left, +1 right).

**PILOTWHEELTHROTTLE**: Settable ground throttle input for wheels (+1 forward, -1 backward).

**PILOTWHEELSTEERTRIM, PILOTWHEELTHROTTLETRIM**: Settable trim values for wheel controls.

**PILOTNEUTRAL**: Returns true if pilot controls are inactive and centered, including trim.

## Important Note on Control Neutralization

Scripts must execute `SET SHIP:CONTROL:NEUTRALIZE TO TRUE` upon completion to restore player control, preventing lockout.
