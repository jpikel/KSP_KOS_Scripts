> Source: https://ksp-kos.github.io/KOS/structures/vessels/decoupler.html (mirrored offline copy for local reference)

# Decoupler

## Overview

The `Decoupler` structure represents decoupler parts that can be retrieved through the `LIST PARTS` command. As stated in the documentation, "It is a type of `Part`, and therefore can use all the suffixes of `Part`."

The structure serves as a base for multiple part types: decouplers, separators, launch clamps, and docking ports. According to the reference material, most decoupler parts actually belong to the `Separator` category, where additional functionality is documented.

## Structure Definition

**_structure_ Decoupler**

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of `Part` | — | A decoupler inherits all capabilities from the base `Part` structure |

## Notes

The documentation emphasizes that most useful suffixes for decoupler functionality are found in the `Separator` structure documentation rather than in the `Decoupler` structure itself. Users seeking detailed decoupler operations should reference the `Separator` documentation for comprehensive functionality details.
