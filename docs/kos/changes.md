> Source: https://ksp-kos.github.io/KOS/changes.html (mirrored offline copy for local reference)

# kOS 1.4.0.0 Documentation: Changes from Version to Version

## Overview

This page documents significant documentation changes across kOS versions, excluding minor bug fixes and UI-only changes. For comprehensive change details, consult the GitHub repository and release announcements.

---

## Changes in 1.4.0.0

### CLOBBERBUILTINS

A bugfix preventing local variables from shadowing builtin names may require renaming variables in existing scripts. The compiler directive `@CLOBBERBUILTINS` restores previous behavior. However, renaming variables is recommended as better practice going forward.

Documentation now describes that comma-separated `LOCAL` and `SET` declaration statements support initializers.

### VESSEL SUFFIXES THRUST, ENGINES, RCS

Added three new vessel suffixes:
- `VESSEL:THRUST`
- `VESSEL:ENGINES`
- `VESSEL:RCS`

### OPCODESLEFT

Added `OPCODESLEFT` bound variable for monitoring available opcodes.

### BINARY MODE FILE READ

Added `FileContent:BINARY` attribute enabling reading binary files as lists of byte values (0-255).

### Function BODYATMOSPHERE

Documented the previously undocumented `BODYATMOSPHERE` function for obtaining atmosphere information about celestial bodies.

---

## Changes in 1.3

### Nodes with ETA or Universal Time

`NODE(time, radial, normal, prograde)` now accepts `TimeStamp` and `TimeSpan` inputs in addition to scalar seconds. Using `TimeSpan` indicates ETA time; otherwise UT time is assumed. New suffix `Node:TIME` reports UT time.

### TimeSpan Split into Two Types

The previous unified `TimeSpan` type was divided into separate `TimeStamp` and `TimeSpan` structures.

### Search on Sub-branches of a Vessel

Added `Part:PARTSTAGGED`, `Part:PARTSDUBBED`, and `Part:PARTSNAMED` suffixes for hierarchical part searching.

### Can Set the RCS Deadband

Added `RCS:DEADBAND` attribute for adjusting RCS deadband settings.

### SteeringManager Epsilon

Added `SteeringManager:TORQUEEPSILONMIN` and `SteeringManager:TORQUEEPSILONMAX` attributes for fine-tuning steering behavior.

### Random Seed

Added `RANDOMSEED(key, seed)` function for controlling random number generation.

### Suppress Autopilot

Added `Config:SUPPRESSAUTOPILOT` attribute to disable automatic pilot features.

### GET/SET Player's Trim

Added pilot trim controls:
- `PILOTYAWTRIM`
- `PILOTPITCHTRIM`
- `PILOROLLTRIM`
- `PILOTWHEELSTEERTRIM`
- `PILOTWHEELTHROTTLETRIM`

These enable trim adjustment without locking out manual control.

### Addon Trajectories Changes

Expanded documentation for Trajectories 2.4+ compatibility with numerous new features.

### Launch Craft Picking the Crew List

Added `KUniverse:LAUNCHCRAFTWITHCREWFROM(template, crewlist, site)` method.

### Asteroid-related Vessel Suffixes

Added `Vessel:STOPTRACKING` method and `Vessel:SIZECLASS` attribute.

### Stock Delta-V Info

Added delta-V calculation suffixes:
- `Vessel:DELTAV`
- `Vessel:DELTAVASL`
- `Vessel:DELTAVVACUUM`
- `Vessel:BURNTIME`
- `Stage:DELTAV`

### RCS Part Type

Introduced new part type for RCS thrusters.

### Engine Fuel Info

Added `Engine:CONSUMEDRESOURCE` providing `ConsumedResource` structures showing fuel consumption quantities.

### CreateOrbit from Position and Velocity

New `CREATEORBIT(pos, vel, body, ut)` variant creates orbits from state vectors instead of Keplerian elements.

### Ranges Take Fractional Numbers

`Range` objects now accept fractional values for start, stop, and step (previously integers only).

### Numerous Mistake Fixes

Multiple documentation corrections addressing typos and inaccurate descriptions across various GitHub pull requests.

---

## Changes in 1.2

### FLOOR and CEILING by Decimal Place

`FLOOR(a,b)` and `CEILING(a,b)` now accept optional parameters specifying decimal place cutoffs.

### Added ROLL to HEADING()

`HEADING(dir,pitch,roll)` adds optional third parameter for roll control.

### Bodyexists

New function `BODYEXISTS(name)` checks celestial body existence.

### Wordwrap on Labels

New `Style:WORDWRAP` attribute controls label word-wrapping behavior.

### CreateOrbit

Added `CREATEORBIT(inc, e, sma, lan, argPe, mEp, t, body)` function for creating orbits from Keplerian elements.

### Docking Port Partner Query

New suffixes:
- `DockingPort:PARTNER`
- `DockingPort:HASPARTNER`

### Waypoint ISSELECTED

Added `WayPoint:ISSELECTED` attribute.

---

## Changes in 1.1.9.0

### BOUNDING BOX

Introduced `BOUNDS` structure for bounding box information with tutorial examples.

### TERNARY OPERATOR "CHOOSE"

Implemented `CHOOSE` expression operator for conditional expressions (similar to C's "?" operator).

### New Suffixes for Vecdraw

Added appearance control suffixes:
- `Vecdraw:POINTY`
- `Vecdraw:WIPING`

### Lexicon Suffixes

Documented suffix usage with lexicon data structures.

### Terminal Default Size

Added configuration options:
- `Config:DEFAULTWIDTH`
- `Config:DEFAULTHEIGHT`

### Additional Atmospheric Information

Enhanced `Atmosphere` structure with:
- `MOLARMASS`
- `ADIABATICINDEX`
- `ALTITUDETEMPERATURE`

Added mathematical constants: `Avogadro`, `Boltzmann`, `IdealGas`.

### UNSET Documentation

Explicitly documented the previously undocumented `UNSET` command.

### LIST Command

Removed obsolete documentation for deprecated LIST variants.

### DROPPRIORITY()

Documented `DROPPRIORITY()` function for managing trigger execution without blocking other triggers.

---

## Changes in 1.1.8.0

Minor documentation corrections only; no new features documented.

---

## Changes in 1.1.7.0

### IR Next

Documentation updated to reference IR Next instead of older IR versions.

### CORE:TAG

Documented `CORE:TAG` attribute.

### TIME

Documented `TIME(universal_time)` function.

### PAUSE

Added `Kuniverse:PAUSE()` method for pausing gameplay.

### List Fonts

Added `FONTS` option to the `LIST` command.

---

## Changes in 1.1.6.2

GUI icon format changed from PNG to DDS; no documentation changes.

---

## Changes in 1.1.6.1

Thrust and ISP calculations clamp negative pressure values to zero; documentation updated accordingly.

---

## Changes in 1.1.6.0

### GUI Tooltips

Documented tooltip implementation through:
- `Label:TOOLTIP` attribute
- `GuiWidgets:TOOLTIP`
- `TIPDISPLAY`

### 5% Null Zone

Noted stock null zone issue affecting RCS translation.

### Part:CID

Added `Part:CID` suffix.

### An External Tutorial

Added external tutorial link to tutorials page.

### G and G0 Constants

Added `constant:G` and `constant:G0` constants.

### Removed Old Notices

Removed outdated version-related notices.

### Document Simulate in BG

Documented requirement for "Simulate in BG" when playing in windowed mode on telnet connections.

### Stage/Decouple Docs

Expanded stage and decoupler documentation for clarity.

### Vecdraw Delegate

Documented vecdraw constructor support for delegate parameters.

### Vector Math Link Changes

Updated external references for vector operation documentation.

### New Suffixes on Body Page

Enhanced `Body` page with `:HASOCEAN`, `:HASSURFACE`, and `:CHILDREN` suffixes.

### New Basic Tutorial

Introduced new basic tutorial page.

### Clarified CPU Hardware Page

Substantially revised CPU hardware documentation reflecting recent refactors.

---

## Changes in 1.1.5.2

Compatibility release for KSP 1.4.1.

---

## Changes in 1.1.5.0

Compatibility release for KSP 1.3.1.

---

## Changes in 1.1.4.0

Numerous source code optimizations improving performance, including regex engine optimization, string operation caching, and suffix information caching. Implemented dual-stack CPU architecture.

File scope modifications ensure local variables in called scripts don't affect global scope. Script parameters are now file-local.

Identifier information now embedded in opcodes for reduced execution time.

---

## Changes in 1.1.3.0

Enhanced SAS/lock steering conflict documentation. Fixed `Skin:ADD` documentation. Removed obsolete `TERMVELOCITY` references.

---

## Changes in 1.1.2

Dummy version increase to alert CKAN to version number correction from previous release.

---

## Changes in 1.1.1

Pure KSP 1.3 compatibility update with no feature changes.

---

## Changes in 1.1.0

### GUI

Introduced comprehensive GUI system.

### Terminal Font

Terminal now supports any OS font, enabling arbitrary Unicode character display.

### Regex Part Searches

Added `Vessel:PARTSTAGGEDPATTERN` for regular expression-based part searches.

### Triggers Take Locals

Removed restriction preventing local variable usage in trigger check expressions.

### Altitude Pressure

Added `Atmosphere:ALTITUDEPRESSURE` method.

### LATLNG of Other Body

Added `Body:GEOPOSITIONLATLNG` method for obtaining coordinates on non-current bodies.

---

## Changes in 1.0.3

No significant changes; compiled for KSP v1.2.2.

---

## Changes in 1.0.2

### Sound/Kerbal Interface Device (SKID)

New chip enabling procedural sound generation. Example:

```
SET V0 TO GETVOICE(0).
V0:PLAY( NOTE(400, 2.5) ).
```

Supports song examples and detailed documentation.

### CommNet Support

kOS now supports KSP stock CommNet alongside RemoteTech through abstracted interface, allowing third-party mod integration without kOS updates.

### Trajectories Support

Access Trajectories mod data via `ADDONS:TR`:

```
if ADDONS:TR:AVAILABLE {
    if ADDONS:TR:HASIMPACT {
        PRINT ADDONS:TR:IMPACTPOS.
    }
}
```

### Also Added

- `GeoCoordinates:VELOCITY` and `GeoCoordinates:ALTITUDEVELOCITY()`
- `String:TONUMBER()` method
- `SteeringManager:ROLLCONTROLANGLERANGE` attribute

---

## Changes in 1.0.1

### Terminal Input

New `TerminalInput` structure accessible via `Terminal:INPUT`:

```
terminal:input:clear().
print "Press any key...".
terminal:input:getchar().
print "Input will be echoed. Press q to quit".
set done to false.
until done {
    if (terminal:input:haschar) {
        set input to terminal:input:getchar().
        if input = "q" {
            set done to true.
        }
    }
    wait 0.
}
```

### Timewarp

New `TimeWarp` structure providing warp rate information:

```
print kuniverse:timewarp:ratelist.
set eta to 150 * 6 * 60 * 60.
kuniverse:timewarp:warpto(time:seconds + eta).
wait until kuniverse:timewarp:issettled.
```

---

## Changes in 1.0.0

### Subdirectories

Volumes now support subdirectories/folders. New file manipulation commands accommodate this feature.

#### Boot Subdirectory

Boot files now reside in `boot/` subdirectory within archive.

#### PATH Structure

New structure provides file path and location information.

#### New RUNPATH Command

`RUNPATH` command allows dynamic program path expressions.

### Communications

Inter-CPU and inter-vessel script communication enabled.

#### Message Structure

`Message` structure supports new communications system.

### Anonymous Functions

Anonymous function support implemented.

### Allow Scripted Vessel Launches

New `KUniverse` suffixes:
- `GETCRAFT()`
- `LAUNCHCRAFT()`
- `CRAFTLIST()`
- `LAUNCHCRAFTFROM()`

### ETA to SOI Change

Added `ORBIT:NEXTPATCHETA` for next orbit patch transition timing.

### VESSEL:CONTROLPART

New suffix reveals current "control from here" part.

### Maneuver Nodes as a List

Added `ALLNODES` bound variable.

### More Pseudo-Action-Groups

Expanded pseudo-action-group coverage for additional part categories.

### Get Navball Mode

`NAVMODE` bound variable provides navball mode information.

### UniqueSet

New `UniqueSet` collection type for unordered, duplicate-free element storage.

---

## Changes in 0.20.1

### 3-axis Gimbal Disabling

Engine gimbal control now allows selective axis locking through `PITCH`, `YAW`, and `ROLL` suffixes.

---

## Changes in 0.20.0

Functionally identical to v0.19.3, recompiled against KSP 1.1 release binaries.

---

## Changes in 0.19.3

### Interruptable Triggers

Triggers no longer require completion within single frame; enables longer-running triggers with reduced atomicity guarantees.

### Script Profiling

New profiling capabilities via `ProfileResult` structure for performance analysis.

### Compiled LOCK

Improved runtime flexibility for duplicate lock identifier handling in compiled scripts.

### ON Using Expressions

`ON` statement now evaluates expressions rather than treating them as variable identifiers:

```
ON STAGE:READY {
    PRINT "STAGE: " + STAGE:READY.
}
ON ROUND(MAX(2000, ALT:RADAR)) {
    PRINT ROUND(ALT:RADAR).
}
```

---

## Changes in 0.19.2

Primarily bug fixes; minimal documentation changes.

### FORCEACTIVE

Added `KUNIVERSE:FORCEACTIVE()` alias for `KUNIVERSE:FORCESETACTIVEVESSEL()`.

---

## Changes in 0.19.1

Minor bug fixes and documentation updates.

### Mentioned PIDLoop() Function in Tutorial

Enhanced PID loop tutorial explaining `PIDLoop` function.

### New Terminal Brightness and Character Size Features

Added `Terminal` suffixes:
- `TERMINAL:BRIGHTNESS`
- `TERMINAL:CHARWIDTH`
- `TERMINAL:CHARHEIGHT`

---

## Changes in 0.19.0

### Art Asset Changes

Numerous part model and artwork updates including new KAL9000 high-end computer part.

### Varying Power Consumption

Electrical drain now dynamically adjusts based on CPU utilization, consuming less power during idle periods. Drain factor configurable in part.cfg files.

### Delegates (Function Pointers)

User and built-in functions now support delegate references with argument currying.

### Optional Defaulted Parameters

User functions and programs support optional trailing parameters with defaults.

### File I/O

`VolumeFile` enables natural string reading/writing without LOG command; supports whole-file reads.

### Serialization in JSON

Automatic serialization system for saving/loading data values to JSON-format files.

### Universal Object Suffixes

All user values function as structures with universal suffixes `:ISTYPE` and `:TYPENAME`.

### Multimode Engine and Gimbal Support

Engines now support multiple-mode information accessible via `:GIMBAL` suffix.

### DMagic Orbital Science

Enhanced support for DMagic's Orbital Science mod.

### Range

New `Range` type provides arbitrary iterable integer range collections.

### Char and Unchar

`CHAR(a)` and `UNCHAR(a)` functions convert between Unicode values and characters.

### For Loop on String Chars

For loops now iterate over string characters.

### HASTARGET, HASNODE

New bound variables `HASTARGET` and `HASNODE` check for targets/nodes.

### JOIN

List suffix `JOIN` creates delimited strings from list elements.

### Hours Per Day

`KUniverse` provides user clock setting information (24-hour vs. Kerbin 6-hour days).

### Archive

Reserved word `Archive` now functions as first-class citizen:

```
SET FOO TO ARCHIVE.
```

---

## Changes in 0.18.2

### Queue and Stack

Implemented `Queue` and `Stack` collection types.

### Run Once

New `ONCE` argument for run command.

### Volumes and Processors Integration

Volumes receive default names from core processor nametags; multiple suffixes support volume querying.

### Debuglog

`KUNIVERSE:DEBUGLOG` suffix writes messages to Unity log file.

---

## Changes in 0.18.1

Bug fixes only; no documentation changes.

---

## Changes in 0.18 - Steering Much Betterer

### Steering Overhaul

Major cooked steering rewrite with auto-tuning system supporting torque-less craft. `SteeringManager` structure enables cooked steering system access/modification. `PIDLoop` structure borrows PID mechanism for custom applications.

### Lexicon

New associative array structure `Lexicon`.

### String Methods

New `String` structure provides string manipulation methods.

### Science Experiment Control

New `ScienceExperimentModule` enables bypassing experiment UI dialogs.

### Crew Member API

New `CrewMember` structure queries registered crew information (class, gender, skill).

### LOADDISTANCE

New `LOADDISTANCE` structure obsoletes previous implementation.

### Infernal Robotics Part Suffix

Enhanced Infernal Robotics support.

### Renamed Built-ins

- "AQUIRE" → "ACQUIRE" (docking ports)
- "SURFACESPEED" → "GROUNDSPEED"

### Enforces Control of Own-Vessel Only

Prevents script control of vessels unattached to running kOS computer.

### New Quickstart Tutorial

Comprehensive quickstart guide added.

### A Few More Constants

Additional mathematical constants documented.

### Dynamic Pressure

New `DYNAMICPRESSURE` or `Q` suffix for vessel objects.

### DEFINED Keyword

`DEFINED` keyword checks variable declaration status.

### KUNIVERSE

`KUniverse` structure enables script reversion and gameplay manipulation.

### SolarPrimeVector

`SOLARPRIMEVECTOR` bound variable provides universal longitude direction.

---

## Changes in 0.17.3

### New Looping Control Flow, the FROM Loop

Implemented three-part `FROM` loop structure (init, check, increment).

### Short-Circuit Booleans

`AND` and `OR` operators now employ short-circuit evaluation.

### New Infernal Robotics Interface

Enhanced IR mod helper utilities.

### New RemoteTech Interface

New `RTAddon` structure provides RemoteTech mod support.

### Deprecated INCOMMRANGE

`INCOMMRANGE` now throws deprecation exception; use `RTAddon` instead.

### Updated Thrust Calculations for 1.0.x

Revised thrust calculations accounting for KSP 1.0 atmospheric dependency:
- `MAXTHRUST`: Current atmospheric pressure maximum
- `AVAILABLETHRUST`: For engines and vessels
- `MAXTHRUSTAT`: Thrust at specified atmospheric pressure
- `AVAILABLETHRUSTAT`: Available thrust at specified pressure
- `ISPAT`: ISP at specified pressure

### New CORE Struct

`CORE` bound variable provides CPU property access including vessel part, parent vessel, and selected volume.

### Updated Boot File Name Handling

Boot files copied to local disk with original filenames. `CORE:BOOTFILENAME` suffix enables boot file access/modification.

### Docking Port, Element, and Vessel References

New `DOCKINGPORTS` suffix lists vessel docking ports. Vessels expose `ELEMENTS` suffix; elements reference parent vessel via `VESSEL` suffix.

### New Sounds and Terminal Features

Cosmetic enhancements:
- Terminal keyclick option for GUI terminal
- Beep on ASCII code 7 (BEL) via KSlib spec_char.ksm
- Exception sound effect (configurable)

### Clear Vecdraws All at Once

`CLEARVECDRAWS()` function clears all screen vecdraws simultaneously.

---

## Changes in 0.17.0

### Variables Can Now Be Local

Major architecture rework implementing block-scoped variables via `LOCAL` declarations.

### Kerboscript Has User Functions

New user function support enabled by local scope rework.

### Community Examples Library

Fledgling community example and library script repository established.

### Physics Ticks Not Update Ticks

Updates moved to physics timestep portion, improving performance uniformity across machines without penalizing faster computers.

### Ability to Use SAS Modes from KSP 0.90

Third ship control method via SAS mode specification (prograde, retrograde, normal, etc.).

### Blizzy ToolBar Support

Blizzy Toolbar mod integration for kOS control panel window.

### Ability to Define Colors Using HSV

Color definitions now support HSV (hue, saturation, value) alongside RGB.

### Ability to Highlight a Part in Color

Part highlighting feature enables visual part identification in scripts.

### Better User Interface for Selecting Boot Scripts

Improved boot script selection interface.

### Disks Can Be Made Bigger with Tweakable Slider

VAB/SPH editor sliders enable disk space adjustment (1x, 2x, 4x defaults) with associated cost/weight changes.

### You Can Transfer Resources

Script-controlled resource transfers between parts replicate manual user interface transfers.

### Kerbal Alarm Clock Support

Query and manipulate Kerbal Alarm Clock mod alarms from scripts.

### Query the Docked Elements of a Vessel

`ELEMENTS` suffix provides docked component collections.

### Support for Action Groups Extended

Significantly improved Action Groups Extended mod support.

### LIST Constructor Can Now Initialize Lists

Direct list initialization:

```
set mylist to list(2,6,1,6,21).
```

Eliminates need for sequential `list:ADD` commands.

### ISDEAD Suffix for Vessel

`VESSEL:ISDEAD` detects vessel destruction/removal.
