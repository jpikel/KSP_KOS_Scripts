> Source: https://ksp-kos.github.io/KOS/structures/vessels/vesselsensors.html (mirrored offline copy for local reference)

# VesselSensors

## Overview

The `VesselSensors` structure is obtained by accessing a Vessel's [`SENSORS`](vessel.html) attribute. It provides a snapshot of sensor readings captured at the moment the request is made.

> "These values are only enabled if you have the proper type of sensor on board the vessel."

If stored in a variable, the values remain fixed and will not update as the vessel's state changes.

## Structure Definition

### Members Table

| Suffix | Type | Description |
|--------|------|-------------|
| `ACC` | `Vector` | Acceleration experienced by the Vessel |
| `PRES` | `Scalar` | Atmospheric Pressure outside the Vessel |
| `TEMP` | `Scalar` | Temperature outside the Vessel |
| `GRAV` | `Vector` (g's) | Gravitational acceleration |
| `LIGHT` | `Scalar` | Sun exposure on the vessel's solar panels |

## Attribute Details

### VesselSensors:ACC

**Access:** Get only  
**Type:** `Vector`

The acceleration the vessel is experiencing, combining gravitational pull and engine thrust.

### VesselSensors:PRES

**Access:** Get only  
**Type:** `Scalar`

The current atmospheric pressure around the vessel.

### VesselSensors:TEMP

**Access:** Get only  
**Type:** `Scalar`

The current temperature in the vessel's environment.

### VesselSensors:GRAV

**Access:** Get only  
**Type:** `Vector`

The magnitude and direction of gravitational acceleration at the vessel's location, expressed in G-forces (multiples of 9.802 m/s²).

### VesselSensors:LIGHT

**Access:** Get only  
**Type:** `Scalar`

The total amount of sun exposure available—only readable if solar panels are installed on the vessel.
