> Source: https://ksp-kos.github.io/KOS/structures/vessels/stage.html (mirrored offline copy for local reference)

# Stage — kOS 1.4.0.0 Documentation

## Staging Example

A basic auto-stager implementation demonstrates the `:READY` attribute:

```
LIST ENGINES IN elist.

UNTIL false {
    PRINT "Stage: " + STAGE:NUMBER AT (0,0).
    FOR e IN elist {
        IF e:FLAMEOUT {
            STAGE.
            PRINT "STAGING!" AT (0,0).

            UNTIL STAGE:READY {
                WAIT 0.
            }

            LIST ENGINES IN elist.
            CLEARSCREEN.
            BREAK.
        }
    }
}
```

## Stage Function

**`STAGE`**

- **Return:** None
- **Description:** Activates the next stage when the CPU vessel is active. Triggers engines, decouplers, and other stage-activated parts. Equivalent to the spacebar. Both `STAGE.` and `STAGE().` are valid syntax.

**Note:** The function automatically pauses execution until the next tick, as some staging effects require physics recalculation.

**Warning:** "Calling the Stage function on a vessel other than the active vessel will throw an exception."

## Stage Structure

Provides information about the current vessel stage.

### Members

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `READY` | Boolean | Get only | Indicates if the craft is ready to activate the next stage |
| `NUMBER` | Scalar | Get only | Current stage number |
| `RESOURCES` | List | Get only | List of `AggregateResource` in current stage |
| `RESOURCESLEX` | Lexicon | Get only | Dictionary of `AggregateResource` values keyed by name String |
| `NEXTDECOUPLER` | Decoupler or String | Get only | Nearest decoupler to be activated (None if unavailable) |
| `NEXTSEPARATOR` | Decoupler or String | Get only | Alias for `NEXTDECOUPLER` |
| `DELTAV` | DeltaV | Get only | Delta-V information for current stage |

### Stage:READY

**Type:** Boolean | **Access:** Get only

KSP enforces a delay between staging commands. This boolean indicates whether kOS can activate the next stage.

### Stage:NUMBER

**Type:** Scalar | **Access:** Get only

Represents the current stage number for the craft.

### Stage:RESOURCES

**Type:** List | **Access:** Get only

Collection of available `AggregateResource` objects in the current stage.

### Stage:RESOURCESLEX

**Type:** Lexicon | **Access:** Get only

Dictionary-style collection of resources keyed by name String. String keys match `AggregateResource` names. Note: "This suffix walks the parts list entirely on every call, so it is recommended that you cache the value if it will be reference repeatedly."

### Stage:NEXTDECOUPLER

**Type:** Decoupler | **Access:** Get only

One of the nearest decoupler parts that will be activated by staging. Returns None if unavailable. Useful for advanced staging logic:

```
STAGE.
IF stage:nextDecoupler:isType("LaunchClamp")
    STAGE.
IF stage:nextDecoupler <> "None" {
    WHEN availableThrust \= 0 or (
        stage:resourcesLex\["LiquidFuel"\]:amount \= 0 and
        stage:resourcesLex\["SolidFuel"\]:amount \= 0)
    THEN {
        STAGE.
        return stage:nextDecoupler <> "None".
    }
}
```

### Stage:NEXTSEPARATOR

**Type:** Decoupler | **Access:** Get only

Alias for `NEXTDECOUPLER`.

### Stage:DELTAV

**Type:** DeltaV | **Access:** Get only

Returns delta-V information for the current stage:

```
// These two lines would do the same thing:
SET DV TO STAGE:DELTAV.
SET DV TO SHIP:STAGEDELTAV(SHIP:STAGRENUM).
```
