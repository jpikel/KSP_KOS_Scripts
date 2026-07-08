> Source: https://ksp-kos.github.io/KOS/structures/misc/vecdraw.html (mirrored offline copy for local reference)

# Drawing Vectors on the Screen — kOS 1.4.0.0 Documentation

## Overview

You can create objects that represent vectors drawn in the flight view as holographic images. These allow you to move, show/hide, change colors, and add labels to visual vector representations.

## Function Definitions

### VECDRAW() and VECDRAWARGS()

Both function names perform identically. They create a new `vecdraw` object for on-screen manipulation.

**Syntax:**
```
SET anArrow TO VECDRAW(
  start,
  vec,
  color,
  label,
  scale,
  show,
  width,
  pointy,
  wiping
).
```

All parameters are optional and correspond to suffix names listed below.

## Dynamic Positioning with Delegates

Instead of static values, you can pass delegates for `start`, `vec`, and `color` parameters:

```
SET anArrow TO VECDRAW(
  { return (6-4*cos(100*time:seconds)) * up:vector. },
  { return (4*sin(100*time:seconds)) * up:vector. },
  { return RGBA(1, 1, RANDOM(), 1). },
  "Jumping arrow!",
  1.0,
  TRUE,
  0.2,
  TRUE,
  TRUE
).
wait 20.
set anArrow:show to false.
```

When delegates are detected, they automatically assign to `STARTUPDATER`, `VECUPDATER`, and `COLORUPDATER` respectively instead of the static attributes.

## Default Values

When parameters are omitted, defaults apply:

| Suffix | Default |
|--------|---------|
| START | V(0,0,0) |
| VEC | V(0,0,0) |
| COLOR | White |
| LABEL | "" |
| SCALE | 1.0 |
| SHOW | false |
| WIDTH | 0.2 |
| POINTY | true |
| WIPING | true |

**Example:**
```
SET vd TO VECDRAW(V(0,0,0), 5*north:vector, red).
```

## Removing VecDraws

To hide a vecdraw, set `SHOW` to false, `UNSET` the variable, or reassign it.

### CLEARVECDRAWS()

Sets all visible vecdraws to invisible throughout the kOS CPU. Useful when variable handles are lost or out of scope.

## Large VecDraw Limitation

Very large vecdraws (e.g., from ship to sun) only appear in map view, not flight view. This is due to KSP's camera far clipping plane settings, which prevents rendering polygons with distant vertices in flight view.

## VecDraw Structure

### Members Table

| Suffix | Type | Description |
|--------|------|-------------|
| START | Vector | Start position of the vector |
| VEC | Vector | The vector to draw |
| COLOR / COLOUR | Color | Color of the vector |
| LABEL | String | Text shown next to vector |
| SCALE | Scalar | Multiplies VEC and WIDTH (not START) |
| SHOW | Boolean | True to enable display |
| WIDTH | Scalar | Line width in meters (default 0.2) |
| POINTY | Boolean | Draw arrowhead (default true) |
| WIPING | Boolean | Apply fade-in effect (default true) |
| STARTUPDATER | KosDelegate | Auto-update START attribute |
| VECUPDATER / VECTORUPDATER | KosDelegate | Auto-update VEC attribute |
| COLORUPDATER / COLOURUPDATER | KosDelegate | Auto-update COLOR attribute |

## Suffix Descriptions

### VecDraw:START

**Access:** Get/Set  
**Type:** Vector

Position of the vector's tail in SHIP-RAW coordinates. V(0,0,0) represents the ship's center of mass. Defaults to V(0,0,0).

### VecDraw:VEC

**Access:** Get/Set  
**Type:** Vector

The vector to draw in SHIP-RAW coordinates. Required.

### VecDraw:COLOR / VecDraw:COLOUR

**Access:** Get/Set  
**Type:** Color

Drawing color (defaults to white). With `WIPING` enabled, creates a fade-in effect. Supports RGBA with alpha values less than 1.0.

### VecDraw:LABEL

**Access:** Get/Set  
**Type:** String

Text displayed at the vector's midpoint. Defaults to "". Font size scales with `SCALE` and `WIDTH`.

### VecDraw:SCALE

**Access:** Get/Set  
**Type:** Scalar

Multiplies VEC and WIDTH (not START). Defaults to 1.0.

### VecDraw:SHOW

**Access:** Get/Set  
**Type:** Boolean

Set true to display, false to hide. Defaults to false.

### VecDraw:WIDTH

**Access:** Get/Set  
**Type:** Scalar

Line width in meters. Defaults to 0.2. Values larger than 0.2 enlarge the label font.

### VecDraw:POINTY

**Access:** Get/Set  
**Type:** Boolean

Draws an arrowhead if true; draws only a thick line if false. Defaults to true.

### VecDraw:WIPING

**Access:** Get/Set  
**Type:** Boolean

Enables fade-in effect if true. At the start point, the line is more transparent, becoming fully opaque at the endpoint. Defaults to true. When false, the entire line uses the specified color uniformly.

### VecDraw:STARTUPDATER

**Access:** Get/Set  
**Type:** KosDelegate (no parameters, returns Vector)

Assigns a delegate for automatic START position updates each frame. Set to `DONOTHING` to stop calling the delegate.

**Example:**
```
set vd to vecdraw(v(0,0,0), ship:north:vector*5, green, "bouncing arrow", 1.0, true, 0.2).
print "Moving the arrow up and down for a few seconds.".
set vd:startupdater to { return ship:up:vector*3*sin(time:seconds*180). }.
wait 5.
print "Stopping the arrow movement.".
set vd:startupdater to DONOTHING.
wait 3.
print "Removing the arrow.".
set vd to 0.
```

*Available since kOS 1.1.0*

### VecDraw:VECUPDATER / VecDraw:VECTORUPDATER

**Access:** Get/Set  
**Type:** KosDelegate (no parameters, returns Vector)

Assigns a delegate for automatic VEC suffix updates each frame. Set to `DONOTHING` to stop.

**Example:**
```
set vd to vecdraw(v(0,0,0), v(5,0,0), green, "spinning arrow", 1.0, true, 0.2).
print "Moving the arrow in a circle for a few seconds.".
set vd:vecupdater to {
   return ship:up:vector*5*sin(time:seconds*180) + ship:north:vector*5*cos(time:seconds*180).
}.
wait 5.
print "Stopping the arrow movement.".
set vd:vecupdater to DONOTHING.
wait 3.
print "Removing the arrow.".
set vd to 0.
```

*Available since kOS 1.1.0*

### VecDraw:COLORUPDATER / VecDraw:COLOURUPDATER

**Access:** Get/Set  
**Type:** KosDelegate (no parameters, returns Color)

Assigns a delegate for automatic COLOR suffix updates each frame. Set to `DONOTHING` to stop.

**Example:**
```
set vd to vecdraw(v(0,0,0), ship:north:vector*5, green, "fading arrow", 1.0, true, 0.2).
print "Fading the arrow in and out for a few seconds.".
set vd:colorupdater to { return RGBA(0,1,0,sin(time:seconds*180)). }.
wait 5.
print "Stopping the color change.".
set vd:colorupdater to DONOTHING.
wait 3.
print "Removing the arrow.".
set vd to 0.
```

*Available since kOS 1.1.0*
</content>
