> Source: https://ksp-kos.github.io/KOS/commands/prediction.html (mirrored offline copy for local reference)

# Predictions of Flight Path — kOS 1.4.0.0 Documentation

## Overview

This documentation section covers functions for predicting future positions, velocities, and orbital states of vessels and celestial bodies in kOS.

## Important Notes

### Manipulating Maneuver Nodes

The ADD and REMOVE commands on the maneuver node manipulation page allow alterations to the CPU_vessel's flight plan. However, kOS does not automatically execute nodes—you must write code to handle execution.

### Limitations

A KSP limitation restricts maneuver node access to the player vessel only. kOS can maneuver non-player vessels but cannot override this game limitation. When predicting another vessel's position, results may assume pure drifting rather than following planned maneuver nodes.

The functions below account for future maneuver nodes and assume they will be executed as planned.

---

## Functions

### POSITIONAT(orbitable, time)

**Parameters:**
- **orbitable**: A Vessel, Body, or other Orbitable object
- **time**: TimeStamp or Scalar (universal seconds)

**Returns:** A position Vector in the ship-center-raw-rotation frame

Predicts where an Orbitable will be at a given universal time. For vessels with planned maneuver nodes, assumes they execute as planned.

**Reference Frame:** Returns coordinates in the ship's raw reference frame, with origin at the current ship's center of mass.

**Prerequisite:** Career mode requires space center buildings advanced enough to make maneuver nodes, per `Career:CANMAKENODES`.

---

### VELOCITYAT(orbitable, time)

**Parameters:**
- **orbitable**: A Vessel, Body, or other Orbitable object
- **time**: TimeStamp or Scalar (universal seconds)

**Returns:** An OrbitalVelocity structure

Predicts the Orbitable's velocity at a given universal time. For vessels with planned maneuver nodes, assumes execution as planned.

**Reference Frame:** Returns velocity relative to the ship's current orbited body (like `ship:velocity`). If the ship will transfer to another body's SOI, the returned velocity is still relative to the current body.

**Example illustrating reference frame behavior:**

```kos
// Later_time is 1 minute into the Mun orbit patch:
local later_time is time:seconds + ship:obt:NEXTPATCHETA + 60.
local later_ship_vel is VELOCITYAT(ship, later_time):ORBIT.
local later_body_vel is VELOCITYAT(ship:obt:NEXTPATCH:body, later_time):ORBIT.

local later_ship_vel_rel_to_later_body is later_ship_vel - later_body_vel.

print "My later velocity relative to this body is: " + later_ship_vel.
print "My later velocity relative to the body I will be around then is: " +
  later_ship_vel_rel_to_later_body.
```

**Prerequisite:** Career mode requires space center buildings advanced enough to make maneuver nodes.

---

### ORBITAT(orbitable, time)

**Parameters:**
- **orbitable**: A Vessel, Body, or other Orbitable object
- **time**: TimeStamp or Scalar (universal seconds)

**Returns:** An Orbit structure

Returns the Orbit patch where an Orbitable is predicted to be at a given universal time. For vessels with planned maneuver nodes, assumes execution as planned.

**Prerequisite:** Career mode requires space center buildings advanced enough to make maneuver nodes.

---

## Example

```kos
// Test future position and velocity prediction.
// Draws a position and velocity vector at a future predicted time.

declare parameter item.        // thing to predict for, i.e. SHIP.
declare parameter offset.      // how much time into the future to predict.
declare parameter velScale.    // how big to draw the velocity vectors.
                               // If they're far from the camera draw them bigger.

set predictUT to time + offset.
set stopProg to false.

set futurePos to positionat( item, predictUT ).
set futureVel to velocityat( item, predictUT ).

set drawPos to vecdrawargs( v(0,0,0), futurePos, green, "future position", 1, true ).
set drawVel to vecdrawargs( futurePos, velScale*futureVel:orbit, yellow, "future velocity", 1, true ).
```
