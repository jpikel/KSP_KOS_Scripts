> Source: https://ksp-kos.github.io/KOS/commands/flight/cooked.html (mirrored offline copy for local reference)

# Cooked Control — kOS 1.4.0.0 Documentation

## Overview

Cooked control allows you to specify a desired direction and let kOS calculate the steering adjustments needed to reach that goal, rather than directly controlling individual axes. Multiple processor parts can control cooked steering simultaneously, with the last update taking priority.

## CONFIG:SUPPRESSAUTOPILOT

When `Config:SUPPRESSAUTOPILOT` is true, cooked control commands have no effect. This provides an emergency manual override via the toolbar.

## Special LOCK Variables for Cooked Steering

### LOCK THROTTLE TO expression

Sets main throttle using a floating-point value between 0.0 (idle) and 1.0 (maximum).

```
LOCK THROTTLE TO expression.  // value range [0.0 .. 1.0]
```

The expression can include formulas and function calls, but must return a value in the valid range.

**Warnings:**
- Do not use `SAS` and `lock steering` simultaneously
- Avoid `WAIT` commands within throttle expressions
- Breaking Ground DLC parts won't respond to `lock throttle`; use `ship:control:pilotmainthrottle` instead

### LOCK STEERING TO expression

Sets the direction kOS should point the ship. The expression must be a Vector or Direction:

**Rotation Syntax:**
```
LOCK STEERING TO Up + R(20,0,0).        // 20° off from up
LOCK STEERING TO North + R(0,90,0).     // Due east at horizon
```

**Heading Syntax:**
```
LOCK STEERING TO HEADING(compass, pitch).
LOCK STEERING TO HEADING(180, 30).      // South, 30° above horizon
```

**Vector Syntax:**
```
LOCK STEERING TO V(100,50,10).
LOCK STEERING TO (-1) * SHIP:VELOCITY:SURFACE.  // Opposite of velocity
LOCK STEERING TO VCRS(SHIP:VELOCITY:ORBIT, BODY:POSITION).  // Normal to orbit
```

**Special String:**
```
LOCK STEERING TO "kill".  // Stop all vessel rotation
```

Unlike standard LOCK expressions, steering and throttle are continuously evaluated in the background multiple times per physics update.

**Warning:** SAS support with `lock steering` is currently broken in newer KSP versions. See GitHub issue #2117 for updates.

### LOCK WHEELTHROTTLE TO expression

Controls rover wheel throttle independently from flight throttle. Value range is -1.0 to 1.0, where positive values are forward and negative values reverse.

```
LOCK WHEELTHROTTLE TO expression.  // value range [-1.0 .. 1.0]
```

Unlike manual driving, `WHEELTHROTTLE` does not engage torque wheels automatically.

**Warning:** Avoid `WAIT` commands in the expression.

### LOCK WHEELSTEERING TO expression

Directs rover steering. Accepts three input types:

**GeoCoordinates:**
```
LOCK WHEELSTEERING TO GeoCoordinates.  // Aims at location
```

**Vessel:**
```
LOCK WHEELSTEERING TO other_vessel.  // Aims at vessel (or point below if airborne)
```

**Scalar Number (Compass Heading):**
```
LOCK WHEELSTEERING TO 45.  // Drive northeast
```

**Vertically-Mounted Probe Core Warning:**
If the probe core faces upward when the rover drives, cooked wheelsteering may malfunction on slopes. Either mount the probe core forward-facing or use "control from here" on a forward-facing part.

**Warning:** Avoid `WAIT` commands in the expression.

## Don't 'WAIT' or Run Slow Script Code During Cooked Control Calculation

LOCK THROTTLE, LOCK STEERING, LOCK WHEELTHROTTLE, and LOCK WHEELSTEERING execute at every physics update tick as the highest-priority triggers. Including `WAIT` commands within these expressions severely starves the script of CPU time.

**Example of what to avoid:**
```
function get_throttle {
    wait 0.001.  // BAD IDEA
    return 0.5.
}
lock throttle to get_throttle().
```

These locks execute repeatedly in the background (unlike standard locks evaluated only on access). Do not call complex functions; doing so may leave insufficient instructions-per-update for the rest of your program.

## Unlocking Controls

Free manual control by issuing:

```
UNLOCK STEERING.
UNLOCK THROTTLE.
```

When a program ends, locks automatically release. Programs must continue running to maintain control.

## Tuning Cooked Steering

Adjustments come from the `SteeringManager` structure. Common solutions follow:

### Simple Solutions for Common Problems

**Problem: Wiggling controls during rotation wastes RCS fuel**
- Solution: Increase `STEERINGMANAGER:TORQUEPSILONMAX`

**Problem: Very slow vessel appears not to rotate at all**
- Solution: Decrease `STEERINGMANAGER:TORQUEEPSILONMAX` or increase `STEERINGMANAGER:MAXSTOPPINGTIME`

**Problem: Large, low-torque vessel rotates very slowly**
- Solution: Increase `STEERINGMANAGER:MAXSTOPPINGTIME` to 5-10 seconds; increase `STEERINGMANAGER:PITCHPID:KD` and `STEERINGMANAGER:YAWPID:KD` to 1-2

**Problem: Ship vibrates ±1° around setpoint**
- Solution 1: Increase `STEERINGMANAGER:PITCHTS` and `STEERINGMANAGER:YAWTS` to several seconds
- Solution 2: Increase `STEERINGMANAGER:TORQUEEPSILONMIN` if precision isn't critical

**Problem: Physics warp causes steering drift during burns**
- Solution: Enable KSP's "Advanced Tweakables" and autostrut parts to root (KSP issue, not kOS)

**Problem: Nose waves slowly across setpoint with extreme control deflection**
- Solution: Increase `STEERINGMANAGER:PITCHPID:KD` and `STEERINGMANAGER:YAWPID:KD`

**Problem: Nose waves slowly across setpoint with minimal control deflection**
- Solution: Decrease `STEERINGMANAGER:PITCHTS` and/or `STEERINGMANAGER:YAWTS`

### PID Controller Overview

A PID controller is a mathematical system that learns where to set a control lever to achieve a desired measurement. Example: cruise control learns pedal position to maintain target speed.

### Cooked Steering's Nested PID Architecture

kOS uses two nested PID controllers per rotation axis (6 total):

1. **Rotational Velocity PID:** Compares target direction to current direction, outputs desired rotational velocity
2. **Torque PID:** Takes desired rotational velocity, outputs control settings (pitch/yaw/roll)

The system corrects pitch and yaw first, then roll only when close to target. This prevents curved arcs and works well for radially-symmetric rockets but may not suit atmospheric aircraft.

### Adjustable Settings

**Rotational Velocity PID tuning:**
```
SET STEERINGMANAGER:MAXSTOPPINGTIME TO 10.
SET STEERINGMANAGER:PITCHPID:KP TO 0.85.
SET STEERINGMANAGER:PITCHPID:KI TO 0.5.
SET STEERINGMANAGER:PITCHPID:KD TO 0.1.
```

Higher `MAXSTOPPINGTIME` increases turning speed but may increase overshoot.

**Torque PID tuning (settling time):**
```
SET STEERINGMANAGER:PITCHTS TO 10.
SET STEERINGMANAGER:ROLLTS TO 5.
```

Increasing settling time reduces control spikes and is useful for vessels that wobble.

**Torque adjustment:**
Use `PITCHTORQUEADJUST`, `YAWTORQUEADJUST`, `ROLLTORQUEADJUST`, `PITCHTORQUEFACTOR`, `YAWTORQUEFACTOR`, `ROLLTORQUEFACTOR` if available torque is miscalculated.

## Advantages/Disadvantages

**Advantages:**
- Simpler script writing compared to raw control
- Automatic course correction

**Disadvantages:**
- Limited control over motion details
- Requires tuning for different vessel designs

Cooked control performs best on radially-symmetric ships with medium torque and structural stability. Optimal results require:
- Root part or control part near center of mass
- Struts on critical joints or mods like Kerbal Joint Reinforcement

For difficult vessels, either adjust SteeringManager parameters or implement custom control via raw steering.
