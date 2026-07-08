> Source: https://ksp-kos.github.io/KOS/commands/flight/systems.html (mirrored offline copy for local reference)

# Ship Systems — kOS 1.4.0.0 Documentation

## Control Reference

The coordinate system for ship control is determined by a "control from" part on the vessel. Every ship must have at least one such part. You can change it using the `Part:CONTROLFROM` method and retrieve the current control part via `Vessel:CONTROLPART`.

## RCS and SAS

### RCS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Turns RCS on or off (equivalent to pressing `R`):
```
RCS ON.
RCS OFF.
PRINT RCS.
```

### SAS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Turns SAS on or off (equivalent to pressing `T`):
```
SAS ON.
SAS OFF.
PRINT SAS.
```

⚠️ **Warning:** SAS conflicts with cooked control (lock steering). Do not use both simultaneously.

### SASMODE
- **Access:** Get/Set
- **Type:** String

Returns or sets the current SAS mode. Valid values: `"PROGRADE"`, `"RETROGRADE"`, `"NORMAL"`, `"ANTINORMAL"`, `"RADIALOUT"`, `"RADIALIN"`, `"TARGET"`, `"ANTITARGET"`, `"MANEUVER"`, `"STABILITYASSIST"`, `"STABILITY"`.

```
SET SASMODE TO value.
```

**Notes:**
- SAS mode resets to stability assist when SAS is toggled on; skip a frame before setting mode
- Does not work with RemoteTech
- Should not be used with LOCK STEERING

### NAVMODE
- **Access:** Get/Set
- **Type:** String

Returns or sets the nav ball speed display mode. Valid values: `"ORBIT"`, `"SURFACE"`, `"TARGET"`.

```
SET NAVMODE TO value.
```

Only accessible for the active vessel.

## Stock Action Groups

Action groups are Boolean values that can be read to determine state and toggled. Reading values allows user input detection:

```
IF RCS PRINT "RCS is on".
ON ABORT { PRINT "Aborting!". }
```

The `TOGGLE` command switches a value to its opposite. These are equivalent:
```
TOGGLE AG1.
SET AG1 TO NOT AG1.
```

Action groups can be set with ON/OFF commands or by setting Boolean values:
```
SAS ON.
SET SAS TO TRUE.
SET GEAR TO ALT:RADAR<1000.
SET LIGHTS TO GEAR.
SET BRAKES TO NOT BRAKES.
```

**Notes:**
- Pressing an action group key toggles it; use stored "last value" or ON Trigger for user input detection
- Assigned actions only react to state changes; calling `GEAR ON` when already on has no effect
- Some actions respond differently to toggle on/off

### LIGHTS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Turns lights on or off (equivalent to `U` key):
```
LIGHTS ON.
```

### BRAKES
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Turns brakes on or off:
```
BRAKES ON.
```

### GEAR
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Deploys or retracts landing gear (equivalent to `G` key):
```
GEAR ON.
```

### ABORT
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Abort action group (equivalent to `Backspace` key):
```
ABORT ON.
```

### AG1 ... AG10
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

10 custom action groups:
```
AG1 ON.
AG4 OFF.
SET AG10 to AG3.
```

## kOS Pseudo Action Groups

kOS provides Boolean flags that work like stock action groups but are not manually configurable in the VAB. They automatically affect all parts of the corresponding type:

```
PANELS ON.
IF BAYS PRINT "Payload/service bays are ajar!".
SET RADIATORS TO LEGS.
```

Key difference: values depend directly on associated part states, not stored values. Both ON and OFF commands work independently of initial state. The return value may not match the set value immediately due to animations.

### LEGS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Deploys or retracts landing legs:
```
LEGS ON.
```

Returns true if all legs are deployed.

### CHUTES
- **Access:** Toggle ON; get/set
- **Type:** Action Group, Boolean

Deploys all parachutes (only ON command has effect):
```
CHUTES ON.
```

Returns true if all chutes are deployed.

### CHUTESSAFE
- **Access:** Toggle ON; get/set
- **Type:** Action Group, Boolean

Deploys parachutes that can be safely deployed in current conditions (only ON command has effect):
```
CHUTESSAFE ON.
```

Returns false only if disarmed parachutes may be safely deployed; true if all safe parachutes are deployed or none are available. Example:
```
WHEN (NOT CHUTESSAFE) THEN {
    CHUTESSAFE ON.
    RETURN (NOT CHUTES).
}
```

### PANELS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Extends or retracts deployable solar panels:
```
PANELS ON.
```

Returns true if all panels are extended, including those inside fairings or cargo bays.

**Note:** Some solar panels cannot be retracted once deployed.

### RADIATORS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Extends or retracts deployable radiators and activates/deactivates fixed ones:
```
RADIATORS ON.
```

Returns true if all radiators are extended and active.

### LADDERS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Extends or retracts extendable ladders:
```
LADDERS ON.
```

Returns true if all ladders are extended.

### BAYS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Opens or closes payload and service bays (including cargo ramp):
```
BAYS ON.
```

Returns true if at least one bay is open.

### DEPLOYDRILLS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Deploys or retracts mining drills:
```
DEPLOYDRILLS ON.
```

Returns true if all drills are deployed.

### DRILLS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Activates or stops mining drills (effect only on deployed drills in contact with minable surface):
```
DRILLS ON.
```

Returns true if at least one drill is actually mining.

### FUELCELLS
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Activates or deactivates fuel cells:
```
FUELCELLS ON.
```

Returns true if at least one fuel cell is activated.

### ISRU
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Activates or deactivates ISRU converters:
```
ISRU ON.
```

Returns true if at least one ISRU converter is activated.

### INTAKES
- **Access:** Toggle ON/OFF; get/set
- **Type:** Action Group, Boolean

Opens or closes air intakes:
```
INTAKES ON.
```

Returns true if all intakes are open.

## TARGET

### TARGET
- **Access:** Get/Set
- **Type:** String (set); Vessel, Body, or Part (get/set)

Sets the current target by name:
```
SET TARGET TO name.
```

To deselect the target:
```
SET TARGET TO "".
```

Using `UNSET TARGET` has no effect because built-in bound variables cannot be unset.

You can read properties of different vessels (e.g., `TARGET:THROTTLE`), but not all "set" or "lock" options work with vessels other than the current one due to authority restrictions.
