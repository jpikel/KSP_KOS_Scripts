> Source: https://ksp-kos.github.io/KOS/bindings.html (mirrored offline copy for local reference)

# Catalog of Bound Variable Names — kOS 1.4.0.0

## Overview

This documentation page lists special reserved keyword variables that kOS interprets with specific meanings. Understanding these bound variables is essential for creating effective kOS scripts.

## Named Vessels and Bodies

**SHIP**
- Gettable: yes | Settable: no
- Type: Vessel
- Description: "the one containing the CPU part that is running this Kerboscript code at the moment"

**TARGET**
- Gettable: yes | Settable: yes
- Type: Vessel, Body, or Part
- Description: The currently selected KSP target. Can be set to a string vessel name, or use Body() or Vessel() explicitly for best results.

**HASTARGET**
- Gettable: yes | Settable: no
- Type: boolean
- Description: Returns true if a target is selected

## Alias Shortcuts for SHIP Fields

The following are shortcuts for SHIP vessel properties:

| Variable | Equivalent |
|----------|-----------|
| HEADING | SHIP:HEADING |
| PROGRADE | SHIP:PROGRADE |
| RETROGRADE | SHIP:RETROGRADE |
| FACING | SHIP:FACING |
| MAXTHRUST | SHIP:MAXTHRUST |
| VELOCITY | SHIP:VELOCITY |
| GEOPOSITION | SHIP:GEOPOSITION |
| LATITUDE | SHIP:LATITUDE |
| LONGITUDE | SHIP:LONGITUDE |
| UP | SHIP:UP |
| NORTH | SHIP:NORTH |
| BODY | SHIP:BODY |
| ANGULARMOMENTUM | SHIP:ANGULARMOMENTUM |
| ANGULARVEL | SHIP:ANGULARVEL |
| ANGULARVELOCITY | SHIP:ANGULARVEL |
| MASS | SHIP:MASS |
| VERTICALSPEED | SHIP:VERTICALSPEED |
| GROUNDSPEED | SHIP:GROUNDSPEED |
| SURFACESPEED | Obsolete (use GROUNDSPEED) |
| AIRSPEED | SHIP:AIRSPEED |
| ALTITUDE | SHIP:ALTITUDE |
| APOAPSIS | SHIP:APOAPSIS |
| PERIAPSIS | SHIP:PERIAPSIS |
| SENSORS | SHIP:SENSORS |
| SRFPROGRADE | SHIP:SRFPROGRADE |
| SRFRETROGRADE | SHIP:SRFRETROGRADE |
| OBT | SHIP:OBT |
| STATUS | SHIP:STATUS |
| SHIPNAME | SHIP:NAME |

## Constants (pi, e, etc)

Get-only. The variable `constant` provides access to basic math and physics constants.

Example:
```
print "Kerbin's circumference: " + (2*constant:pi*Kerbin:radius) + "meters."
```

## Terminal

Get-only. `terminal` returns a terminal structure describing attributes of the current terminal screen.

## Core

Get-only. `core` returns a core structure referring to the CPU running the script.

## Archive

Get-only. `archive` returns a Volume structure referring to the archive.

## Stage

Get-only. `stage` returns a stage structure used to count resources in the current stage.

## NextNode

See NEXTNODE documentation.

## HasNode

See HASNODE documentation.

## AllNodes

See ALLNODES documentation.

## Resource Types

Resources queryable with SHIP, STAGE, or TARGET prefixes:

- LIQUIDFUEL
- OXIDIZER
- ELECTRICCHARGE
- MONOPROPELLANT
- INTAKEAIR
- SOLIDFUEL

Examples:
```
PRINT "There is " + SHIP:LIQUIDFUEL + " liquid fuel on the ship."
PRINT "There is " + STAGE:LIQUIDFUEL + " liquid fuel in this stage."
PRINT "There is " + TARGET:LIQUIDFUEL + " liquid fuel in the target ship."
```

Use `:RESOURCES` suffix to get a list of all resources.

## ALT Alias

The `ALT` variable provides altitude predictions:
- ALT:APOAPSIS
- ALT:PERIAPSIS
- ALT:RADAR

## ETA Alias

The `ETA` variable provides time predictions:
- ETA:APOAPSIS
- ETA:PERIAPSIS
- ETA:NEXTNODE
- ETA:TRANSITION

## ENCOUNTER

Returns an Orbit object describing the next body encounter, or the string "None" if no encounter is coming.

Example:
```
print ENCOUNTER:BODY:NAME.
```

## Boolean Toggle Flags

These boolean variables control ship systems and can be set with ON, OFF, and TOGGLE commands.

| Variable | Read | Set | Source | Purpose |
|----------|------|-----|--------|---------|
| SAS | yes | yes | stock | SAS action group |
| RCS | yes | yes | stock | RCS thrusters |
| GEAR | yes | yes | stock | Landing gear |
| LIGHTS | yes | yes | stock | Lights |
| BRAKES | yes | yes | stock | Brakes |
| ABORT | yes | yes | stock | Abort action group |
| LEGS | yes | yes | kOS | Landing legs state |
| CHUTES | yes | yes | kOS | Parachutes armed state |
| CHUTESSAFE | yes | yes | kOS | Safe parachutes armed state |
| PANELS | yes | yes | kOS | Solar panels state |
| RADIATORS | yes | yes | kOS | Radiators deployed state |
| LADDERS | yes | yes | kOS | Ladders extended state |
| BAYS | yes | yes | kOS | Payload/service bays state |
| INTAKES | yes | yes | kOS | Intakes opened state |
| DEPLOYDRILLS | yes | yes | kOS | Drills deployment state |
| DRILLS | yes | yes | kOS | Drills running state |
| FUELCELLS | yes | yes | kOS | Fuel cells running state |
| ISRU | yes | yes | kOS | Resource converters running state |
| AG1-AG10 | yes | yes | stock | Action groups 1-10 |
| AGn | yes | yes | AGX | ActionGroupsExtended groups |

## Flight Control

Bound variables for flight control are available through:
- **Cooked Control**: for automatic alignment to desired heading
- **Raw Control**: for direct control input manipulation
- **Pilot Input Reading**: for reading player control attempts

### Controls Using LOCK

```
THROTTLE            // Decimal value between 0 and 1
STEERING            // Direction or Vector
WHEELTHROTTLE       // Separate wheel throttle
WHEELSTEERING       // Separate wheel steering
```

## Time

### MISSIONTIME

Returns seconds since the CPU vessel launched. Equivalent to "Mission Elapsed Time" or "MET" in space programs.

### Time Structure

`TIME` returns simulated time since the game universe epoch. A brand new campaign begins at TIME zero.

Important note: Be aware of the "frozen update nature" of the kOS computer when reading TIME.

## System Variables

### Version Information

```
PRINT VERSION.            // Operating system version (e.g., 0.1.2.3)
PRINT VERSION:MAJOR.      // Major version number
PRINT VERSION:MINOR.      // Minor version number
PRINT VERSION:PATCH.      // Patch version number
PRINT VERSION:BUILD.      // Build version number
```

### Time Variables

```
PRINT SESSIONTIME.        // Seconds since vessel loaded from on-rails
```

**Key Difference**: SESSIONTIME is time since last vessel load; TIME is time since campaign start.

### HOMECONNECTION

Globally bound variable for the connection to "home".

### CONTROLCONNECTION

Globally bound variable for the connection to a control source.

### KUNIVERSE

A structure containing settings that control game simulation directly.

### CONFIG

Special variable for kOS mod configuration settings. Has its own documentation page.

### WARP and WARPMODE

Time warp can be controlled with these variables.

### MAPVIEW

Boolean, gettable and settable. True if on map screen, false if on flight view. Setting it switches between views.

### LOADDISTANCE

Sets the distance from active vessel at which vessels transition between full physics and on-rails. Applies universally to all situations in kOS.

## PROFILERESULT()

If `Config:STAT` is set to `True`, call `PROFILERESULT()` to see detailed profiling data of the most recent program run, formatted as comma-separated values (CSV) suitable for spreadsheet import.

Usage:
```
SET CONFIG:STAT TO TRUE.
RUN MYPROGRAM.
PRINT PROFILERESULT().
// or
LOG PROFILERESULT() TO SOMEFILENAME.csv.
```

## SOLARPRIMEVECTOR

Returns the Prime Meridian Vector for the Solar System in current Ship-Raw XYZ coordinates. Used as the reference point for orbital parameters like LONGITUDEOFASCENDINGNODE and ROTATIONANGLE.

### What is the Solar Prime Reference Vector?

An arbitrary vector in space used to measure orbital parameters that remain fixed to space regardless of planetary rotation. Similar to Earth's "First Point of Aries" reference used in astronomy.

## OPCODESLEFT

Returns the number of instructions remaining in the current physics tick before the game advances time and other systems run.

Usage example:
```
GLOBAL OPCODESNEEDED TO 1000.
IF OPCODESLEFT < OPCODESNEEDED
  WAIT 0.
LOCAL STARTIPU TO OPCODESLEFT.
LOCAL STARTTIME TO TIME:SECONDS.

// your code here

IF STARTTIME \= TIME:SECONDS {
  SET OPCODESNEEDED TO STARTIPU \- OPCODESLEFT.
} ELSE {
  PRINT "Code is taking too long to execute. Please make the code shorter or raise the IPU."
}
```

## Addons

Get-only. `addons` is a special variable for accessing extensions to kOS that support features from other mods.

## Colors

Several bound variables for hardcoded colors such as WHITE, BLACK, RED, etc., with a full list available on the colors reference page.
