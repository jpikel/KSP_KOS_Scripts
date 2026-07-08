> Source: https://ksp-kos.github.io/KOS/addons.html (mirrored offline copy for local reference)

# Addon Reference

> "This section is for ways in which kOS has special case exceptions to its normal generic behaviours, in order to accommodate other KSP mods."

If you don't use any of the KSP mods mentioned, you don't need to read this section.

## Available Addons

- [Action Groups Extended](addons/AGX.html)
- [RemoteTech](addons/RemoteTech.html)
- [Kerbal Alarm Clock](addons/KAC.html)
- [Infernal Robotics](addons/IR.html)
- [DMagic Orbital Science](addons/OrbitalScience.html)
- [Trajectories](addons/Trajectories.html)

## Availability Check Functions

### `ADDONS:AVAILABLE("AGX")`

Returns True if the Action Group Extended mod is installed and available to kOS.

### `ADDONS:AVAILABLE("RT")`

Returns True if the RemoteTech mod is installed and available to kOS. Additional RemoteTech functions are documented separately.

### `ADDONS:AVAILABLE("KAC")`

Returns True if the Kerbal Alarm Clock mod is installed and available to kOS.

### `ADDONS:AVAILABLE("IR")`

Returns True if the Infernal Robotics mod is installed, available to kOS, and applicable to the current craft.

### `ADDONS:TR:AVAILABLE`

Returns True if a compatible version of the Trajectories mod is installed.
