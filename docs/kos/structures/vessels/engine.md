> Source: https://ksp-kos.github.io/KOS/structures/vessels/engine.html (mirrored offline copy for local reference)

# Engine Structure Documentation - kOS 1.4.0.0

## Overview

The `Engine` structure represents rocket engines and similar propulsion components accessible through kOS scripting in Kerbal Space Program. Engines can be retrieved via `LIST ENGINES` command and inherit all properties from the `Part` structure.

## Basic Usage Example

```
LIST ENGINES IN myVariable.
FOR eng IN myVariable {
    print "An engine exists with ISP = " + eng:ISP.
}
```

## Members Table

| Suffix | Type | Description |
|--------|------|-------------|
| `ACTIVATE` | Method | Turn engine on |
| `SHUTDOWN` | Method | Turn engine off |
| `THRUSTLIMIT` | Scalar (%) | Tweaked thrust limit |
| `MAXTHRUST` | Scalar (kN) | Untweaked thrust limit. Zero if disabled |
| `MAXTHRUSTAT(pressure)` | Scalar (kN) | Max thrust at specified pressure |
| `THRUST` | Scalar (kN) | Current thrust output |
| `AVAILABLETHRUST` | Scalar (kN) | Available thrust accounting for limiter |
| `AVAILABLETHRUSTAT(pressure)` | Scalar (kN) | Available thrust at specified pressure |
| `POSSIBLETHRUST` | Scalar (kN) | Possible thrust when enabled |
| `POSSIBLETHRUSTAT(pressure)` | Scalar (kN) | Possible thrust at specified pressure |
| `FUELFLOW` | Scalar (unit/s) | Current volumetric fuel consumption |
| `MAXFUELFLOW` | Scalar (unit/s) | Max volumetric flow at full throttle |
| `MASSFLOW` | Scalar (Mg/s) | Current mass fuel consumption |
| `MAXMASSFLOW` | Scalar (Mg/s) | Max mass flow at full throttle |
| `ISP` | Scalar | Specific impulse at current conditions |
| `ISPAT(pressure)` | Scalar | ISP at given pressure |
| `VACUUMISP` / `VISP` | Scalar | Vacuum specific impulse |
| `SEALEVELISP` / `SLISP` | Scalar | Sea-level specific impulse |
| `FLAMEOUT` | Boolean | Engine starved of resources |
| `IGNITION` | Boolean | Engine currently ignited |
| `ALLOWRESTART` | Boolean | Can engine be restarted |
| `ALLOWSHUTDOWN` | Boolean | Can engine be shut down |
| `THROTTLELOCK` | Boolean | Throttle fixed (e.g., solid boosters) |
| `MULTIMODE` | Boolean | Engine has multiple modes |
| `MODES` | List | List of mode names |
| `MODE` | String | Current mode name |
| `TOGGLEMODE()` | Method | Switch engine mode |
| `PRIMARYMODE` | Boolean | In primary mode (get/set) |
| `AUTOSWITCH` | Boolean | Auto-mode switching enabled (get/set) |
| `HASGIMBAL` | Boolean | Engine has gimbal |
| `GIMBAL` | Gimbal | Gimbal reference |
| `ULLAGE` | Boolean | Requires ullage (RealFuels) |
| `FUELSTABILITY` | Scalar | Fuel stability 0-1 (RealFuels) |
| `PRESSUREFED` | Boolean | Pressure-fed engine (RealFuels) |
| `IGNITIONS` | Scalar | Remaining ignitions (RealFuels) |
| `MINTHROTTLE` | Scalar | Minimum throttle 0-1 (RealFuels) |
| `CONFIG` | String | Engine configuration name (RealFuels) |
| `CONSUMEDRESOURCES` | Lexicon | Fuel consumption ratios |

## Key Attributes & Methods

**Engine:THRUSTLIMIT**
- Get/Set percentage (0-100, not 0-1)
- Clamped to valid range
- Note: GUI displays round to nearest 0.5

**Engine:MAXTHRUST**
- Get only; reads zero if disabled
- Varies with atmospheric pressure and velocity
- Jet engines affected by airspeed

**Engine:MAXTHRUSTAT(pressure)**
- Parameter: pressure in standard Kerbin atmospheres (0=vacuum, 1=sea level)
- Negative pressures treated as zero

**Engine:THRUST**
- Current instantaneous thrust output

**Engine:AVAILABLETHRUST**
- Accounts for thrust limiter setting
- Zero if engine disabled

**Engine:POSSIBLETHRUST**
- Accounts for thrust limiter
- Nonzero even when engine disabled

**Engine:FUELFLOW / Engine:MASSFLOW**
- Volumetric and mass consumption rates
- Current instantaneous values

**Engine:ISP Variants**
- `ISP`: Current pressure-dependent value
- `ISPAT(pressure)`: At specified pressure
- `VACUUMISP`/`VISP`: Vacuum value
- `SEALEVELISP`/`SLISP`: Kerbin sea-level value

**Engine:FLAMEOUT**
- True if fuel/oxidizer/oxygen starved

**Engine:IGNITION**
- True if currently ignited
- Combined with FLAMEOUT: can restart if resources available

**Engine:ALLOWRESTART / Engine:ALLOWSHUTDOWN**
- False for solid boosters
- Usually True for other engines

**Engine:THROTTLELOCK**
- True for fixed-throttle engines (solid boosters)

**Engine:MULTIMODE**
- Check before accessing mode-specific suffixes

**Engine:MODES**
- Returns list of mode names
- Single-mode engines return `["Single mode"]`

**Engine:MODE**
- Current mode name (multimode only)

**Engine:TOGGLEMODE()**
- Switch between modes (multimode only)

**Engine:PRIMARYMODE**
- Get/Set boolean for mode selection (multimode only)
- Setting toggles mode

**Engine:AUTOSWITCH**
- Get/Set for auto vs. manual mode switching (multimode only)

**Engine:HASGIMBAL**
- Boolean check before accessing `GIMBAL`

**Engine:GIMBAL**
- Returns Gimbal structure reference
- Only accessible if gimbal present

**RealFuels-Specific Attributes**
- `ULLAGE`: Static requirement property
- `FUELSTABILITY`: 0-1 value; 1 = fully stable (pressure-fed may return <1)
- `PRESSUREFED`: Boolean identification
- `IGNITIONS`: Remaining count or -1 (unlimited)
- `MINTHROTTLE`: 0-1 range minimum throttle
- `CONFIG`: Configuration identifier

**Engine:CONSUMEDRESOURCES**
- Lexicon mapping resource names to ConsumedResource objects
- Defines fuel consumption ratios

---

*Note: Engine is a Part subtype and inherits all Part suffixes. Only unique Engine suffixes are documented above.*
