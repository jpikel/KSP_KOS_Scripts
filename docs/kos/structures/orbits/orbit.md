> Source: https://ksp-kos.github.io/KOS/structures/orbits/orbit.html (mirrored offline copy for local reference)

# Orbit — kOS 1.4.0.0 Documentation

## Overview

The `Orbit` structure holds descriptive information about an elliptical orbit's shape. When multiple orbit patches occur (such as during encounters or maneuver nodes), each patch is represented by a separate `Orbit` object.

Any `Orbitable` item—such as a `Vessel` or celestial `Body`—has an `:ORBIT` suffix providing access to its current `Orbit`. Note that a vessel's orbit patch doesn't account for planetary encounters or maneuver nodes that may alter the trajectory.

## Creation

### CREATEORBIT() with Keplerian Parameters

```
CREATEORBIT(inc, e, sma, lan, argPe, mEp, t, body)
```

**Parameters:**
- `inc` – inclination (degrees)
- `e` – eccentricity
- `sma` – semi-major axis (meters)
- `lan` – longitude of ascending node (degrees)
- `argPe` – argument of periapsis (degrees)
- `mEp` – mean anomaly at epoch (degrees)
- `t` – epoch (universal timestamp)
- `body` – celestial body to orbit

**Returns:** `Orbit`

**Example:**
```
SET myOrbit TO CREATEORBIT(0, 0, 270000, 0, 0, 0, 0, Mun).
```

### CREATEORBIT() with Position and Velocity

```
CREATEORBIT(pos, vel, body, ut)
```

**Parameters:**
- `pos` – position relative to body center (Vector)
- `vel` – velocity (Vector)
- `body` – celestial body to orbit
- `ut` – universal time (seconds)

**Returns:** `Orbit`

**Example:**
```
SET myOrbit TO CREATEORBIT(V(2295.5, 0, 0), V(0, 0, 70000 + Kerbin:RADIUS), Kerbin, 0).
```

## Structure Members

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Name of this orbit |
| `APOAPSIS` | Scalar (m) | Maximum altitude |
| `PERIAPSIS` | Scalar (m) | Minimum altitude |
| `BODY` | Body | Focal celestial body |
| `PERIOD` | Scalar (s) | Orbital period |
| `INCLINATION` | Scalar (deg) | Orbital inclination |
| `ECCENTRICITY` | Scalar | Orbital eccentricity |
| `SEMIMAJORAXIS` | Scalar (m) | Semi-major axis |
| `SEMIMINORAXIS` | Scalar (m) | Semi-minor axis |
| `LAN` | Scalar (deg) | Longitude of ascending node |
| `LONGITUDEOFASCENDINGNODE` | Scalar (deg) | Same as `LAN` |
| `ARGUMENTOFPERIAPSIS` | Scalar (deg) | Argument of periapsis |
| `TRUEANOMALY` | Scalar (deg) | True anomaly |
| `MEANANOMALYATEPOCH` | Scalar (deg) | Mean anomaly at epoch |
| `EPOCH` | Scalar | Universal timestamp for `MEANANOMALYATEPOCH` |
| `TRANSITION` | String | Transition type from this orbit |
| `POSITION` | Vector | Current position |
| `VELOCITY` | OrbitableVelocity | Current velocity structure |
| `NEXTPATCH` | Orbit | Next orbit patch (requires building upgrade) |
| `NEXTPATCHETA` | Scalar | ETA to next patch (requires building upgrade) |
| `ETA` | OrbitEta | ETA object for Pe, Ap, and transition |
| `HASNEXTPATCH` | Boolean | Whether a next patch exists (requires building upgrade) |

## Detailed Attributes

### Orbit:NAME
**Type:** String  
**Access:** Get only

A name for this orbit.

### Orbit:APOAPSIS
**Type:** Scalar (m)  
**Access:** Get only

The maximum altitude expected to be reached.

### Orbit:PERIAPSIS
**Type:** Scalar (m)  
**Access:** Get only

The minimum altitude expected to be reached.

### Orbit:BODY
**Type:** Body  
**Access:** Get only

The celestial body this orbit is orbiting.

### Orbit:PERIOD
**Type:** Scalar (seconds)  
**Access:** Get only

The orbital period.

### Orbit:INCLINATION
**Type:** Scalar (degree)  
**Access:** Get only

The orbital inclination.

### Orbit:ECCENTRICITY
**Type:** Scalar  
**Access:** Get only

The orbital eccentricity.

### Orbit:SEMIMAJORAXIS
**Type:** Scalar (m)  
**Access:** Get only

The semi-major axis.

### Orbit:SEMIMINORAXIS
**Type:** Scalar (m)  
**Access:** Get only

The semi-minor axis.

### Orbit:LAN
Same as `Orbit:LONGITUDEOFASCENDINGNODE`.

### Orbit:LONGITUDEOFASCENDINGNODE
**Type:** Scalar (deg)  
**Access:** Get only

The longitude of the ascending node—the celestial longitude where the orbit crosses the body's equator from southern to northern hemisphere. This is expressed as an angle from the Solar Prime Vector, not the body's longitude. Account for `body:rotationangle` and the body's rotation by the time you arrive to determine relative position.

### Orbit:ARGUMENTOFPERIAPSIS
**Type:** Scalar  
**Access:** Get only

The argument of periapsis.

### Orbit:TRUEANOMALY
**Type:** Scalar  
**Access:** Get only

The true anomaly in degrees. For closed orbits (eccentricity < 1.0), the range is [0..360), where values > 180 represent descent from apoapsis to periapsis. For open orbits (eccentricity ≥ 1.0), the range is (-180..180), with negative values representing descent to periapsis.

### Orbit:MEANANOMALYATEPOCH
**Type:** Scalar (degrees)  
**Access:** Get only

The mean anomaly in degrees at the fixed time called `EPOCH`. KSP tracks orbit position using this value and the epoch timestamp internally. For closed orbits, the range is [0..360). For open orbits, values are unlimited, with negative values representing descent to periapsis.

### Orbit:EPOCH
**Type:** Scalar (universal timestamp in seconds)  
**Access:** Get only

The arbitrary timestamp at which the mean anomaly equals `MEANANOMALYATEPOCH`. Unlike traditional epoch systems, this value changes (particularly when entering/exiting time warp) and must be rechecked.

### Orbit:TRANSITION
**Type:** String  
**Access:** Get only

Describes how this orbit will end and transition to a different orbit (see transition list below).

### Orbit:POSITION
**Type:** Vector  
**Access:** Get only

The current position of the object in this orbit.

### Orbit:VELOCITY
**Type:** OrbitableVelocity  
**Access:** Get only

The current velocity structure containing both orbital and surface velocity vectors.

### Orbit:NEXTPATCH
**Type:** Orbit  
**Access:** Get only

*Requires building upgrade in career mode*

Returns the next orbit patch when a transition occurs. Allows chaining (e.g., `:NEXTPATCH:NEXTPATCH`) to peek multiple patches ahead, limited by your conic patches setting.

### Orbit:NEXTPATCHETA
**Type:** Scalar  
**Access:** Get only

*Requires building upgrade in career mode*

The ETA to the next orbit patch transition, potentially spanning multiple patch transitions (unlike `ETA:TRANSITION`).

### Orbit:ETA
**Type:** OrbitEta  
**Access:** Get only

Returns an `OrbitEta` object providing seconds to periapsis, apoapsis, and transition to the next orbit.

### Orbit:HASNEXTPATCH
**Type:** Boolean  
**Access:** Get only

*Requires building upgrade in career mode*

Returns true if `:NEXTPATCH` will provide a valid patch; false if no future transitions occur. Note that both `NEXTPATCH` and `HASNEXTPATCH` only consider current momentum, not maneuver nodes. To check the orbit following a maneuver node, access the node's `:ORBIT` suffix first.

## Deprecated Suffix

### Orbit:PATCHES
**Type:** List of Orbit Objects  
**Access:** Get only

**Deprecated since version 0.15**

Use `Vessel:PATCHES` instead.

## Transition Names

**INITIAL**  
Refers to the start of a new orbit—a value never returned by `Orbit:TRANSITION` (which only describes patch endings).

**FINAL**  
No transition to a new orbit is expected; this orbit remains forever.

**ENCOUNTER**  
This orbit will enter the SOI of a smaller body nested within the current one (e.g., Sun orbit → Duna orbit).

**ESCAPE**  
This orbit will enter the SOI of a larger body outside the current one (e.g., Kerbin orbit → Sun orbit).

**MANEUVER**  
This orbit will end due to execution of a maneuver node that begins a new orbit.
