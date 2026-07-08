> Source: https://ksp-kos.github.io/KOS/structures/vessels/deltav.html (mirrored offline copy for local reference)

# DeltaV — kOS 1.4.0.0 Documentation

## Overview

The `DeltaV` structure contains information about delta-V calculations that the stock KSP game computes and displays in the staging interface. Two varieties exist: one for the entire vessel and one for individual stages.

### Accessing DeltaV Information

**Whole vessel:**
```
PRINT "Vessel's total dV number is " + SHIP:DELTAV:CURRENT.
```

**Specific stage:**
```
PRINT "The Current Stage dV number is " + SHIP:STAGEDELTAV(SHIP:STAGENUM):CURRENT.
PRINT "The Next Stage dV number is " + SHIP:STAGEDELTAV(SHIP:STAGENUM-1):CURRENT.
PRINT "The Next Stage dV number is " + SHIP:STAGEDELTAV(SHIP:STAGENUM-2):CURRENT.
```

**Current active stage (shorthand):**
```
STAGE:DELTAV
```

## Warning: Stock Numbers Aren't Totally Reliable

The stock delta-V system was designed for human viewing rather than programmatic decisions. Consider these limitations:

- Values require several update ticks to stabilize after staging events
- Natural fluctuations occur between update cycles (imperceptible in UI due to rounding)
- Complex staging techniques (like asparagus staging) may produce unreliable calculations
- Values apply to the currently active vessel; other vessels in range may show incorrect numbers

## DeltaV Structure

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `CURRENT` | Scalar (m/s) | Get only | Delta-V at current atmospheric conditions |
| `ASL` | Scalar (m/s) | Get only | Delta-V at sea level (1 ATM) conditions |
| `VACUUM` | Scalar (m/s) | Get only | Delta-V at vacuum conditions |
| `DURATION` | Scalar (seconds) | Get only | Burn duration at maximum thrust |
| `FORCECALC()` | (none) | method | Forces KSP to recalculate delta-V values |

### DeltaV:CURRENT

**Type:** Scalar (m/s)  
**Access:** Get only

Returns KSP's delta-V calculation assuming all burns occur at the ship's current atmospheric pressure. Matches the staging list display value. Only reliable for the active vessel.

### DeltaV:ASL

**Type:** Scalar (m/s)  
**Access:** Get only

Returns hypothetical delta-V if all burns occurred at 1 ATM. Corresponds to sea-level mode readouts in the editor. Only reliable for the active vessel.

### DeltaV:VACUUM

**Type:** Scalar (m/s)  
**Access:** Get only

Returns hypothetical delta-V if all burns occurred in vacuum. Corresponds to vacuum mode readouts in the editor. Only reliable for the active vessel.

### DeltaV:DURATION

**Type:** Scalar (seconds)  
**Access:** Get only

Returns KSP's estimated burn time at maximum thrust. Matches the staging list display.

### DeltaV:FORCECALC()

**Return type:** none (void)

Forces the game to recalculate delta-V by marking current values invalid. **Do not call repeatedly in loops or triggers,** as this causes performance degradation.

After calling, values will be inaccurate for several update ticks during recalculation. The calculation completes when `:ASL` or `:VACUUM` values stabilize (avoid `:CURRENT` for this check, as it naturally changes during ascent/descent). Minor fluctuations are expected due to floating-point precision in the simulation.
