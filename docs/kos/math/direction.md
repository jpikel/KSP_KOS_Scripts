> Source: https://ksp-kos.github.io/KOS/math/direction.html (mirrored offline copy for local reference)

# Directions — kOS 1.4.0.0 Documentation

## Directions

`Direction` objects represent rotations in KSP's coordinate system, starting from a default state looking down the +z axis with +y as "up". They enable automated steering and can be used interchangeably with rotations.

**Important**: KSP uses a left-handed coordinate system, which affects rotation direction conventions.

## Creation

| Method | Description |
|--------|-------------|
| `R(pitch,yaw,roll)` | Euler rotation |
| `Q(x,y,z,rot)` | Quaternion |
| `HEADING(dir,pitch,roll)` | Compass heading |
| `LOOKDIRUP(lookAt,lookUp)` | Looking along vector with roll control |
| `ANGLEAXIS(degrees,axisVector)` | Rotation around an axis |
| `ROTATEFROMTO(fromVec,toVec)` | Rotation from one vector to another |
| `FACING`, `UP`, `PROGRADE`, etc. | From SHIP, TARGET, or BODY |

### R(pitch,yaw,roll)

Create a Direction from Euler rotation with pitch, yaw, and roll in degrees:

```
SET myDir TO R( a, b, c ).
```

### Q(x,y,z,rot)

Create a Direction from a quaternion tuple:

```
SET myDir TO Q( x, y, z, w ).
```

Note: Only use if you understand quaternions already.

### HEADING(dir,pitch,roll)

Create a Direction from compass heading and pitch above horizon:

```
SET myDir TO HEADING(degreesFromNorth, pitchAboveHorizon).
```

The third parameter (roll) is optional.

### LOOKDIRUP(lookAt,lookUp)

Create a Direction using two vectors. `lookAt` defines the forward direction (Z axis), and `lookUp` defines the top direction (Y axis). Vectors need not be perpendicular:

```
// Aim up the SOI's north axis, rolling the roof to point to the sun.
LOCK STEERING TO LOOKDIRUP( V(0,1,0), SUN:POSITION ).

// A direction that aims normal to orbit, with the roof pointed down toward the planet:
LOCK normVec to VCRS(SHIP:BODY:POSITION,SHIP:VELOCITY:ORBIT).
LOCK STEERING TO LOOKDIRUP( normVec, SHIP:BODY:POSITION).
```

### ANGLEAXIS(degrees,axisVector)

Create a Direction representing a rotation of degrees around an axis:

```
// Pick a new rotation that is pitched 30 degrees from the current one:
SET pitchUp30 to ANGLEAXIS(-30,SHIP:STARFACING).
SET newDir to pitchUp30*SHIP:FACING.
LOCK STEERING TO newDir.
```

Note: Remember KSP's left-handed coordinate system affects positive rotation direction.

### ROTATEFROMTO(fromVec,toVec)

Create a Direction that rotates one vector toward another. Note there are infinite valid rotations, as roll is not guaranteed:

```
SET myDir to ROTATEFROMTO( v1, v2 ).
```

### From Other Structures

Directions can be obtained from suffixes of other structures:

```
SET myDir TO SHIP:FACING.
SET myDir TO TARGET:FACING.
SET myDir TO SHIP:UP.
```

When printed, a Direction always displays as its Euler rotation:

```
// Initializes a direction to prograde plus a relative pitch of 90
SET X TO SHIP:PROGRADE + R(90,0,0).

// Steer the vessel in the direction suggested by direction X.
LOCK STEERING TO X.

// Create a rotation facing northeast, 10 degrees above horizon
SET Y TO HEADING(45, 10).

// Steer the vessel in the direction suggested by direction Y.
LOCK STEERING TO Y.

// Set by a rotation in degrees
SET Direction TO R(0,90,0).
```

## Structure

Direction suffixes are read-only. To create a new Direction, construct a new one.

| Suffix | Type | Description |
|--------|------|-------------|
| `PITCH` | Scalar (deg) | Rotation around x axis |
| `YAW` | Scalar (deg) | Rotation around y axis |
| `ROLL` | Scalar (deg) | Rotation around z axis |
| `FOREVECTOR` or `VECTOR` | Vector | Forward vector (z axis after rotation) |
| `TOPVECTOR` or `UPVECTOR` | Vector | Top vector (y axis after rotation) |
| `STARVECTOR` or `RIGHTVECTOR` | Vector | Starboard vector (x axis after rotation) |
| `INVERSE` or `-` (unary minus) | Direction | Inverse of this direction |

### Direction:PITCH

**Type**: Scalar (deg)  
**Access**: Get only

Rotation around the x axis.

### Direction:YAW

**Type**: Scalar (deg)  
**Access**: Get only

Rotation around the y axis.

### Direction:ROLL

**Type**: Scalar (deg)  
**Access**: Get only

Rotation around the z axis.

### Direction:FOREVECTOR

**Type**: Vector  
**Access**: Get only

Unit vector in the "look-at" direction. Represents what the Z axis becomes after applying this rotation. When steering locked to a direction, the ship's nose orients to this vector. `SHIP:FACING:FOREVECTOR` shows the ship's current nose direction.

### Direction:TOPVECTOR

**Type**: Vector  
**Access**: Get only

Unit vector in the "look-up" direction. Represents what the Y axis becomes after applying this rotation. When steering locked to a direction, the ship's roof orients to this vector. `SHIP:FACING:TOPVECTOR` shows the ship's current roof direction.

### Direction:STARVECTOR

**Type**: Vector  
**Access**: Get only

Unit vector in the "starboard side" direction. Represents what the X axis becomes after applying this rotation. When steering locked to a direction, the ship's right wing orients to this vector. `SHIP:FACING:STARVECTOR` shows the ship's current right wing direction.

### Direction:INVERSE

**Type**: Direction  
**Access**: Get only

Returns a Direction with the opposite rotation around its axes.

## Important Rotation Order

When manipulating directions, rotations occur in this order:

1. First rotate around z axis (roll)
2. Then rotate around x axis (pitch)
3. Then rotate around y axis (yaw)

This means `R(0,45,45)` rolls first, then yaws—which may differ from expectations.

## Operations and Methods

### Direction Multiplied by Direction

`Dir1 * Dir2` - Returns the result of rotating Dir2 by the rotation of Dir1. Order matters: `Dir1*Dir2` ≠ `Dir2*Dir1`.

```
// A direction pointing along compass heading 330,
// by rotating NORTH by 30 degrees around UP axis:
SET newDir TO ANGLEAXIS(30,SHIP:UP) * NORTH.
```

### Direction Multiplied by Vector

`Dir * Vec` - Returns the vector rotated by the Direction:

```
// What would the velocity of your ship be if angled 20 degrees to your left?
SET Vel to ANGLEAXIS(-20,SHIP:TOPVECTOR) * SHIP:VELOCITY:ORBIT.
// At this point Vel:MAG and SHIP:VELOCITY:MAG should be the same,
// but they don't point the same way
```

### Direction Added to Direction

`Dir1 + Dir2` - Less reliable due to Unity engine rotation order dependencies and gimbal lock potential. Prefer `Dir*Dir` instead:

```
// Preferred approach using multiplication
SET newDir TO rotation1 * rotation2.
```

### Vector Operations with Directions

Use the `:VECTOR` suffix for vector methods:

```
SET dir TO SHIP:UP.
SET newdir TO VCRS(SHIP:PROGRADE:VECTOR, dir:VECTOR)
```

## The Difference Between Vectors and Directions

Both represent the same amount of information (3 floating-point numbers), but with different meanings:

- **Vectors** hold magnitude information
- **Directions** include "up" orientation information

A Vector lacks roll information. When locking steering to a Vector, the ship's nose points correctly but roof orientation is undefined—fine for axisymmetrical rockets, problematic for airplanes.

```
SET MyVec to V(100,200,300).
SET MyDir to MyVec:DIRECTION.
```

`MyDir` will be a Direction, but with undefined "up" orientation due to the conversion from the Vector.
