> Source: https://ksp-kos.github.io/KOS/structures/vessels/gimbal.html (mirrored offline copy for local reference)

# Gimbal — kOS 1.4.0.0 Documentation

## Gimbal

Many engines in KSP have thrust vectoring gimbals which are handled by their own module.

### Structure: GIMBAL

| Suffix | Type (units) | Description |
|--------|--------------|-------------|
| All suffixes of `PartModule` | — | Inherited from PartModule |
| `LOCK` | Boolean | Is the Gimbal locked in neutral position? |
| `PITCH` | Boolean | Does the Gimbal respond to pitch controls? |
| `YAW` | Boolean | Does the Gimbal respond to yaw controls? |
| `ROLL` | Boolean | Does the Gimbal respond to roll controls? |
| `LIMIT` | Scalar (%) | Percentage of the maximum range the Gimbal is allowed to travel |
| `RANGE` | Scalar (deg) | The Gimbal's Possible Range of movement |
| `RESPONSESPEED` | Scalar | The Gimbal's Possible Rate of travel |
| `PITCHANGLE` | Scalar | Current Gimbal Pitch |
| `YAWANGLE` | Scalar | Current Gimbal Yaw |
| `ROLLANGLE` | Scalar | Current Gimbal Roll |

**Note:** `Gimbal` is a type of `PartModule`, and therefore can use all the suffixes of `PartModule`. Shown below are only the suffixes unique to `Gimbal`. `Gimbal` can be accessed as the `Engine:GIMBAL` attribute of `Engine`.

### Gimbal:LOCK

**Type:** Boolean  
**Access:** Get/Set

Indicates whether the gimbal is locked to neutral position. Setting to true snaps the engine back to zero pitch, yaw, and roll.

### Gimbal:PITCH

**Type:** Boolean  
**Access:** Get/Set

Determines if the gimbal responds to pitch controls (only relevant when not locked).

### Gimbal:YAW

**Type:** Boolean  
**Access:** Get/Set

Determines if the gimbal responds to yaw controls (only relevant when not locked).

### Gimbal:ROLL

**Type:** Boolean  
**Access:** Get/Set

Determines if the gimbal responds to roll controls (only relevant when not locked).

### Gimbal:LIMIT

**Type:** Scalar (%)  
**Access:** Get/Set

The percentage of maximum range this gimbal is allowed to travel.

### Gimbal:RANGE

**Type:** Scalar (deg)  
**Access:** Get only

The maximum extent of travel possible for the gimbal along all three axes (Pitch, Yaw, Roll).

### Gimbal:RESPONSESPEED

**Type:** Scalar  
**Access:** Get only

A measure of the rate of travel for the gimbal.

### Gimbal:PITCHANGLE

**Type:** Scalar  
**Access:** Get only

The gimbal's current pitch, ranging from -1 to 1. Always 0 when LOCK is true.

### Gimbal:YAWANGLE

**Type:** Scalar  
**Access:** Get only

The gimbal's current yaw, ranging from -1 to 1. Always 0 when LOCK is true.

### Gimbal:ROLLANGLE

**Type:** Scalar  
**Access:** Get only

The gimbal's current roll, ranging from -1 to 1. Always 0 when LOCK is true.
