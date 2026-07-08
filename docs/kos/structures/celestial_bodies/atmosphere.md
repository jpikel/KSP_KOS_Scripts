> Source: https://ksp-kos.github.io/KOS/structures/celestial_bodies/atmosphere.html (mirrored offline copy for local reference)

# Atmosphere — kOS 1.4.0.0 Documentation

## Overview

The `Atmosphere` structure provides information about a celestial body's atmospheric properties. It's closely tied to the `Body` structure and is typically obtained through a body's `:ATM` suffix.

## Accessing Atmosphere Data

### BODYATMOSPHERE(name) Function

This function accepts a string parameter representing a body's name and returns that body's atmosphere object. It's equivalent to calling `BODY(name):ATM` but requires fewer steps. The function will generate an error if the specified body doesn't exist.

## Structure Reference

All attributes are read-only.

| Suffix | Type | Description |
|--------|------|-------------|
| `BODY` | String | Name of the celestial body |
| `EXISTS` | Boolean | True if the body has an atmosphere |
| `OXYGEN` | Boolean | True if oxygen is present |
| `SEALEVELPRESSURE` | Scalar (atm) | Pressure at sea level |
| `ALTITUDEPRESSURE(altitude)` | Scalar (atm) | Pressure at given altitude |
| `HEIGHT` | Scalar (m) | Advertised atmospheric height |
| `MOLARMASS` | Scalar (kg/mol) | Molecular mass of atmosphere gas |
| `ADIABATICINDEX` | Scalar | Adiabatic index of atmosphere gas |
| `ADBIDX` | Scalar | Short alias for `ADIABATICINDEX` |
| `ALTITUDETEMPERATURE(altitude)` | Scalar | Temperature estimate at altitude |
| `ALTTEMP(altitude)` | Scalar | Short alias for `ALTITUDETEMPERATURE` |

## Detailed Attributes

**BODY**: Returns the atmosphere's celestial body name as a string, not as a Body object.

**EXISTS**: Indicates whether this represents a real atmosphere or a dummy placeholder.

**OXYGEN**: Determines if the air contains oxygen for jet engine intake compatibility.

**SEALEVELPRESSURE**: Returns pressure in atmospheres (where 1.0 = Kerbin/Earth standard). Multiply by `Constant:AtmToKPa` to convert to kilopascals.

**ALTITUDEPRESSURE(altitude)**: Calculates atmospheric pressure at specified altitude in meters above sea level. Returns zero for bodies without atmospheres or altitudes exceeding maximum atmospheric height. Results are in atmospheres.

**HEIGHT**: The official advertised altitude where the atmosphere ends (actual atmospheric falloff differs).

**MOLARMASS**: Gas molecular mass in kg/mol.

**ADIABATICINDEX**: The adiabatic index (heat capacity ratio) of the atmospheric gas.

**ALTITUDETEMPERATURE(altitude)**: Provides approximate atmospheric temperature at given altitude. Results vary based on sun position, latitude, and time of day.

## Deprecated

**SCALE**: A mathematical constant formerly used in atmosphere density calculations. Deprecated since version 0.17.2 due to KSP 1.0 atmospheric mechanics changes.
