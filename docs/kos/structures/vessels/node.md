> Source: https://ksp-kos.github.io/KOS/structures/vessels/node.html (mirrored offline copy for local reference)

# Maneuver Node Documentation (kOS 1.4.0.0)

## Overview

A maneuver node represents a planned velocity change along an orbit. These nodes can be created through the kOS scripting interface or the KSP user interface, and will appear in the in-game map view.

**Important Limitation:** Maneuver node systems are restricted to the active player vessel due to KSP engine limitations. Scripts cannot access maneuver nodes on non-active vessels.

## Creation

### NODE() Function

```
NODE(time, radial, normal, prograde)
```

**Parameters:**
- `time` – TimeSpan (ETA), TimeStamp (UT), or Scalar (UT)
- `radial` – m/s Delta-V in radial-out direction
- `normal` – m/s Delta-V normal to orbital plane
- `prograde` – m/s Delta-V in prograde direction

**Returns:** ManeuverNode structure

The time parameter accepts different formats:

Using TimeSpan (relative time from now):
```
SET myNode to NODE( TimeSpan(0, 0, 0, 2, 30), 0, 50, 10 ).
SET myNode to NODE( TimeSpan(150), 0, 50, 10 ).
```

Using TimeStamp or Scalar (absolute universal time):
```
SET myNode to NODE( TimeStamp(5,23,1,30,0), 0, 50, 10 ).
SET myNode to NODE( 3600, 0, 50, 10 ).
```

## Adding and Removing Nodes

### ADD Command

Attaches a maneuver node to the current CPU vessel's flight plan:

```
SET myNode to NODE( TIME:SECONDS+200, 0, 50, 10 ).
ADD myNode.
```

The node will immediately appear on the map view. Nodes with smaller ETA times will be ordered earlier in the flight plan.

**Warning:** ADD does not work on non-active vessels.

### REMOVE Command

Removes a maneuver node from the flight plan:

```
REMOVE myNode.
```

**Warning:** REMOVE does not work on non-active vessels.

## Built-in Variables

### NEXTNODE

Returns the next upcoming node in the flight plan:

```
SET MyNode to NEXTNODE.
PRINT NEXTNODE:PROGRADE.
REMOVE NEXTNODE.
```

**Warning:** Querying NEXTNODE when no nodes exist produces a runtime error. NEXTNODE does not work on non-active vessels.

### HASNODE

**Type:** Boolean (Get only)

Returns true if the CPU vessel has a planned maneuver node. Always returns false for non-active vessels.

### ALLNODES

**Type:** List of ManeuverNode elements (Get only)

Returns all ManeuverNode objects currently in the CPU vessel's flight plan. The list is empty if no nodes are planned or if the vessel cannot use maneuver nodes.

**Notes:**
- Storing this list in a variable does not automatically update it when nodes are added/removed
- Adding ManeuverNode objects to this list does not add them to the flight plan (use ADD instead)

## ManeuverNode Structure

### Basic Usage Example

```
SET X TO NODE(TIME:SECONDS+60, 0, 0, 100).

ADD X.            // adds maneuver to flight plan

PRINT X:PROGRADE. // prints 100
PRINT X:ETA.      // prints seconds till maneuver
PRINT X:TIME.     // prints exact UT time of maneuver
PRINT X:DELTAV    // prints delta-v vector

REMOVE X.         // remove node from flight plan

SET X TO NODE(0, 0, 0, 0).

ADD X.                 // add Node to flight plan
SET X:PROGRADE to 500. // set prograde dV to 500 m/s
SET X:ETA to 30.       // Set to 30 sec from now

PRINT X:ORBIT:APOAPSIS.  // apoapsis after maneuver
PRINT X:ORBIT:PERIAPSIS. // periapsis after maneuver
```

### Members Table

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| DELTAV | Vector (m/s) | Get only | The burn vector with magnitude equal to delta-V |
| BURNVECTOR | Vector (m/s) | Get only | Alias for DELTAV |
| ETA | Scalar (s) | Get/Set | Time until this maneuver |
| TIME | Scalar (s) | Get/Set | Universal Time of this maneuver |
| PROGRADE | Scalar (m/s) | Get/Set | Delta-V along prograde |
| RADIALOUT | Scalar (m/s) | Get/Set | Delta-V along radial to orbited Body |
| NORMAL | Scalar (m/s) | Get/Set | Delta-V along normal to the Vessel's Orbit |
| ORBIT | Orbit | Get only | Expected Orbit after this maneuver |

### Member Details

#### ManeuverNode:DELTAV
**Access:** Get only | **Type:** Vector

The vector representing the total burn. Can be used for steering; magnitude equals delta-V.

#### ManeuverNode:BURNVECTOR

Alias for ManeuverNode:DELTAV.

#### ManeuverNode:ETA
**Access:** Get/Set | **Type:** Scalar

Number of seconds until the expected burn time. Setting this value moves the node along the path.

#### ManeuverNode:TIME
**Access:** Get/Set | **Type:** Scalar

Universal time of the node. Should equal ManeuverNode:ETA plus TIME:SECONDS.

#### ManeuverNode:PROGRADE
**Access:** Get/Set | **Type:** Scalar

Delta-V in meters/s along the prograde direction. Positive values indicate prograde burns; negative values indicate retrograde.

#### ManeuverNode:RADIALOUT
**Access:** Get/Set | **Type:** Scalar

Delta-V in meters/s along the radial direction. Positive values indicate radial out; negative values indicate radial in.

#### ManeuverNode:NORMAL
**Access:** Get/Set | **Type:** Scalar

Delta-V in meters/s along the normal direction. Positive values indicate normal burns; negative values indicate anti-normal.

#### ManeuverNode:ORBIT
**Access:** Get only | **Type:** Orbit

The new orbit patch beginning at the burn, assuming the burn occurs exactly as planned.
