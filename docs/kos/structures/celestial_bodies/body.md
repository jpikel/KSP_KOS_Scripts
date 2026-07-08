> Source: https://ksp-kos.github.io/KOS/structures/celestial_bodies/body.html (mirrored offline copy for local reference)

# Body Structure Documentation

## Overview

The Body structure represents any planet or moon in kOS. You can reference a body using `BODY("name")` or by using its predefined variable name (e.g., `Mun`, `Kerbin`).

Bodies inherit all suffixes from the `Orbitable` structure.

## Functions

### BODY(name)

Creates a reference to a celestial body by name:

```
SET MY_VAR TO BODY("Mun").
```

Body names are available as predefined variables, so `Mun` and `BODY("Mun")` are equivalent.

**Note:** If a mod introduces a body name matching an existing kOS variable, that body can only be accessed via `BODY(name)`.

### BODYEXISTS(name)

Boolean function to check if a body exists:

```
SET MUN_EXISTS TO BODYEXISTS("Mun").
IF MUN_EXISTS PRINT "Mun Exists." ELSE PRINT "Mun does not exist.".
```

## Predefined Celestial Bodies

The stock solar system bodies include:
- Sun
- Moho
- Eve (with Gilly)
- Kerbin (with Mun, Minmus)
- Duna (with Ike)
- Jool (with Laythe, Vall, Tylo, Bop, Pol)
- Eeloo

## Body Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| NAME | String | The body's name (e.g., "Mun") |
| DESCRIPTION | String | Longer body description |
| MASS | Scalar (kg) | Mass in kilograms |
| HASOCEAN | Boolean | Whether the body has an ocean |
| HASSOLIDSURFACE | Boolean | Whether the body has a solid surface |
| ORBITINGCHILDREN | List | Bodies orbiting this body |
| ALTITUDE | Scalar (m) | Altitude above parent body's sea level |
| ROTATIONPERIOD | Scalar (s) | Sidereal rotation period in seconds |
| RADIUS | Scalar (m) | Radius from center to sea level |
| MU | Scalar (m³/s²) | Gravitational parameter |
| ATM | Atmosphere | Atmospheric properties |
| ANGULARVEL | Vector (SHIP-RAW) | Angular velocity vector of rotation |
| SOIRADIUS | Scalar (m) | Sphere of influence radius |
| ROTATIONANGLE | Scalar (deg) | Degrees between Solar Prime Vector and prime meridian |

## Methods

### GEOPOSITIONOF(vectorPos)

Returns the geographic coordinates beneath a given position vector:

```
SHIP:BODY:GEOPOSITIONOF(SHIP:POSITION)
SHIP:BODY:GEOPOSITIONOF(SHIP:POSITION + 1000*SHIP:NORTH)
```

### GEOPOSITIONLATLNG(latitude, longitude)

Returns GeoCoordinates for specified latitude and longitude values.

### ALTITUDEOF(vectorPos)

Returns altitude of a position above the body's sea level:

```
SHIP:BODY:ALTITUDEOF(SHIP:POSITION)
Eve:ALTITUDEOF(GILLY:POSITION)
```

## Notes

The Body type is serializable. Angular velocity is expressed in radians (not degrees) for consistency with `VESSEL:ANGULARMOMENTUM`.
