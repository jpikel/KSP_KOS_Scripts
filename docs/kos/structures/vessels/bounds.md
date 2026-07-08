> Source: https://ksp-kos.github.io/KOS/structures/vessels/bounds.html (mirrored offline copy for local reference)

# BOUNDS — kOS 1.4.0.0 Documentation

## Overview

The `BOUNDS` structure provides information about bounding boxes for vessels or parts. You can obtain bounds via:
- `Vessel:BOUNDS`
- `Part:BOUNDS`

This is useful for determining ship size, checking landing leg height above ground, and other spatial queries.

## Quick Start Examples

### 1. Radar Altitude (Most Useful)

Access the distance of a bounding box's bottom corner to the ground using `BOTTOMALTRADAR`:

```kos
local bounds_box is ship:bounds.
until terminal:input:haschar {
  clearscreen.
  print "PRESS ANY KEY TO QUIT".
  print "ALT:RADAR of ship bounding box's bottom corner is:".
  print round(bounds_box:BOTTOMALTRADAR, 1).
  wait 0.
}
terminal:input:getchar().
```

For a specific part:

```kos
set leg_part to ship:partstagged("sensing leg")[0].
local bounds_box is leg_part:bounds.
```

### 2. Finding the Furthest Corner

Use `FURTHESTCORNER(ray)` to find which corner extends furthest in a given direction:

```kos
set B to ship:BOUNDS.
set bottom to B:FURTHESTCORNER( - up:vector ).
```

### 3. Visual Display Example

See tutorials section for a program that displays bounds boxes visually.

## Dynamic Updates with Vessel/Part Movement

When obtained via `Part:BOUNDS` or `Vessel:BOUNDS`, the bounds structure "remembers" its associated object and automatically updates as the object moves or rotates. This applies to these suffixes:
- `ABSMIN`, `ABSMAX`, `ABSCENTER`, `ABSORIGIN`, `FACING`, `FURTHESTCORNER`, `BOTTOMALT`, `BOTTOMALTRADAR`

**Important:** Setting `ABSORIGIN` or `FACING` breaks this automatic linkage.

## Reusing Bounds for Performance

Reusing a `Bounds` object is significantly more efficient than repeatedly calling the `:BOUNDS` suffix:

```kos
// INEFFICIENT - Expensive approach:
for i in range(0,100) {
  print i + ": absmin=" + SHIP:bounds:absmin + ", absmax=" + SHIP:bounds:absmax.
  wait 0.
}

// EFFICIENT - Better practice:
local B is SHIP:bounds.
for i in range(0,100) {
  print i + ": absmin=" + B:absmin + ", absmax=" + B:absmax.
  wait 0.
}
```

Calling `Vessel:BOUNDS` repeatedly is particularly expensive; `Part:BOUNDS` is cheaper.

## When Bounds Become Invalid

A bounds must be recalculated when:

**For Part Bounds:**
- Solar panels extend/retract
- Landing gear extends/retracts
- Cargo bay doors open/close
- Robotic parts move (Breaking Ground DLC)

**For Vessel Bounds (in addition to above):**
- Parts are added/removed (docking, undocking, decoupling, explosions, etc.)
- Control orientation changes (control-from-here on docking port, lander can, IVA entry)

## Creating Custom Bounds

Construct manual bounds using:

```kos
local my_bounds is BOUNDS( ABSORIGIN, FACING, RELMIN, RELMAX ).
```

Example:

```kos
local my_flag is vessel("that flag").
local my_bounds is BOUNDS(
  my_flag:position,
  my_flag:up,
  V(-10, -10, -2),
  V(10, 10, 500)
).
```

Manually created bounds lack automatic linkage to objects.

## Bounds Structure Reference

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `ABSORIGIN` | Vector | Get/Set | Origin point in absolute coordinates |
| `FACING` | Direction | Get/Set | Box orientation in absolute frame |
| `RELMIN` | Vector | Get/Set | "Negative-most" corner in box reference frame |
| `RELMAX` | Vector | Get/Set | "Positive-most" corner in box reference frame |
| `ABSMIN` | Vector | Get only | RELMIN rotated/translated to absolute frame |
| `ABSMAX` | Vector | Get only | RELMAX rotated/translated to absolute frame |
| `ABSCENTER` | Vector | Get only | Box center in absolute frame |
| `RELCENTER` | Vector | Get only | Box center in box reference frame |
| `EXTENTS` | Vector | Get only | Vector from center to RELMAX corner |
| `SIZE` | Vector | Get only | Twice EXTENTS (RELMIN to RELMAX) |
| `FURTHESTCORNER(Vector ray)` | Vector | Get only | Corner furthest along ray direction |
| `BOTTOMALT` | Scalar | Get only | Sea-level altitude of bottommost corner |
| `BOTTOMALTRADAR` | Scalar | Get only | Radar altitude of bottommost corner |

### ABSORIGIN

The bounding box origin in absolute coordinates. For parts, matches `Part:POSITION`; for vessels, matches `Vessel:PARTS[0]:POSITION` (root part, not center of mass). Auto-updates unless you SET it.

### FACING

The orientation of the box's local reference frame as a Direction. For parts, matches `Part:FACING`; for vessels, matches `Vessel:FACING`. Auto-updates unless you SET it.

### RELMIN

One corner (negative-most) in the box's own reference frame. Vector from origin to this corner where X, Y, Z have minimum values.

### RELMAX

Opposite corner (positive-most) in the box's own reference frame. Vector from origin to this corner where X, Y, Z have maximum values.

### ABSMIN

RELMIN converted to absolute coordinates:
```kos
B:ABSORIGIN + (B:FACING * B:RELMIN)
```

### ABSMAX

RELMAX converted to absolute coordinates:
```kos
B:ABSORIGIN + (B:FACING * B:RELMAX)
```

### RELCENTER

The center point of the box in the box's reference frame (halfway between RELMIN and RELMAX).

### ABSCENTER

The center point in absolute coordinates:
```kos
MyBounds:ABSORIGIN + (MyBounds:FACING * MyBounds:RELCENTER)
```

Also equals the point halfway between ABSMIN and ABSMAX.

### EXTENTS

Vector (in box reference frame) from center to RELMAX corner.

### SIZE

Vector (in box reference frame) from RELMIN to RELMAX; equals `2 * EXTENTS`.

### FURTHESTCORNER(ray)

Returns the position (in absolute coordinates) of whichever of the 8 corners is furthest in the direction the ray vector points.

Examples:

```kos
local ves_box is other_vessel:bounds.
local top is ves_box:furthestcorner(up:vector).
local bottom is ves_box:furthestcorner(-up:vector).

local from_other_to_me is ship:position - other_vessel:position.
local nearest is ves_box:furthestcorner(from_other_to_me).
print "The closest point on the other vessel's bounds box is this far away:".
print nearest:mag.

local my_left is -ship:facing:starvector.
local leftmost is ves_box:furthestcorner(my_left).
print "In order to go around the other vessel, to the left, ".
print "I would need to shift myself this far to my left:".
print vdot(-ship:facing:starvector, leftmost).
```

### BOTTOMALT

Above-sea-level altitude of the bottommost corner. Uses the CPU vessel's current body to determine "down" direction and which body defines altitude, regardless of whether the bounds box belongs to the current ship or another object.

### BOTTOMALTRADAR

Radar altitude (above ground surface) of the bottommost corner. Same as `BOTTOMALT` but radar altitude instead of sea-level altitude.

## RELORIGIN Missing

This suffix intentionally does not exist. It would always equal `V(0,0,0)` since it represents the origin in the origin's own reference frame.

## Technical Background: Why Bounds Are Computed This Way

### What is a Bounding Box?

A bounding box is the smallest rectangular box containing all vertices of an object, aligned with its local axes. Game engines use them for collision detection and rendering optimization.

### Why Repeated :BOUNDS Calls Are Expensive

Unity's native bounding boxes align with world XYZ axes. To get a tightly-fitted rotated box (as needed by kOS), the system must examine actual mesh vertices and apply coordinate transformations. For a whole vessel, this requires transforming 8 vertices per part across all parts—expensive work.

### Why Reusing Bounds Is Faster

kOS stores _relative_ bounds in the object's reference frame and caches the transformation. When reusing a bounds object, only rotation/translation is applied to pre-calculated relative bounds, avoiding the expensive per-vertex transformations each time.

### Credit

The approach was inspired by examination of kRPC's bounding box implementation (both projects are GPL3 licensed).
