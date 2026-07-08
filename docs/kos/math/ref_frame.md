> Source: https://ksp-kos.github.io/KOS/math/ref_frame.html (mirrored offline copy for local reference)

# Reference Frames — kOS 1.4.0.0 Documentation

## Overview

This section explains the (x,y,z) coordinate system used throughout kOS, which is inherited from Kerbal Space Program. A critical distinction: "Kerbal Space program uses a **LEFT-handed** coordinate system."

The left-handed nature means if you extend your left palm along the x-axis and curl fingers toward the y-axis, your thumb points along the z-axis—opposite to the right-handed systems common in textbooks.

## Reference Frame Types

**SHIP-RAW**
- Origin: CPU Vessel (SHIP)
- Rotation: KSP's native raw coordinate grid

**SOI-RAW**
- Origin: Center of the SOI body
- Rotation: KSP's native raw coordinate grid

**RAW-RAW**
- Both origin and rotation match KSP's native system
- Not exposed to KerbalScript programs

*Note: Future expansions may provide additional reference frames and conversion utilities.*

## Raw Orientation

The Y-axis points upward through the SOI body's north pole. The X and Z axes lie in the equatorial plane, perpendicular to each other. Due to the left-handed system, the Z-axis is rotated 90 degrees eastward from the X-axis.

The exact positioning of X and Z axes varies based on location, making them difficult to predict precisely.

## Origin Position

Position vectors use SHIP-RAW (origin at your vessel), while velocity vectors use SOI-RAW (origin at the SOI body's center). This asymmetry ensures velocity isn't zero in the reference frame.

## Converting Between Frames

Since both frames share identical axis rotation, conversion involves simple vector addition/subtraction:

- **SHIP-RAW to SOI-RAW:** Subtract `SHIP:BODY:POSITION`
- **SOI-RAW to SHIP-RAW:** Add `SHIP:BODY:POSITION`
