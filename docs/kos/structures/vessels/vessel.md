> Source: https://ksp-kos.github.io/KOS/structures/vessels/vessel.html (mirrored offline copy for local reference)

# Vessel Structure Documentation

The kOS documentation describes the **Vessel** structure, which represents all vessels in Kerbal Space Program. Here's a comprehensive overview:

## Accessing Vessels

Vessels can be retrieved through:
- `VESSEL("Ship Name")` - by name (case-sensitive)
- `SHIP` - current vessel
- `TARGET` - target vessel

## Core Characteristics

Vessels inherit from the **Orbitable** structure, gaining all its associated suffixes plus additional vessel-specific ones.

## Key Attributes & Methods

### Flight Control & Direction
- **CONTROL**: Raw flight controls (CPU vessel only)
- **BEARING**: Relative compass heading in degrees
- **HEADING**: Absolute compass heading in degrees
- **FACING**: Direction the vessel is pointing (Direction structure)

### Thrust Properties
- **THRUST**: Sum of active engine thrusts (kN)
- **MAXTHRUST**: Sum of maximum active thrusts (kN)
- **MAXTHRUSTAT(pressure)**: Maximum thrust at specified atmospheric pressure
- **AVAILABLETHRUST**: Sum of limited maximum thrusts (kN)
- **AVAILABLETHRUSTAT(pressure)**: Limited maximum thrust at pressure

### Mass & Physical Properties
- **MASS**: Current mass in metric tons
- **WETMASS**: Mass when fully fueled
- **DRYMASS**: Mass with no resources
- **BOUNDS**: Bounding box structure (computationally expensive)
- **ANGULARMOMENTUM**: Vector in SHIP_RAW frame
- **ANGULARVEL**: Angular velocity vector

### Velocity & Atmospheric Data
- **VERTICALSPEED**: Upward velocity (m/s)
- **GROUNDSPEED**: Horizontal velocity (m/s)
- **AIRSPEED**: Velocity relative to atmosphere (m/s)
- **DYNAMICPRESSURE** / **Q**: Atmospheric pressure in ATM units
- **TERMVELOCITY**: Terminal velocity (deprecated)

### Status & Identity
- **SHIPNAME** / **NAME**: Vessel name (get/set)
- **STATUS**: Current status (LANDED, SPLASHED, PRELAUNCH, FLYING, SUB_ORBITAL, ORBITING, ESCAPING, DOCKED)
- **TYPE**: Vessel type (get/set)
- **STAGENUM**: Current stage number
- **ISDEAD**: Boolean indicating if vessel no longer exists

### Delta-V Information
- **DELTAV**: Summed delta-v structure for entire vessel
- **STAGEDELTAV(num)**: Delta-v for specific stage
- **DELTAVASL**: Delta-v at sea level
- **DELTAVVACUUM**: Delta-v in vacuum
- **BURNTIME**: Total burn time in seconds

### Parts & Components
- **PARTS**: List of all parts
- **ENGINES**: List of all engines
- **RCS**: List of all RCS thrusters
- **DOCKINGPORTS**: List of all docking ports
- **ELEMENTS**: List of all elements
- **RESOURCES**: List of aggregate resources
- **ROOTPART**: First part in vessel tree
- **CONTROLPART**: Part serving as control reference

### Parts Filtering Methods
- **PARTSNAMED(name)**: Parts by NAME (case-insensitive)
- **PARTSNAMEDPATTERN(pattern)**: Parts by NAME regex
- **PARTSTITLED(title)**: Parts by TITLE (case-insensitive)
- **PARTSTITLEDPATTERN(pattern)**: Parts by TITLE regex
- **PARTSTAGGED(tag)**: Parts by TAG (case-insensitive)
- **PARTSTAGGEDPATTERN(pattern)**: Parts by TAG regex
- **PARTSDUBBED(name)**: Parts matching NAME, TITLE, or TAG
- **PARTSDUBBEDPATTERN(pattern)**: Regex across NAME, TITLE, TAG
- **MODULESNAMED(name)**: PartModules by name
- **PARTSINGROUP(group)**: Parts in action group
- **MODULESINGROUP(group)**: PartModules in action group
- **ALLTAGGEDPARTS()**: Parts with non-blank tags

### Crew & Personnel
- **CREWCAPACITY**: Available crew slots
- **CREW()**: List of all crew members aboard

### Tracking & Asteroids
- **STARTTRACKING()**: Begin tracking asteroid
- **STOPTRACKING()**: Stop tracking asteroid
- **SIZECLASS**: Asteroid size class (A-E or UNKNOWN)

### Loading & Communication
- **LOADED**: Boolean for physics engine loading status
- **UNPACKED**: Boolean indicating if parts are fully unpacked
- **LOADDISTANCE**: LoadDistance structure for loading behavior
- **SENSORS**: VesselSensors structure
- **PATCHES**: List of orbit patch objects
- **CONNECTION**: Communication connection structure
- **MESSAGES**: Message queue for vessel

## Important Notes

- The **BOUNDS** suffix is computationally expensive and forces a `WAIT 0` after execution
- **ANGULARMOMENTUM** and **ANGULARVEL** use radians (not degrees) for rotation rates
- Mass measurements use KSP's 1000x scaling factor
- Delta-v values use stock KSP calculations and inherent their accuracy limitations
- Load/unpack settings are not persistent across flight instances
