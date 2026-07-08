> Source: https://ksp-kos.github.io/KOS/structures/vessels/dockingport.html (mirrored offline copy for local reference)

# DockingPort Documentation

## Overview

The `DockingPort` structure represents docking ports in kOS. These parts can be retrieved via `LIST PARTS` commands or by selecting a docking port as a target.

## Structure Definition

`DockingPort` is a subtype of `Decoupler` (which extends `Part`), inheriting all parent suffixes.

## Attributes and Methods

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| ACQUIRERANGE | Scalar | Get | Range at which port detects another port |
| ACQUIREFORCE | Scalar | Get | Force magnitude during docking |
| ACQUIRETORQUE | Scalar | Get | Rotational force during docking |
| REENGAGEDDISTANCE | Scalar | Get | Distance required after undocking to re-enable |
| DOCKEDSHIPNAME | String | Get | Name of docked vessel |
| NODEPOSITION | Vector | Get | Attachment point coordinates (SHIP-RAW frame) |
| NODETYPE | String | Get | Compatibility identifier for docking |
| PORTFACING | Direction | Get | Port facing direction |
| STATE | String | Get | Current port status |
| PARTNER | DockingPort or "None" | Get | Connected docking port |
| HASPARTNER | Boolean | Get | Whether port is attached |
| TARGETABLE | Boolean | Get | Whether port can be targeted |
| UNDOCK() | Method | Call | Detaches the docking port |

## Node Type Values

Stock KSP uses three standard node types:
- "size0" — Junior-sized ports
- "size1" — Normal-sized ports  
- "size2" — Senior-sized ports

## State Values

- `Ready` — Not attached, will dock on contact
- `Docked (docker)` — Docker role in active docking pair
- `Docked (dockee)` — Dockee role in active docking pair
- `Docked (same vessel)` — Alternate docked state
- `Disabled` — Refuses to dock
- `PreAttached` — Magnetic contact phase before solid docking
