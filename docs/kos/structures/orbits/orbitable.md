> Source: https://ksp-kos.github.io/KOS/structures/orbits/orbitable.html (mirrored offline copy for local reference)

# Orbitable (Vessels and Bodies) — kOS 1.4.0.0 Documentation

## Overview

The Orbitable structure defines common properties shared by all objects capable of orbiting, including both vessels and celestial bodies. This ensures consistency across different orbital object types.

### Important Note: SOI Body

"SOI Body" refers to the central body around which an object orbits—the body whose sphere of influence contains the object. For the Mun, the SOI body is Kerbin; for Kerbin, it's the Sun.

## Structure Definition

### Orbitable Attributes (All Read-Only)

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Name of the vessel or body |
| `BODY` | Body | The body being orbited |
| `HASBODY` | Boolean | True if object orbits another body |
| `HASORBIT` | Boolean | Alias for HASBODY |
| `HASOBT` | Boolean | Alias for HASBODY |
| `OBT` | Orbit | Current single orbit patch |
| `ORBIT` | Orbit | Alias for OBT |
| `UP` | Direction | Points away from SOI body |
| `NORTH` | Direction | Points north, parallel to surface |
| `PROGRADE` | Direction | Direction of orbitable-frame velocity |
| `SRFPROGRADE` | Direction | Direction of surface-frame velocity |
| `RETROGRADE` | Direction | Opposite of orbitable-frame velocity |
| `SRFRETROGRADE` | Direction | Opposite of surface-frame velocity |
| `POSITION` | Vector | Position in SHIP-RAW reference frame |
| `VELOCITY` | OrbitableVelocity | Velocity in SHIP-RAW reference frame |
| `DISTANCE` | Scalar (m) | Distance from SHIP center |
| `DIRECTION` | Direction | Direction from SHIP to object |
| `LATITUDE` | Scalar (deg) | Latitude beneath object |
| `LONGITUDE` | Scalar (deg) | Longitude beneath object [-180,180] |
| `ALTITUDE` | Scalar (m) | Height above sea level |
| `GEOPOSITION` | GeoCoordinates | Combined latitude/longitude |
| `PATCHES` | List of Orbits | Future orbit patches |
| `APOAPSIS` | Scalar (m) | Deprecated—use OBT:APOAPSIS |
| `PERIAPSIS` | Scalar (m) | Deprecated—use OBT:PERIAPSIS |

## Detailed Attribute Descriptions

**NAME**: The vessel or body name (get only).

**HASBODY**: Returns true unless the object is the Sun (get only).

**BODY**: Returns "the Body that this object is orbiting" (get only).

**OBT/ORBIT**: Represents the current orbital patch without considering future maneuver nodes or encounters (get only).

**UP**: Points radially away from the SOI body (get only).

**NORTH**: Indicates northward direction on the SOI body surface (get only).

**PROGRADE**: Aligned with orbitable velocity direction (get only).

**SRFPROGRADE**: Aligned with surface velocity; for bodies, relative to SOI surface (get only).

**RETROGRADE**: Opposite direction of orbitable velocity (get only).

**SRFRETROGRADE**: Opposite surface velocity direction (get only).

**POSITION**: Location in SHIP-RAW reference frame (get only).

**VELOCITY**: Orbital velocity in SHIP-RAW reference frame (get only).

**DISTANCE**: Scalar distance to SHIP center (get only).

**DIRECTION**: Direction vector from SHIP to object (get only).

**LATITUDE/LONGITUDE**: Surface coordinates of subsurface point (get only).

**ALTITUDE**: Height above sea level, not planetary center (get only).

**GEOPOSITION**: Combined latitude and longitude structure (get only).

**PATCHES**: List of orbital patches; index 0 is current orbit (get only).

**APOAPSIS/PERIAPSIS**: Deprecated; use `OBT:APOAPSIS` and `OBT:PERIAPSIS` instead.
