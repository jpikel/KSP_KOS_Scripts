> Source: https://ksp-kos.github.io/KOS/structures/vessels/sciencecontainermodule.html (mirrored offline copy for local reference)

# ScienceContainerModule

The kOS documentation describes "the type of structures returned by kOS when querying a module that stores science experiments."

## Structure Definition

`ScienceContainerModule` is a subtype of `PartModule` with the following members:

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of `PartModule` | — | Inherits all parent type functionality |
| `DUMPDATA(DATA)` | Method | Discard the experiment |
| `COLLECTALL()` | Method | Run the "collect all" action directly |
| `HASDATA` | Boolean | Does this part contain experiments |
| `DATA` | List of `ScienceData` | List of scientific data obtained by this experiment |

## Methods

### DUMPDATA(DATA)

Invoke this method to discard a particular experiment data entry.

### COLLECTALL()

Invoke this method to execute the unit's "collect all" action.

## Attributes

### HASDATA

- **Access:** Get only
- **Type:** Boolean
- **Description:** Returns true if this container stores scientific data.

### DATA

- **Access:** Get only
- **Type:** List of `ScienceData`
- **Description:** Provides the collection of scientific data contained within this part.

---

**Note:** This structure inherits all capabilities from `PartModule`, enabling access to additional functionality beyond what is documented here.
