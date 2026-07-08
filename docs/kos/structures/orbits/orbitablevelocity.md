> Source: https://ksp-kos.github.io/KOS/structures/orbits/orbitablevelocity.html (mirrored offline copy for local reference)

# OrbitableVelocity

When any `Orbitable` object returns its `VELOCITY` suffix, it provides a structure containing both orbit-frame and surface-frame velocity measurements at the same instant. To access velocity as a vector, you must specify which frame you need using an additional suffix.

## Structure Definition

**structure** OrbitableVelocity

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| `ORBIT` | Vector | The orbital velocity |
| `SURFACE` | Vector | The surface-frame velocity |

## Attributes

### OrbitableVelocity:ORBIT

**Type:** Vector  
**Access:** Get only

"Returns the orbital velocity."

### OrbitableVelocity:SURFACE

**Type:** Vector  
**Access:** Get only

"Returns the surface-frame velocity. Note that this is the surface velocity relative to the surface of the SOI body, not the orbiting object itself. (i.e. Mun:VELOCITY:SURFACE returns the Mun's velocity relative to the surface of its SOI body, Kerbin)."

## Special Case: The Sun

Because the Sun has no parent SoI body that it orbits, kOS hardcodes the Sun's surface velocity to match its orbital velocity. While not necessarily accurate, this approach avoids errors by returning consistent results for `Sun:VELOCITY:SURFACE`.

## Examples

```
SET VORB TO SHIP:VELOCITY:ORBIT
SET VSRF TO SHIP:VELOCITY:SURFACE
SET MUNORB TO MUN:VELOCITY:ORBIT
SET MUNSRF TO MUN:VELOCITY:SURFACE
```

## Note on Mun Velocity Direction

"At first glance it may seem that `Mun:VELOCITY:SURFACE` is wrong because it creates a vector in the opposite direction from `Mun:VELOCITY:ORBIT`, but this is actually correct. Kerbin's surface rotates once every 6 hours, and the Mun takes a lot longer than 6 hours to orbit Kerbin. Therefore, relative to Kerbin's surface, the Mun is going backward."
