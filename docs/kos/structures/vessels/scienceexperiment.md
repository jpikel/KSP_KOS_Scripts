> Source: https://ksp-kos.github.io/KOS/structures/vessels/scienceexperiment.html (mirrored offline copy for local reference)

# ScienceExperimentModule — kOS 1.4.0.0 Documentation

## Overview

The `ScienceExperimentModule` structure represents modules containing science experiments in kOS. It enables automated science tasks without user dialog intervention.

### Basic Usage Example

```kos
SET P TO SHIP:PARTSNAMED("GooExperiment")[0].
SET M TO P:GETMODULE("ModuleScienceExperiment").
M:DEPLOY.
WAIT UNTIL M:HASDATA.
M:TRANSMIT.
```

### Compatibility Notes

This structure works with stock science experiments. Some mods may be incompatible, including SCANsat. "DMagic Orbital Science has dedicated support in kOS and should work properly."

## Structure Reference

### Methods

| Method | Description |
|--------|-------------|
| `DEPLOY()` | Deploy and run the science experiment |
| `RESET()` | Reset this experiment if possible |
| `TRANSMIT()` | Transmit scientific data back to Kerbin |
| `DUMP()` | Discard the data |

### Attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `INOPERABLE` | Boolean | Get only - Is this experiment inoperable |
| `RERUNNABLE` | Boolean | Get only - Can this experiment be run multiple times |
| `DEPLOYED` | Boolean | Get only - Is this experiment deployed |
| `HASDATA` | Boolean | Get only - Does the experiment have scientific data |
| `DATA` | List of ScienceData | Get only - List of scientific data obtained |

## Method Details

**DEPLOY()** - Deploys and runs the experiment. Fails if data already exists or experiment is inoperable.

**RESET()** - Resets the experiment. Fails if inoperable.

**TRANSMIT()** - Transmits results to Kerbin. Renders non-rerunnable experiments inoperable. Fails if no data exists.

**DUMP()** - Discards obtained data.

### Note

`ScienceExperimentModule` inherits all suffixes from `PartModule`.
