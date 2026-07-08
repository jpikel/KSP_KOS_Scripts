> Source: https://ksp-kos.github.io/KOS/addons/OrbitalScience.html (mirrored offline copy for local reference)

# DMagic Orbital Science

DMagic Orbital Science is a modification for Kerbal Space Program that "adds extra science experiments to the game." These experiments function differently than stock versions and need specific kOS support through the `ScienceExperimentModule`.

**Downloads:**
- [SpaceDock](http://spacedock.info/mod/128/DMagic%20Orbital%20Science)
- [GitHub Releases](https://github.com/DMagic1/Orbital-Science/releases)

**Source Code:** [GitHub Repository](https://github.com/DMagic1/Orbital-Science)

## Basic Usage

Most Orbital Science experiments inherit all suffixes from `ScienceExperimentModule` and work like stock experiments:

```
SET P TO SHIP:PARTSTAGGED("")[0].
SET M TO P:GETMODULE("dmmodulescienceanimate").

PRINT M:RERUNNABLE.
PRINT M:INOPERABLE.
M:DEPLOY.
WAIT UNTIL M:HASDATA.
M:TRANSMIT.
```

## Extra Suffixes

All Orbital Science experiments include a `TOGGLE` suffix for activation and deactivation:

```
SET P TO SHIP:PARTSTAGGED("collector")[0].
SET M TO P:GETMODULE("dmsolarcollector").

M:TOGGLE.
```

The Submersible Oceanography and Bathymetry experiment offers two additional suffixes for controlling lights:

```
SET P TO SHIP:PARTSTAGGED("bathymetry")[0].
SET M TO P:GETMODULE("dmbathymetry").

M:LIGHTSON.
WAIT 3.
M:LIGHTSOFF.
```
