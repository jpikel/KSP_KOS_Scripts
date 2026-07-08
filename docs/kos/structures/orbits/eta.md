> Source: https://ksp-kos.github.io/KOS/structures/orbits/eta.html (mirrored offline copy for local reference)

# OrbitEta — kOS 1.4.0.0 Documentation

## OrbitEta

OrbitEta is a specialized object designed to provide timing information for orbital events. It operates on an Orbit object and can be accessed through two methods:

1. Via the `ETA` suffix on any Orbit object:
   ```
   print SHIP:OBT:ETA:APOAPSIS.
   print SHIP:OBT:NEXTPATCH:ETA:APOAPSIS.
   ```

2. Using the `ETA` keyword as shorthand for `SHIP:OBT:ETA`:
   ```
   print ETA:APOAPSIS.
   ```

### Structure Definition

| Suffix | Type | Description |
|--------|------|-------------|
| `APOAPSIS` | Scalar (s) | Seconds from now until apoapsis |
| `PERIAPSIS` | Scalar (s) | Seconds from now until periapsis |
| `NEXTNODE` | Scalar (s) | Seconds from now until the next maneuver node |
| `TRANSITION` | Scalar (s) | Seconds from now until the next orbit patch starts |

## Attributes

### ETA:APOAPSIS

**Type:** Scalar (s)  
**Access:** Get-only

Indicates seconds until the object reaches apoapsis on its current orbit patch. Even hypothetical orbits created via `CREATEORBIT` have a theoretical point representing the object's current position.

For escape trajectories (hyperbolic orbits) where apoapsis is unreachable, the value returns `3.402823E+38` (the largest representable single-precision float). A practical test for assuming infinity: `if eta:apoapsis > 100000000000000`.

Note: In standard KSP gameplay, this value may be misleading for very large elliptical orbits that escape despite being mathematically non-hyperbolic. True hyperbolic orbits are identified by negative apoapsis altitude.

### ETA:PERIAPSIS

**Type:** Scalar (s)  
**Access:** Get-only

Returns seconds until periapsis. If collision with terrain occurs before periapsis, the hypothetical time is still provided as if terrain were passable.

On hyperbolic orbits, if periapsis has already passed, the value becomes negative, representing elapsed time since that point rather than returning the large number placeholder.

### ETA:NEXTNODE

**Type:** Scalar (s)  
**Access:** Get-only

Provides seconds until the next maneuver node timestamp as displayed on the navball, excluding lead time adjustments.

Unlike `NEXTNODE:ETA`, which throws an error when no node exists, this attribute returns a very large floating-point value (32-bit maximum) instead. This approach accommodates kOS's restriction against infinity values.

### ETA:TRANSITION

**Type:** Scalar (s)  
**Access:** Get-only

Shows seconds until transition to the next orbit patch, disregarding intervening maneuver nodes and assuming no node execution.

When no subsequent transition exists (closed orbit within current sphere of influence), returns the maximum 32-bit floating-point value.
