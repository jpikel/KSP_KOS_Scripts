> Source: https://ksp-kos.github.io/KOS/math/geocoordinates.html (mirrored offline copy for local reference)

# Geographic Coordinates — kOS 1.4.0.0 Documentation

## Geographic Coordinates

The `GeoCoordinates` object (also `LATLNG`) represents a latitude and longitude pair, which is a location on the surface of a Body.

### Creation

#### LATLNG(lat,lng)

**Parameters**
- **lat** – (deg) Latitude
- **lng** – (deg) Longitude

**Returns:** `GeoCoordinates`

This function creates a `GeoCoordinates` object with the given latitude and longitude, assuming the current SHIP's Body is the body to make it for.

Once created it can't be changed. The `GeoCoordinates:LAT` and `GeoCoordinates:LNG` suffixes are get-only (they cannot be set.) To switch to a new location, make a new call to `LATLNG()`.

If you wish to create a `GeoCoordinates` object for a latitude and longitude around a _different_ body than the ship's current sphere of influence body, see `Body:GEOPOSITIONLATLNG` for a means to do that.

It is also possible to obtain a `GeoCoordinates` from some suffixes of some other structures. For example:

```
SET spot to SHIP:GEOPOSITION.
```

### Structure

#### _structure_ GeoCoordinates

| Suffix | Type | Args | Description |
|--------|------|------|-------------|
| `BODY` | Body (m) | none | The celestial body this geocoordinates is on. |
| `LAT` | Scalar (deg) | none | Latitude |
| `LNG` | Scalar (deg) | none | Longitude |
| `DISTANCE` | Scalar (m) | none | distance from CPU Vessel |
| `TERRAINHEIGHT` | Scalar (m) | none | above or below sea level |
| `HEADING` | Scalar (deg) | none | _absolute_ heading from CPU Vessel |
| `BEARING` | Scalar (deg) | none | _relative_ direction from CPU Vessel |
| `POSITION` | Vector (3D Ship-Raw coords) | none | Position of the surface point. |
| `ALTITUDEPOSITION` | Vector (3D Ship-Raw coords) | Scalar (altitude above sea level) | Position of a point above (or below) the surface point, by giving the altitude number. |
| `VELOCITY` | OrbitableVelocity | none | Velocity of the surface at this point (due to the rotation of the planet/moon). |
| `ALTITUDEVELOCITY` | OrbitableVelocity | Scalar (altitude above sea level) | Velocity of a point above (or below) the surface point, by giving the altitude number. |

**Note:** This type is serializable.

#### GeoCoordinates:BODY

The Celestial Body this position is attached to.

#### GeoCoordinates:LAT

The latitude of this position on the surface.

#### GeoCoordinates:LNG

The longitude of this position on the surface.

#### GeoCoordinates:DISTANCE

Distance from the CPU_Vessel to this point on the surface.

#### GeoCoordinates:TERRAINHEIGHT

Distance of the terrain above "sea level" at this geographical position. Negative numbers are below "sea level."

#### GeoCoordinates:HEADING

The _absolute_ compass direction from the CPU_Vessel to this point on the surface.

#### GeoCoordinates:BEARING

The _relative_ compass direction from the CPU_Vessel to this point on the surface. For example, if the vessel is heading at compass heading 45, and the geo-coordinates location is at heading 30, then `GeoCoordinates:BEARING` will return -15.

#### GeoCoordinates:POSITION

The ship-raw 3D position on the surface of the body, relative to the current ship's Center of mass.

#### GeoCoordinates:ALTITUDEPOSITION

The ship-raw 3D position above or below the surface of the body, relative to the current ship's Center of mass. You pass in an altitude number for the altitude above "sea" level of the desired location.

#### GeoCoordinates:VELOCITY

The (linear) velocity of this spot on the surface of the planet/moon, due to the rotation of the body causing that spot to move though space. (For example, on Kerbin at a sea level location, it would be 174.95 m/s eastward, and slightly more at higher terrain spots above sea level.) Note that this is returned as an `OrbitableVelocity`, meaning it isn't a vector but a pair of vectors, one called `:orbit` and one called `:surface`. Note that the surface-relative velocity you get from the `:surface` suffix isn't always zero like you might intuit because `:surface` gives you the velocity relative to the surface reference frame where `SHIP` is, which might not be the same latitude/longitude/altitude as where this Geocoordinates is.

#### GeoCoordinates:ALTITUDEVELOCITY

This is the same as `GeoCoordinates:VELOCITY`, except that it lets you specify some altitude other than the surface terrain height. You specify a (sea-level) altitude, and it will calculate based on a point at that altitude which may be above or below the actual surface at this latitude and longitude. It will calculate as if you had some point fixed to the ground, like an imaginary tower bolted to the surface, but not at the ground's altitude. (The body's rotation will impart a larger magnitude linear velocity on a locaton affixed to the body the farther that location is from the body's center).

### Example Usage

```
SET spot TO LATLNG(10, 20).     // Initialize point at latitude 10,
                                // longitude 20

PRINT spot:LAT.                 // Print 10
PRINT spot:LNG.                 // Print 20

PRINT spot:DISTANCE.            // Print distance from vessel to x
PRINT spot:HEADING.             // Print the heading to the point
PRINT spot:BEARING.             // Print the heading to the point
                                // relative to vessel heading

SET spot TO SHIP:GEOPOSITION.   // Make spot into a location on the
                                // surface directly underneath the
                                // current ship

SET spot TO LATLNG(spot:LAT,spot:LNG+5). // Make spot into a new
                                         // location 5 degrees east
                                         // of the old one

// Point nose of ship at a spot 100,000 meters altitude above a
// particular known latitude of 50 east, 20.2 north:
LOCK STEERING TO LATLNG(50,20.2):ALTITUDEPOSITION(100000).

// A nice complex example:
// -------------------------
// Drawing an debug arrow in 3D space at the spot where the GeoCoordinate
// "spot" is:
// It starts at a position 100m above the ground altitude and is aimed down
// at the spot on the ground:
SET VD TO VECDRAWARGS(
              spot:ALTITUDEPOSITION(spot:TERRAINHEIGHT+100),
              spot:POSITION \- spot:ALTITUDEPOSITION(TERRAINHEIGHT+100),
              red, "THIS IS THE SPOT", 1, true).

PRINT "THESE TWO NUMBERS SHOULD BE THE SAME:".
PRINT (SHIP:ALTITIUDE \- SHIP:GEOPOSITION:TERRAINHEIGHT).
PRINT ALT:RADAR.
```
