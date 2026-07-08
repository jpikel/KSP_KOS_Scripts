> Source: https://ksp-kos.github.io/KOS/structures/waypoint.html (mirrored offline copy for local reference)

# Waypoints — kOS 1.4.0.0 Documentation

## Waypoints

Waypoints serve as location markers visible in map view, indicating contract targets. This structure enables access to coordinate data for waypoint locations.

### WAYPOINT(name)

**Parameters**
- **name** – (String) Name of the waypoint as displayed on the map or in contract description

**Returns**
- Waypoint structure

Creates a new Waypoint from an accepted contract's waypoint name. This only functions for accepted contracts; proposed contracts do not work in kOS. The name matching is case-insensitive.

**Example:**
```
SET spot TO WAYPOINT("herman's folly beta").
```

### ALLWAYPOINTS()

**Returns**
- List of Waypoint structures

Generates a list of Waypoint structures for all accepted contracts. Proposed contracts that haven't been accepted are excluded.

### Structure: Waypoint

#### Members Table

| Suffix | Type | Description |
|--------|------|-------------|
| NAME | String | Get only |
| BODY | BodyTarget | Get only |
| GEOPOSITION | GeoCoordinates | Get only |
| POSITION | Vector | Get only |
| ALTITUDE | Scalar | Get only |
| AGL | Scalar | Get only |
| NEARSURFACE | Boolean | Get only |
| GROUNDED | Boolean | Get only |
| INDEX | Scalar | Get only |
| CLUSTERED | Boolean | Get only |
| ISSELECTED | Boolean | Get only |

#### Waypoint:NAME
Type: String | Access: Get only

The waypoint's name as displayed on the map and in contracts.

#### Waypoint:BODY
Type: BodyTarget | Access: Get only

The celestial body to which the waypoint is attached.

#### Waypoint:GEOPOSITION
Type: GeoCoordinates | Access: Get only

The latitude/longitude of the waypoint.

#### Waypoint:POSITION
Type: Vector | Access: Get only

The 3D vector position of the waypoint in ship-raw coordinates.

#### Waypoint:ALTITUDE
Type: Scalar | Access: Get only

Altitude above sea level. Note: represents a midpoint within the contract's altitude range, not the edge.

#### Waypoint:AGL
Type: Scalar | Access: Get only

Altitude above ground. Note: represents a midpoint within the contract's altitude range, not the edge.

#### Waypoint:NEARSURFACE
Type: Boolean | Access: Get only

True if the waypoint is near or on the body surface rather than in high orbit.

#### Waypoint:GROUNDED
Type: Boolean | Access: Get only

True if the waypoint is fixed to the ground.

#### Waypoint:INDEX
Type: Scalar | Access: Get only

The integer index among clustered sibling waypoints (0 = Alpha, 1 = Beta, 2 = Gamma, etc.). Meaningless when CLUSTERED is false.

#### Waypoint:CLUSTERED
Type: Boolean | Access: Get only

True if this waypoint is part of a cluster with Greek letter suffixes. A one-to-one correspondence exists between letters and INDEX values.

#### Waypoint:ISSELECTED
Type: Boolean | Access: Get only

True if navigation has been activated on this waypoint.
