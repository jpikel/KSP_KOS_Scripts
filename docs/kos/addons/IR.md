> Source: https://ksp-kos.github.io/KOS/addons/IR.html (mirrored offline copy for local reference)

# Infernal Robotics — kOS 1.4.0.0 Documentation

## Overview

Infernal Robotics introduces robotics parts to Kerbal Space Program, enabling creation of moving and spinning contraptions not possible under stock KSP. The mod has migrated to **Infernal Robotics Next**, which is the only version supported by kOS.

### Download Links

- **Infernal Robotics Next:** https://github.com/meirumeiru/InfernalRobotics/releases
- **Forum Thread:** https://forum.kerbalspaceprogram.com/index.php?/topic/170898–/
- **Historical Downloads:** 
  - http://kerbal.curseforge.com/ksp-mods/220267
  - https://github.com/MagicSmokeIndustries/InfernalRobotics/releases
- **Historical Forum:** http://forum.kerbalspaceprogram.com/index.php?/topic/104535–/

### Installation Check

Test if Infernal Robotics is installed using: `addons:available("ir")`

> "IR Next officially supports KSP 1.3.1 and 1.4.2 with beta 3 patch 7"

---

## IRAddon Structure

Access via `ADDONS:IR`

| Suffix | Type | Description |
|--------|------|-------------|
| `AVAILABLE` | boolean (readonly) | Returns True if mod is installed and available |
| `GROUPS` | List of IRControlGroup | Lists all Servo Groups for the vessel |
| `ALLSERVOS` | List of IRServo | Lists all Servos for the vessel |
| `PARTSERVOS(Part)` | List of IRServo | Lists all Servos for a provided part |

### IRAddon:AVAILABLE

**Type:** Boolean  
**Access:** Get only

Returns True if Infernal Robotics is installed, available to kOS, and applicable to current craft.

```
if ADDONS:IR:AVAILABLE
{
    //some IR dependent code
}
```

### IRAddon:GROUPS

**Type:** List of IRControlGroup objects  
**Access:** Get only

Lists all Servo Groups for the vessel executing the script.

```
for g in ADDONS:IR:GROUPS
{
    Print g:NAME + " contains " + g:SERVOS:LENGTH + " servos".
}
```

### IRAddon:ALLSERVOS

**Type:** List of IRServo objects  
**Access:** Get only

Lists all Servos for the vessel executing the script.

```
for s in ADDONS:IR:ALLSERVOS
{
    print "Name: " + s:NAME + ", position: " + s:POSITION.
}
```

### IRAddon:PARTSERVOS(part)

**Parameters:**
- **part** – Part for which to return servos

**Return type:** List of IRServo objects

Lists all Servos found on the given Part.

---

## IRControlGroup Structure

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | string | Name of the Control Group |
| `SPEED` | scalar | Speed multiplier set in IR UI |
| `EXPANDED` | Boolean | True if Group is expanded in IR UI |
| `FORWARDKEY` | string | Key assigned to forward movement |
| `REVERSEKEY` | string | Key assigned to reverse movement |
| `SERVOS` | List (readonly) | List of servos in the group |
| `VESSEL` | Vessel | Vessel object owning this servo group (Readonly) |
| `MOVERIGHT()` | void | Commands servos to move in positive direction |
| `MOVELEFT()` | void | Commands servos to move in negative direction |
| `MOVECENTER()` | void | Commands servos to move to default position |
| `MOVENEXTPRESET()` | void | Commands servos to move to next preset |
| `MOVEPREVPRESET()` | void | Commands servos to move to previous preset |
| `STOP()` | void | Commands servos to stop |

### IRControlGroup:NAME

**Type:** string  
**Access:** Get/Set

Name of the Control Group (cannot be empty).

### IRControlGroup:SPEED

**Type:** scalar  
**Access:** Get/Set

Speed multiplier as set in IR user interface. Avoid setting to 0.

### IRControlGroup:EXPANDED

**Type:** Boolean  
**Access:** Get/Set

True if Group is expanded in IR UI.

### IRControlGroup:FORWARDKEY

**Type:** string  
**Access:** Get/Set

Key assigned to forward movement. Can be empty.

### IRControlGroup:REVERSEKEY

**Type:** string  
**Access:** Get/Set

Key assigned to reverse movement. Can be empty.

### IRControlGroup:SERVOS

**Type:** List of IRServo objects  
**Access:** Get only

Lists Servos in the Group.

```
for g in ADDONS:IR:GROUPS
{
    Print g:NAME + " contains " + g:SERVOS:LENGTH + " servos:".
    for s in g:servos
    {
        print "    " + s:NAME + ", position: " + s:POSITION.
    }
}
```

### IRControlGroup:VESSEL

**Type:** Vessel  
**Access:** Get only

Returns the Vessel that owns this ServoGroup.

### IRControlGroup Movement Methods

#### MOVERIGHT()

Commands servos in the group to move in positive direction.

#### MOVELEFT()

Commands servos in the group to move in negative direction.

#### MOVECENTER()

Commands servos in the group to move to default position.

#### MOVENEXTPRESET()

Commands servos in the group to move to next preset.

#### MOVEPREVPRESET()

Commands servos in the group to move to previous preset.

#### STOP()

Commands servos in the group to stop.

---

## IRServo Structure

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | string | Name of the Servo |
| `UID` | scalar (int) | Unique ID of the servo part (part.flightID) |
| `HIGHLIGHT` | Boolean (set-only) | Set highlight status of the part |
| `POSITION` | scalar (readonly) | Current position of the servo |
| `MINCFGPOSITION` | scalar (readonly) | Minimum position from part.cfg |
| `MAXCFGPOSITION` | scalar (readonly) | Maximum position from part.cfg |
| `MINPOSITION` | scalar | Minimum position from tweakable |
| `MAXPOSITION` | scalar | Maximum position from tweakable |
| `CONFIGSPEED` | scalar (readonly) | Servo movement speed from part.cfg |
| `SPEED` | scalar | Servo speed multiplier from tweakable |
| `CURRENTSPEED` | scalar (readonly) | Current Servo speed |
| `ACCELERATION` | scalar | Servo acceleration multiplier from tweakable |
| `ISMOVING` | Boolean (readonly) | True if Servo is moving |
| `ISFREEMOVING` | Boolean (readonly) | True if Servo is uncontrollable |
| `LOCKED` | Boolean | Servo's locked status |
| `INVERTED` | Boolean | Servo's inverted status |
| `PART` | Part | Reference to Part containing servo module |
| `MOVERIGHT()` | void | Commands servo to move in positive direction |
| `MOVELEFT()` | void | Commands servo to move in negative direction |
| `MOVECENTER()` | void | Commands servo to move to default position |
| `MOVENEXTPRESET()` | void | Commands servo to move to next preset |
| `MOVEPREVPRESET()` | void | Commands servo to move to previous preset |
| `STOP()` | void | Commands servo to stop |
| `MOVETO(position, speedMult)` | void | Commands servo to move to position with speed multiplier |

### IRServo:NAME

**Type:** string  
**Access:** Get/Set

Name of the Servo (cannot be empty).

### IRServo:UID

**Type:** scalar  
**Access:** Get

Unique ID of the servo part (part.flightID).

### IRServo:HIGHLIGHT

**Type:** Boolean  
**Access:** Set

Set highlight status of the part.

### IRServo:POSITION

**Type:** scalar  
**Access:** Get

Current position of the servo.

### IRServo:MINCFGPOSITION

**Type:** scalar  
**Access:** Get

Minimum position for servo as defined by part creator in part.cfg.

### IRServo:MAXCFGPOSITION

**Type:** scalar  
**Access:** Get

Maximum position for servo as defined by part creator in part.cfg.

### IRServo:MINPOSITION

**Type:** scalar  
**Access:** Get/Set

Minimum position for servo from tweakable.

### IRServo:MAXPOSITION

**Type:** scalar  
**Access:** Get/Set

Maximum position for servo from tweakable.

### IRServo:CONFIGSPEED

**Type:** scalar  
**Access:** Get

Servo movement speed as defined by part creator in part.cfg.

### IRServo:SPEED

**Type:** scalar  
**Access:** Get/Set

Servo speed multiplier from tweakable.

### IRServo:CURRENTSPEED

**Type:** scalar  
**Access:** Get

Current Servo speed.

### IRServo:ACCELERATION

**Type:** scalar  
**Access:** Get/Set

Servo acceleration multiplier from tweakable.

### IRServo:ISMOVING

**Type:** Boolean  
**Access:** Get

True if Servo is moving.

### IRServo:ISFREEMOVING

**Type:** Boolean  
**Access:** Get

True if Servo is uncontrollable (e.g., docking washer).

### IRServo:LOCKED

**Type:** Boolean  
**Access:** Get/Set

Servo's locked status. Set true to lock servo.

### IRServo:INVERTED

**Type:** Boolean  
**Access:** Get/Set

Servo's inverted status. Set true to invert servo's axis.

### IRServo:PART

**Type:** Part  
**Access:** Get

Returns reference to the Part containing servo module. Note that Part:UID does not equal IRServo:UID.

### IRServo Movement Methods

#### MOVERIGHT()

Commands servo to move in positive direction.

#### MOVELEFT()

Commands servo to move in negative direction.

#### MOVECENTER()

Commands servo to move to default position.

#### MOVENEXTPRESET()

Commands servo to move to next preset.

#### MOVEPREVPRESET()

Commands servo to move to previous preset.

#### STOP()

Commands servo to stop.

#### MOVETO(position, speedMult)

**Parameters:**
- **position** – (float) Position to move to
- **speedMult** – (float) Speed multiplier

Commands servo to move to position with speedMult multiplier.

---

## Example Code

```
print "IR Available: " + ADDONS:IR:AVAILABLE.

Print "Groups:".

for g in ADDONS:IR:GROUPS
{
    Print g:NAME + " contains " + g:SERVOS:LENGTH + " servos:".
    for s in g:servos
    {
        print "    " + s:NAME + ", position: " + s:POSITION.
        if (g:NAME = "Hinges" and s:POSITION = 0)
        {
            s:MOVETO(30, 2).
        }
        else if (g:NAME = "Hinges" and s:POSITION > 0)
        {
            s:MOVETO(0, 1).
        }
    }
}
```
