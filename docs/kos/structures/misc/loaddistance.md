> Source: https://ksp-kos.github.io/KOS/structures/misc/loaddistance.html (mirrored offline copy for local reference)

# Vessel Load Distance — kOS 1.4.0.0 Documentation

## Vessel Load Distance

**Structure:** `LoadDistance`

### Overview

The `LoadDistance` structure describes the distances at which the game unloads vessels and causes them to become "packed." This is relevant when running multiple kOS scripts simultaneously, such as:

- One airplane following another
- Two rockets flying in formation to orbit
- Multiple rovers racing to a destination

### Key Concepts

**On Rails Behavior:**
Vessels far from the active vessel don't run under the full physics engine. Instead, their physics are calculated based on orbital motion only, similar to timewarp effects.

**Loaded vs. Unloaded:**
A LOADED vessel has its parts rendered and visible. An UNLOADED vessel exists only as a dot marker in space with no dimensions or visibility.

**Packed vs. Unpacked:**
A PACKED vessel is close enough to be loaded but far enough that its parts cannot interact. The vessel appears stationary. An UNPACKED vessel has full functionality enabled.

### Critical Information

"The kOS processor is able to run scripts any time that a vessel is loaded, but the script is not guaranteed access to all features when a ship is LOADED but not UNPACKED." Check the `UNPACKED` suffix of the `SHIP` variable to verify feature availability.

### Important Warnings

**Wait Between Changes:**
Do not change load/unload and pack/unpack distances in the same physics tick. Increase load/unload distances first, then `WAIT 0.001`, then adjust pack/unpack distances.

**Space Kraken Risk:**
Excessively large distance values can degrade performance and cause floating-point precision errors, resulting in phantom collisions. Never set `PACK` distance higher than `LOAD` distance.

---

## LoadDistance Members

| Suffix | Type | Get/Set | Description |
|--------|------|---------|-------------|
| `ESCAPING` | `SituationLoadDistance` | Get | Load and pack distances while escaping the current body |
| `FLYING` | `SituationLoadDistance` | Get | Load and pack distances while flying in atmosphere |
| `LANDED` | `SituationLoadDistance` | Get | Load and pack distances while landed on the surface |
| `ORBIT` | `SituationLoadDistance` | Get | Load and pack distances while in orbit |
| `PRELAUNCH` | `SituationLoadDistance` | Get | Load and pack distances while on launch pad or runway |
| `SPLASHED` | `SituationLoadDistance` | Get | Load and pack distances while splashed in water |
| `SUBORBITAL` | `SituationLoadDistance` | Get | Load and pack distances while on suborbital trajectory |

---

## Situation Load Distance

**Structure:** `SituationLoadDistance`

Each suffix above returns a `SituationLoadDistance`, which contains load and pack distance values for specific vessel situations.

**Order Matters:** The sequence of value changes matters due to protective constraints preventing invalid configurations.

### SituationLoadDistance Members

| Suffix | Type | Get/Set | Description |
|--------|------|---------|-------------|
| `LOAD` | `Scalar` (m) | Get/Set | The load distance |
| `UNLOAD` | `Scalar` (m) | Get/Set | The unload distance |
| `UNPACK` | `Scalar` (m) | Get/Set | The unpack distance |
| `PACK` | `Scalar` (m) | Get/Set | The pack distance |

### LOAD Attribute

**Type:** `Scalar` (meters)  
**Access:** Get/Set

The distance at which vessels transition from unloaded to loaded when approaching the active vessel. Must be less than `UNLOAD` and adjusts automatically if violated.

### UNLOAD Attribute

**Type:** `Scalar` (meters)  
**Access:** Get/Set

The distance at which vessels transition from loaded to unloaded when moving away from the active vessel. Must be greater than `LOAD` and adjusts automatically if violated.

### UNPACK Attribute

**Type:** `Scalar` (meters)  
**Access:** Get/Set

The distance at which vessels transition from packed to unpacked when approaching the active vessel. Must be less than `PACK` and adjusts automatically if violated.

### PACK Attribute

**Type:** `Scalar` (meters)  
**Access:** Get/Set

The distance at which vessels transition from unpacked to packed when moving away from the active vessel. Must be greater than `UNPACK` and adjusts automatically if violated.

---

## Examples

### Print All Current Settings

```
SET distances TO KUNIVERSE:DEFAULTLOADDISTANCE.

PRINT "escaping distances:".
print "    load: " + distances:ESCAPING:LOAD + "m".
print "  unload: " + distances:ESCAPING:UNLOAD + "m".
print "  unpack: " + distances:ESCAPING:UNPACK + "m".
print "    pack: " + distances:ESCAPING:PACK + "m".
PRINT "flying distances:".
print "    load: " + distances:FLYING:LOAD + "m".
print "  unload: " + distances:FLYING:UNLOAD + "m".
print "  unpack: " + distances:FLYING:UNPACK + "m".
print "    pack: " + distances:FLYING:PACK + "m".
PRINT "landed distances:".
print "    load: " + distances:LANDED:LOAD + "m".
print "  unload: " + distances:LANDED:UNLOAD + "m".
print "  unpack: " + distances:LANDED:UNPACK + "m".
print "    pack: " + distances:LANDED:PACK + "m".
PRINT "orbit distances:".
print "    load: " + distances:ORBIT:LOAD + "m".
print "  unload: " + distances:ORBIT:UNLOAD + "m".
print "  unpack: " + distances:ORBIT:UNPACK + "m".
print "    pack: " + distances:ORBIT:PACK + "m".
PRINT "prelaunch distances:".
print "    load: " + distances:PRELAUNCH:LOAD + "m".
print "  unload: " + distances:PRELAUNCH:UNLOAD + "m".
print "  unpack: " + distances:PRELAUNCH:UNPACK + "m".
print "    pack: " + distances:PRELAUNCH:PACK + "m".
PRINT "splashed distances:".
print "    load: " + distances:SPLASHED:LOAD + "m".
print "  unload: " + distances:SPLASHED:UNLOAD + "m".
print "  unpack: " + distances:SPLASHED:UNPACK + "m".
print "    pack: " + distances:SPLASHED:PACK + "m".
PRINT "suborbital distances:".
print "    load: " + distances:SUBORBITAL:LOAD + "m".
print "  unload: " + distances:SUBORBITAL:UNLOAD + "m".
print "  unpack: " + distances:SUBORBITAL:UNPACK + "m".
print "    pack: " + distances:SUBORBITAL:PACK + "m".
```

### Change Settings for Flying

```
// 30 km for in-flight
// Note the order is important.  set UNLOAD BEFORE LOAD,
// and PACK before UNPACK.  Otherwise the protections in
// place to prevent invalid values will deny your attempt
// to change some of the values:
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:UNLOAD TO 30000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:LOAD TO 29500.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:PACK TO 29999.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:UNPACK TO 29000.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
```

### Change Settings for Landed Vessels

```
// 30 km for parked on the ground:
// Note the order is important.  set UNLOAD BEFORE LOAD,
// and PACK before UNPACK.  Otherwise the protections in
// place to prevent invalid values will deny your attempt
// to change some of the values:
SET KUNIVERSE:DEFAULTLOADDISTANCE:LANDED:UNLOAD TO 30000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:LANDED:LOAD TO 29500.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
SET KUNIVERSE:DEFAULTLOADDISTANCE:LANDED:PACK TO 39999.
SET KUNIVERSE:DEFAULTLOADDISTANCE:LANDED:UNPACK TO 29000.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
```

### Change Settings for Splashed Vessels

```
// 30 km for parked in the sea:
// Note the order is important.  set UNLOAD BEFORE LOAD,
// and PACK before UNPACK.  Otherwise the protections in
// place to prevent invalid values will deny your attempt
// to change some of the values:
SET KUNIVERSE:DEFAULTLOADDISTANCE:SPLASHED:UNLOAD TO 30000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:SPLASHED:LOAD TO 29500.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
SET KUNIVERSE:DEFAULTLOADDISTANCE:SPLASHED:PACK TO 29999.
SET KUNIVERSE:DEFAULTLOADDISTANCE:SPLASHED:UNPACK TO 29000.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
```

### Change Settings for Launch Pad/Runway

```
// 30 km for being on the launchpad or runway
// Note the order is important.  set UNLOAD BEFORE LOAD,
// and PACK before UNPACK.  Otherwise the protections in
// place to prevent invalid values will deny your attempt
// to change some of the values:
SET KUNIVERSE:DEFAULTLOADDISTANCE:PRELAUNCH:UNLOAD TO 30000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:PRELAUNCH:LOAD TO 29500.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
SET KUNIVERSE:DEFAULTLOADDISTANCE:PRELAUNCH:PACK TO 29999.
SET KUNIVERSE:DEFAULTLOADDISTANCE:PRELAUNCH:UNPACK TO 29000.
WAIT 0.001. // See paragraph above: "wait between load and pack changes"
```
</content>
