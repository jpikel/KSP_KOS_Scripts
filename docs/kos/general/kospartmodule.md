> Source: https://ksp-kos.github.io/KOS/general/kospartmodule.html (mirrored offline copy for local reference)

# KOS Processor PartModule Configuration Fields

## Overview

The kOS documentation explains configuration settings for the kOSProcessor module, which can be added to parts via ModuleManager or direct part.cfg editing.

## Key Configuration Fields

**diskSpace**
- Type: integer
- Default: 1024
- Controls the default disk space available, adjustable via VAB slider (1x, 2x, or 4x multipliers)

**baseDiskSpace**
- Type: integer
- Default: copies from diskSpace
- Sets the minimum disk space at the lowest slider position

**ECPerInstruction**
- Type: float
- Default: 0.000004
- "How much ElectricCharge resource is consumed per instruction the program executes." At 25 updates/second with 200 instructions per update, this example yields 0.02 EC per second.

**ECPerBytePerSecond**
- Type: float
- Default: 0.0
- Electricity consumption based on total available disk space (used + free)

**diskSpaceCostFactor**
- Type: float
- Default: 0.0244140625
- Additional cost per byte when expanding storage via editor tweakables

**baseModuleCost**
- Type: float
- Default: 0.0
- Base cost contribution from the kOSProcessor module itself

**diskSpaceMassFactor**
- Type: float
- Default: 0.0000048829
- Additional mass per byte when expanding storage (approximately 0.02kg per 4096 bytes)

**baseModuleMass**
- Type: float
- Default: 0.0
- Base mass contribution from the module

## Example Configuration

```
MODULE
{
    name = kOSProcessor
    diskSpace = 5000
    ECPerBytePerSecond = 0
    ECPerInstruction = 0.000004
}
```
