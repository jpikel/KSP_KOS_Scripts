> Source: https://ksp-kos.github.io/KOS/structures/vessels/rcs.html (mirrored offline copy for local reference)

# RCS — kOS 1.4.0.0 Documentation

## Overview

The RCS structure represents reaction control system thrusters in kOS. You can retrieve RCS parts using `LIST RCS` command:

```
LIST RCS IN myVariable.
FOR rcs IN myVariable {
    print "An rcs thruster exists with ISP = " + rcs:ISP.
}
```

## Structure: RCS

RCS objects are a type of `Part` and inherit all Part suffixes.

### Attributes and Methods

| Suffix | Type | Description |
|--------|------|-------------|
| `ENABLED` | Boolean | Get/Set - Is this thruster enabled |
| `YAWENABLED` | Boolean | Get/Set - Is yaw control enabled |
| `PITCHENABLED` | Boolean | Get/Set - Is pitch control enabled |
| `ROLLENABLED` | Boolean | Get/Set - Is roll control enabled |
| `FOREENABLED` | Boolean | Get/Set - Is fore/aft control enabled |
| `STARBOARDENABLED` | Boolean | Get/Set - Is port/starboard control enabled |
| `TOPENABLED` | Boolean | Get/Set - Is dorsal/ventral control enabled |
| `FOREBYTHROTTLE` | Boolean | Get/Set - Does this thruster apply fore thrust when throttled |
| `FULLTHRUST` | Boolean | Get/Set - Does this thruster always apply full thrust |
| `THRUSTLIMIT` | Scalar (%) | Get/Set - Tweaked thrust limit (0-100) |
| `DEADBAND` | Scalar | Get/Set* - Game's built-in RCS input null zone (default: 0.05) |
| `MAXTHRUST` | Scalar (kN) | Get only - Untweaked thrust limit |
| `MAXTHRUSTAT(pressure)` | Scalar (kN) | Max thrust at specified pressure (ATMs) |
| `THRUST` | Scalar (kN) | Get only - Current thrust being applied |
| `AVAILABLETHRUST` | Scalar (kN) | Get only - Available thrust at current limit and pressure |
| `AVAILABLETHRUSTAT(pressure)` | Scalar (kN) | Available thrust at specified pressure |
| `MAXFUELFLOW` | Scalar (units/s) | Get only - Max volumetric fuel flow rate |
| `MAXMASSFLOW` | Scalar (Mg/s) | Get only - Max mass fuel flow rate |
| `ISP` | Scalar | Get only - Specific impulse at current pressure |
| `ISPAT(pressure)` | Scalar | Specific impulse at given pressure |
| `VACUUMISP` | Scalar | Get only - Vacuum specific impulse |
| `VISP` | Scalar | Get only - Synonym for VACUUMISP |
| `SEALEVELISP` | Scalar | Get only - Specific impulse at Kerbin sea level |
| `SLISP` | Scalar | Get only - Synonym for SEALEVELISP |
| `FLAMEOUT` | Boolean | Get only - Is thruster starved of resources |
| `THRUSTVECTORS` | List of Vectors | Get only - Unit vectors of possible thrust directions (Ship-Raw coordinates) |
| `CONSUMEDRESOURCES` | Lexicon | Get only - Resources consumed, keyed by name |

## Important Notes

**THRUSTLIMIT:** Must be between 0-100. Set as percentage (e.g., 50.0 for half thrust, not 0.5). The in-game UI rounds to nearest 0.5 when opened.

**DEADBAND:** The default 0.05 value prevents RCS response to control inputs below this threshold. To use smaller inputs, pulse the input intermittently rather than setting this value lower.

⚠️ **Warning:** Setting DEADBAND uses reflection to bypass private KSP fields and may break in future KSP versions. Setting it too small causes SAS to waste propellant.

**MAXTHRUSTAT/AVAILABLETHRUSTAT:** Pressure parameter uses standard Kerbin atmospheres (0.0 = vacuum, 1.0 = sea level).

**THRUSTVECTORS:** Returns unit-length vectors in Ship-Raw coordinates, not relative to ship orientation.
