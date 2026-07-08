> Source: https://ksp-kos.github.io/KOS/commands/list.html (mirrored offline copy for local reference)

# LIST Command — kOS 1.4.0.0 Documentation

## Overview

A `List` is a structure type that stores variables. The `LIST` command either prints or creates a `List` object containing items queried from the game.

## FOR Loop

Lists can be iterated using the FOR loop. The `LIST` command comes in three forms:

1. **`LIST.`** — Equivalent to `LIST FILES.` when no parameters are given.

2. **`LIST ListKeyword.`** — Prints items to the terminal screen based on the specified keyword.

3. **`LIST ListKeyword IN YourVariable.`** — Stores the list in a variable instead of printing to the terminal, allowing iteration with a FOR loop.

## Available Listable Keywords

### Universal Lists

- **`Bodies`** — List of celestial bodies
- **`Targets`** — List of possible target vessels
- **`Fonts`** — List of available font names for GUI styling

### Vessel Lists

- **`Processors`** — List of processors
- **`Resources`** — List of aggregate resources
- **`Parts`** — List of parts
- **`Engines`** — List of engines
- **`RCS`** — List of RCS thrusters
- **`Sensors`** — List of sensors
- **`Elements`** — List of elements comprising the current vessel
- **`DockingPorts`** — List of docking ports

### File System Lists

- **`Files`** — Items in current directory (files and subdirectories)
- **`Volumes`** — All available volumes

## Examples

```
LIST.
LIST FILES.
LIST VOLUMES.
LIST FILES IN fileList.

LIST BODIES.
LIST BODIES IN bodList.
SET totMass to 0.
FOR bod in bodList {
    SET totMass to totMass + bod:MASS.
}.
PRINT "The mass of the whole solar system is " + totMass.

LIST RESOURCES IN foo.
FOR res IN foo {
    PRINT res:NAME.
}.
```
