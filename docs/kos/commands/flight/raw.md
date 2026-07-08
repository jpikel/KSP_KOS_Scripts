> Source: https://ksp-kos.github.io/KOS/commands/flight/raw.html (mirrored offline copy for local reference)

# Raw Control - kOS 1.4.0.0 Documentation

## Overview

Raw control allows direct manipulation of vessel flight controls through kOS scripts, offering an alternative to the `LOCK STEERING` and `LOCK THROTTLE` commands. Access the control structure via:

```
SET controlStick to SHIP:CONTROL.
SET controlStick:PITCH to 0.2.
```

Unlike cooked steering, raw steering uses `SET` commands, not `LOCK`. Control values range from -1 to +1, with 0 representing neutral position.

## CONFIG:SUPPRESSAUTOPILOT

When `Config:SUPPRESSAUTOPILOT` is true, none of the raw controls function, providing players with an emergency override to regain manual control.

## Breaking Ground DLC

The _Breaking Ground DLC_ parts respond only to pilot controls (see the pilot controls page), not to raw control settings, `lock throttle`, or `lock steering`.

## 5% Null Zone Warning

KSP imposes a built-in 5% null zone on RCS thrusters that prevents small raw inputs from functioning. The kOS workaround uses the `RCS:DEADZONE` suffix of RCS parts.

## Raw Flight Controls Reference

| Suffix | Type, Range | Equivalent Key |
|--------|-------------|----------------|
| MAINTHROTTLE | scalar [0,1] | `LEFT-CTRL`, `LEFT-SHIFT` |
| YAW | scalar [-1,1] | `D`, `A` |
| PITCH | scalar [-1,1] | `W`, `S` |
| ROLL | scalar [-1,1] | `Q`, `E` |
| ROTATION | Vector | `(YAW,PITCH,ROLL)` |
| YAWTRIM | scalar [-1,1] | `ALT+D`, `ALT+A` |
| PITCHTRIM | scalar [-1,1] | `ALT+W`, `ALT+S` |
| ROLLTRIM | scalar [-1,1] | `ALT+Q`, `ALT+E` |
| FORE | scalar [-1,1] | `N`, `H` |
| STARBOARD | scalar [-1,1] | `L`, `J` |
| TOP | scalar [-1,1] | `I`, `K` |
| TRANSLATION | Vector | `(STARBOARD,TOP,FORE)` |
| WHEELSTEER | scalar [-1,1] | `A`, `D` |
| WHEELTHROTTLE | scalar [-1,1] | `W`, `S` |
| WHEELSTEERTRIM | scalar [-1,1] | `ALT+A`, `ALT+D` |
| WHEELTHROTTLETRIM | scalar [-1,1] | `ALT+W`, `ALT+S` |
| NEUTRAL | Boolean | True if ship:control is at rest |
| NEUTRALIZE | Boolean | Releases all controls |

## Control Details

### SHIP:CONTROL:MAINTHROTTLE
Ranges from 0 to 1, similar to cooked flying `LOCK THROTTLE`.

### SHIP:CONTROL:YAW
Rotation about the "up" vector: left (-1) or right (+1).

### SHIP:CONTROL:PITCH
Rotation about the starboard vector: up (+1) or down (-1).

### SHIP:CONTROL:ROLL
Rotation about the longitudinal axis: left-wing-down (-1) or left-wing-up (+1).

### SHIP:CONTROL:ROTATION
A Vector object containing `(YAW, PITCH, ROLL)` in that order.

### SHIP:CONTROL:YAWTRIM, PITCHTRIM, ROLLTRIM
These have no real effect and exist for completeness only. For actual trim control, use `SHIP:CONTROL:PILOTYAWTRIM`, `PILOTYAWTRIM`, or `PILOTROLLTRIM` from the pilot control section instead.

**Warning:** Setting trim values can cause `NEUTRAL` to return false negatives by confusing the system about the "at rest" point.

### SHIP:CONTROL:FORE
Controls forward (+1) or backward (-1) translation. Subject to the 5% null zone.

### SHIP:CONTROL:STARBOARD
Controls right (+1) or left (-1) translation. Subject to the 5% null zone.

### SHIP:CONTROL:TOP
Controls up (+1) or down (-1) translation. Subject to the 5% null zone.

### SHIP:CONTROL:TRANSLATION
Controls translation as a Vector: `(STARBOARD, TOP, FORE)`. Each axis has a 5% null zone.

### SHIP:CONTROL:WHEELSTEER
Steers wheels left (-1) or right (+1).

### SHIP:CONTROL:WHEELTHROTTLE
Controls wheels forward (+1) or backward (-1) on the ground.

### SHIP:CONTROL:WHEELSTEERTRIM, WHEELTHROTTLETRIM
These have no real effect and exist for completeness. Use pilot control equivalents instead.

**Warning:** Setting these can cause `NEUTRAL` to return false negatives.

### SHIP:CONTROL:NEUTRAL and NEUTRALIZE

These are synonymous suffixes whose meaning depends on context:

**Getting:**
```
if (SHIP:CONTROL:NEUTRAL)
```
Returns true when raw controls are at rest.

**Setting:**
```
set SHIP:CONTROL:NEUTRALIZE TO TRUE.
```
Releases all raw controls. Setting to false has no effect.

**Warning:** Setting raw control trim values can cause `NEUTRAL` to return false even when controls are at rest.

## Unlocking Controls

Setting any `SHIP:CONTROL` value locks that specific control from player input. Other controls remain unlocked. To free a single control, set it back to zero. To release all controls:

```
SET SHIP:CONTROL:NEUTRALIZE to TRUE.
```

## Example Code

```
print "Gently pushing forward for 3 seconds.".
SET SHIP:CONTROL:FORE TO 0.2.
SET now to time:seconds.
WAIT until time:seconds > now + 3.
SET SHIP:CONTROL:FORE to 0.0.

print "Gently Pushing leftward for 3 seconds.".
SET SHIP:CONTROL:STARBOARD TO -0.2.
SET now to time:seconds.
WAIT until time:seconds > now + 3.
SET SHIP:CONTROL:STARBOARD to 0.0.

print "Starting an upward rotation.".
SET SHIP:CONTROL:PITCH TO 0.2.
SET now to time:seconds.
WAIT until time:seconds > now + 0.5.
SET SHIP:CONTROL:PITCH to 0.0.

print "Giving control back to the player now.".
SET SHIP:CONTROL:NEUTRALIZE to True.
```

## Advantages and Disadvantages

Raw control is necessary for RCS translation. It also allows finer control gentleness and can manage wobbly craft better than cooked control methods.
