> Source: https://ksp-kos.github.io/KOS/tutorials/designpatterns.html (mirrored offline copy for local reference)

# Design Patterns and Considerations with kOS

## Overview

This tutorial helps novice kOS programmers develop elegant and capable control programs after completing the Quick Start Tutorial. The examples can be tested using a rocket equipped with an accelerometer, negative gravioli detector, and kOS module.

## The Major Design Patterns of kOS Control Programs

Program design is determined by flow-control statements (WHEN/THEN, ON, WAIT, UNTIL, IF, FOR). Three major styles exist:

1. **Sequential**
2. **Loops with Condition Checking**
3. **Loops with Triggers**

### 1. Sequential Programs

These rely on WAIT UNTIL statements to progress through phases:

```
LOCK STEERING TO HEADING(0,90).
LOCK THROTTLE TO 1.
STAGE.
WAIT UNTIL SHIP:ALTITUDE > 10000.
LOCK STEERING TO HEADING(0,90) + R(0,-45,0).
WAIT UNTIL STAGE:LIQUIDFUEL < 0.1.
STAGE.
WAIT UNTIL SHIP:ALTITUDE > 20000.
LOCK THROTTLE TO 0.
WAIT UNTIL FALSE.
```

This approach works for specific rockets but lacks generality. Adapting code for different rockets becomes complicated quickly.

### 2. Loops with Condition Checking

Introduce IF/ELSE logic into UNTIL loops:

```
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
LOCK THROTTLE TO 1.
STAGE.
UNTIL SHIP:ALTITUDE > 20000 {
    IF SHIP:ALTITUDE > 10000 {
        LOCK STEERING TO R(0,0,-90) + HEADING(90,45).
    }
    IF STAGE:LIQUIDFUEL < 0.1 {
        STAGE.
    }
}
LOCK THROTTLE TO 0.
WAIT UNTIL FALSE.
```

This checks staging conditions continuously and stages multiple times as needed. Complex programs benefit from WAIT statements to reduce loop frequency (0.001 to 60 seconds or longer for interplanetary transfers).

### 3. Loops with Triggers

Use WHEN/THEN to execute code once when conditions are met:

```
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
LOCK THROTTLE TO 1.
STAGE.
WHEN SHIP:ALTITUDE > 10000 THEN {
    LOCK STEERING TO R(0,0,-90) + HEADING(90,45).
}
UNTIL SHIP:ALTITUDE > 20000 {
    IF STAGE:LIQUIDFUEL < 0.1 {
        STAGE.
    }
}
LOCK THROTTLE TO 0.
WAIT UNTIL FALSE.
```

Use PRESERVE to keep triggers active:

```
WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
LOCK THROTTLE TO 1.
STAGE.
WHEN SHIP:ALTITUDE > 10000 THEN {
    LOCK STEERING TO R(0,0,-90) + HEADING(90,45).
}
WAIT UNTIL SHIP:ALTITUDE > 20000.
LOCK THROTTLE TO 0.
WAIT UNTIL FALSE.
```

### Bringing It All Together

Real scripts combine sequential parts, long-term and short-term triggers, and complex loops of varying frequency.

## General Guidelines for kOS Scripts

### 1. Minimize Time Spent in WHEN/THEN Blocks

WAIT statements are ignored inside WHEN/THEN blocks. Keep blocks to quick code snippets. This problematic example attempts adjusting throttle based on g-force:

```
SET thrott TO 1.
LOCK THROTTLE TO thrott.
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
STAGE.
WHEN SHIP:ALTITUDE > 1000 THEN {
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
    LOCK gforce TO accvec:MAG / g.
    LOCK dthrott TO 0.05 * (1.2 - gforce).

    UNTIL SHIP:ALTITUDE > 40000 {
        WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
            STAGE.
            PRESERVE.
        }
        SET thrott to thrott + dthrott.
        WAIT 0.1.
    }
}
```

This fails because WHEN/THEN blocks must complete within a single physics tick, but the UNTIL loop should span multiple ticks. The corrected version separates triggers from loops:

```
WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}
SET thrott TO 1.
SET dthrott TO 0.
LOCK THROTTLE TO thrott.
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
STAGE.
WHEN SHIP:ALTITUDE > 1000 THEN {
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
    LOCK gforce TO accvec:MAG / g.
    LOCK dthrott TO 0.05 * (1.2 - gforce).
}
UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott to thrott + dthrott.
    WAIT 0.1.
}
```

**Key principle**: Never put an UNTIL loop inside a WHEN/THEN block, and rarely nest WHEN/THEN statements inside UNTIL loops.

This example implements a "proportional feedback loop" maintaining 1.2 g-force from 1km to 40km altitude by adjusting throttle. The "setpoint" is 1.2, the "process variable" is measured g-force, and 0.05 is the "proportional gain." See the PID Loop Tutorial for full development.

### 2. Minimize Trigger Conditions

Multiple WHEN/THEN triggers depending on the same complex LOCK variable can exceed kOS's trigger-checking operation limit. This example changes g-force setpoint at different altitudes:

```
WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}
SET thrott TO 1.
SET dthrott TO 0.
LOCK THROTTLE TO thrott.
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
STAGE.
WHEN SHIP:ALTITUDE > 1000 THEN {
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
    LOCK gforce TO accvec:MAG / g.
    LOCK dthrott TO 0.05 * (1.2 - gforce).
}
WHEN SHIP:ALTITUDE > 10000 THEN {
    LOCK dthrott TO 0.05 * (2.0 - gforce).
}
WHEN SHIP:ALTITUDE > 20000 THEN {
    LOCK dthrott TO 0.05 * (4.0 - gforce).
}
WHEN SHIP:ALTITUDE > 30000 THEN {
    LOCK dthrott TO 0.05 * (5.0 - gforce).
}
UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott to thrott + dthrott.
    WAIT 0.1.
}
```

Optimize by nesting sequential triggers:

```
WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
    STAGE.
    PRESERVE.
}
SET thrott TO 1.
SET dthrott TO 0.
LOCK THROTTLE TO thrott.
LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
STAGE.
WHEN SHIP:ALTITUDE > 1000 THEN {
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
    LOCK gforce TO accvec:MAG / g.
    LOCK dthrott TO 0.05 * (1.2 - gforce).

    WHEN SHIP:ALTITUDE > 10000 THEN {
        LOCK dthrott TO 0.05 * (2.0 - gforce).

        WHEN SHIP:ALTITUDE > 20000 THEN {
            LOCK dthrott TO 0.05 * (4.0 - gforce).

            WHEN SHIP:ALTITUDE > 30000 THEN {
                LOCK dthrott TO 0.05 * (5.0 - gforce).
            }
        }
    }
}
UNTIL SHIP:ALTITUDE > 40000 {
    SET thrott to thrott + dthrott.
    WAIT 0.1.
}
```

Nesting reduces trigger checks to two per update for the script's entire duration. Each trigger sets up the next sequential trigger, saving significant processing time for sequential conditions.
