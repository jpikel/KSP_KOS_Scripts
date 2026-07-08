> Source: https://ksp-kos.github.io/KOS/addons/RemoteTech.html (mirrored offline copy for local reference)

# RemoteTech — kOS 1.4.0.0 Documentation

## RemoteTech

RemoteTech is a modification for Kerbal Space Program that overhauls unmanned spaceflight by requiring unmanned vessels to maintain a connection to Kerbal Space Center for control. This adds gameplay difficulty to compensate for the absence of live crew.

**Resources:**
- Download: http://spacedock.info/mod/520/RemoteTech
- Sources: https://github.com/RemoteTechnologiesGroup/RemoteTech
- Documentation: http://remotetechnologiesgroup.github.io/RemoteTech/

### Checking for RemoteTech Availability

Check if RemoteTech is installed using:

```
addons:available("RT")
```

Access the addon with:

```
set myRemoteTech to addons:RT.
```

### Quick Example

```
if addons:available("RT") {
  local myRT is addons:RT.
  print "The delay from KSC to Myself is:".
  print myRT:KSCDELAY(ship) + " seconds.".
}
```

### Connectivity Manager

Some methods can be handled generically using the Connectivity Manager, which abstracts differences between communication mods, regardless of whether RemoteTech is installed.

### Interaction with kOS

**Note:** As of v1.0.2, kOS supports unified connection information access via Connectivity Managers. Previous implementations remain supported.

With RemoteTech installed, you can only interact with unmanned craft cores when connected to KSC. Scripts launched with an active connection continue executing after losing connection, but the archive becomes inaccessible without KSC connection. Plan ahead by copying necessary scripts to probe hard drives.

Manned craft can be controlled via terminal without KSC connection. Archive access has no delay in current implementation but may change to account for connection delays.

#### RemoteTech and kOS GUI Widgets

*New in v1.1.0*

The kOS GUI widget system obeys RemoteTech signal delays when installed. User interactions with widgets are subject to the same signal delay rules as interactive flight controls.

### Antennas

Activate/deactivate RemoteTech antennas and set targets using kOS:

```
SET P TO SHIP:PARTSNAMED("mediumDishAntenna")[0].
SET M to p:GETMODULE("ModuleRTAntenna").
M:DOEVENT("activate").
M:SETFIELD("target", "Mission Control").
M:SETFIELD("target", mun).
M:SETFIELD("target", somevessel).
M:SETFIELD("target", "minmus").
```

Acceptable target values:
- "no-target"
- "active-vessel"
- A `Body` object
- A `Vessel` object
- A string containing body or vessel name
- A string containing ground station name (case-sensitive)

Use `RTADDON:GROUNDSTATIONS()` to get all ground station names. Default station is "Mission Control".

### Communication

RemoteTech influences communication between vessels. Valid RemoteTech connections must exist to send messages, with appropriate transmission delays. See the `Connection` structure documentation for detailed behavior.

### RTAddon

Obtained via `Addons:RT`.

#### RTAddon Structure

| Suffix | Type | Description |
|--------|------|-------------|
| `AVAILABLE` | Boolean (readonly) | True if RT is installed and enabled. Use `addons:available("RT")` instead. |
| `DELAY(vessel)` | Scalar | Shortest possible delay to given Vessel |
| `KSCDELAY(vessel)` | Scalar | Delay from KSC to given Vessel |
| `ANTENNAHASCONNECTION(part)` | Boolean | True if Part has any connection |
| `HASCONNECTION(vessel)` | Boolean | True if Vessel has any connection |
| `HASKSCCONNECTION(vessel)` | Boolean | True if Vessel has KSC connection |
| `HASLOCALCONTROL(vessel)` | Boolean | True if Vessel has local control |
| `GROUNDSTATIONS()` | List of Strings | Names of all ground stations |

#### RTADDON:AVAILABLE

**Type:** Boolean (Get only)

True if RemoteTech is installed and integration enabled. Using `ADDONS:AVAILABLE("RT")` is preferred for discovery.

#### RTADDON:DELAY(vessel)

**Parameters:**
- **vessel** – Vessel

**Returns:** Scalar (seconds)

Returns shortest possible delay for vessel (less than KSC delay if you have a local command post).

#### RTADDON:KSCDELAY(vessel)

**Parameters:**
- **vessel** – Vessel

**Returns:** Scalar (seconds)

Returns delay in seconds from KSC to vessel.

#### RTADDON:ANTENNAHASCONNECTION(part)

**Parameters:**
- **part** – Part

**Returns:** Boolean

Returns True if part has any connection (including to local command posts).

#### RTADDON:HASCONNECTION(vessel)

**Parameters:**
- **vessel** – Vessel

**Returns:** Boolean

Returns True if vessel has any connection (including to local command posts).

#### RTADDON:HASKSCCONNECTION(vessel)

**Parameters:**
- **vessel** – Vessel

**Returns:** Boolean

Returns True if vessel has connection to KSC.

#### RTADDON:HASLOCALCONTROL(vessel)

**Parameters:**
- **vessel** – Vessel

**Returns:** Boolean

Returns True if vessel has local control (not requiring RemoteTech connection).

#### RTADDON:GROUNDSTATIONS()

**Returns:** List of Strings

Returns names of all RemoteTech ground stations.
