> Source: https://ksp-kos.github.io/KOS/commands/flight.html (mirrored offline copy for local reference)

# Flight Control — kOS 1.4.0.0 Documentation

## Flight Control

This documentation section covers controlling spacecraft using kOS. Unless otherwise specified, all controls apply to the CPU Vessel.

### Overview

kOS provides three distinct control approaches:

**Cooked Control**
Specify a target direction and allow kOS to calculate the necessary maneuvers to achieve it.

**Raw Control**
Direct craft control similar to manual piloting via keyboard or joystick input.

**Pilot Input**
Stock KSP control methods, with state readable in KerboScript.

### Important Warning: SAS Interference

"SAS will tend to fight and/or override kOS's attempts to steer." To enable proper kOS steering functionality, you must disable SAS. Best practice involves explicitly setting `SAS OFF` at script initialization, or preserving the original SAS state for restoration upon completion.

### Related Sections

- [Cooked Control](flight/cooked.html)
- [Raw Control](flight/raw.html)
- [Pilot Input](flight/pilot.html)
- [Ship Systems](flight/systems.html)

---

*Documentation for kOS 1.4.0.0 | Copyright 2013-2021, kOS Team*
