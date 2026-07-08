> Source: https://ksp-kos.github.io/KOS/structures/misc/timewarp.html (mirrored offline copy for local reference)

# WARP — kOS 1.4.0.0 Documentation

## TimeWarp Structure

The `TimeWarp` structure enables control and monitoring of KSP's time warping capabilities. Access it via the `TimeWarp` suffix of the `kuniverse` structure.

### Members and Methods

| Suffix | Type | Get/Set | Description |
|--------|------|---------|-------------|
| `RATELIST` | List of Scalar values | Get | Returns either `RAILSRATELIST` or `PHYSICSRATELIST` depending on current mode |
| `RAILSRATELIST` | List of Scalar values | Get | Allowed multiplier rates for on-rails-warp modes |
| `PHYSICSRATELIST` | List of Scalar values | Get | Allowed multiplier rates for physics-warp modes |
| `MODE` | String | Get/Set | Time warp mode: "PHYSICS" or "RAILS" |
| `WARP` | Scalar | Get/Set | Time warp integer index (0, 1, 2, 3, etc.) |
| `RATE` | Scalar | Get/Set | Current multiplier timescale rate (e.g., 100 for 100x warp) |
| `WARPTO` | None | Callable method | Warp forward to a known timestamp |
| `CANCELWARP` | None | Callable method | Cancel current warping |
| `PHYSICSDELTAT` | Scalar | Get | Physics Delta-T; expected time between ticks |
| `ISSETTLED` | Boolean | Get | True once actual rate reaches commanded rate |

## Suffixes

### TimeWarp:RATELIST

**Access:** Get  
**Type:** List of Scalar values

Returns the rate list matching the current warping mode. If mode is "PHYSICS", returns `PHYSICSRATELIST`; if "RAILS", returns `RAILSRATELIST`.

### TimeWarp:RAILSRATELIST

**Access:** Get  
**Type:** List of Scalar values

Legal warp rates for on-rails warping mode:

| WARP | RATE |
|------|------|
| 0 | 1x |
| 1 | 5x |
| 2 | 10x |
| 3 | 50x |
| 4 | 100x |
| 5 | 1000x |
| 6 | 10000x |
| 7 | 100000x |

### TimeWarp:PHYSICSRATELIST

**Access:** Get  
**Type:** List of Scalar values

Legal warp rates for physics warping mode:

| WARP | RATE |
|------|------|
| 0 | 1x |
| 1 | 2x |
| 2 | 3x |
| 3 | 4x |

### TimeWarp:MODE

**Access:** Get/Set  
**Type:** String

Indicates current warping mode: "PHYSICS" or "RAILS". Setting this value changes which warp mode the game uses.

In physics warp, the physics engine simulates with longer time steps for faster simulation. In rails warp, many calculations are bypassed and vessel positions derive from Keplerian elliptical parameters only.

### TimeWarp:WARP

**Access:** Get/Set  
**Type:** Scalar

Time warp as an integer index corresponding to the left-hand column in `RAILSRATELIST` or `PHYSICSRATELIST`. For example, if mode is "RAILS" and rate is 50, then `WARP` is 3.

Setting either `WARP` or `RATE` updates the other to maintain consistency.

### TimeWarp:RATE

**Access:** Get/Set  
**Type:** Scalar

The current multiplier timescale rate (e.g., 1000 for 1000x speed).

After changing time warp, the game takes several moments to reach the desired rate. This attribute reflects the actual rate during the current physics tick, which may differ from the target until settlement completes.

When setting `RATE`, kOS sets the corresponding `WARP` index to achieve that rate. The rate itself doesn't change immediately. These are equivalent:

```
set kuniverse:timewarp:warp to 4.
set kuniverse:timewarp:rate to 100.
```

If the requested rate isn't on the allowed list, kOS selects the `WARP` value closest to the target:

```
set kuniverse:timewarp:rate to 89.
set kuniverse:timewarp:rate to 145.
set kuniverse:timewarp:rate to 100.
// All three result in rate of 100 (closest allowed value)
```

The game can transition through arbitrary intermediate rates but doesn't allow indefinite holding at in-between values.

### TimeWarp:WARPTO(timestamp)

**Access:** Method  
**Parameters:** timestamp (Scalar – universal time in seconds)  
**Returns:** None

Warps time forward to a specified universal timestamp. Example: to warp 120 seconds into the future:

```
kuniverse:timewarp:warpto(time:seconds + 120).
```

This alters `WARP` and `RATE` values during the warp sequence.

### TimeWarp:CANCELWARP()

**Access:** Method  
**Returns:** None

Cancels any active warp, interrupting automated warps (like `WARPTO`) and manual warp settings.

### TimeWarp:PHYSICSDELTAT

**Access:** Get  
**Type:** Scalar

Physics Delta-T: the expected time between ticks. This is not actual elapsed time; for that, compare regular `time:seconds` queries. This value varies with physics warp and may return unreliable values during on-rails warping.

### TimeWarp:ISSETTLED

**Access:** Get  
**Type:** Boolean

Returns true once the actual warp rate reaches the commanded rate. After changing warp speed, the game requires multiple update cycles to stabilize.

Example:

```
set kuniverse:timewarp:mode to "RAILS".
set kuniverse:timewarp:rate to 1000.
print "starting to change warp".
until kuniverse:timewarp:issettled {
    print "rate = " + round(rate,1).
    wait 0.
}
print "warp is now 1000x".
```

Sample output:

```
starting to change warp.
rate = 113.5
rate = 143.2
rate = 213.1
rate = 233.2
rate = 250.0
rate = 264.1
rate = 301.5
rate = 320.5
rate = 361.5
rate = 391.3
rate = 421.5
rate = 430.0
rate = 450.5
rate = 471.5
rate = 490.1
rate = 501.5
rate = 613.5
rate = 643.2
rate = 713.1
rate = 733.2
rate = 750.0
rate = 764.1
rate = 801.5
rate = 820.5
rate = 861.5
rate = 891.3
rate = 921.5
rate = 930.0
rate = 950.5
rate = 971.5
rate = 990.1
rate = 1000
warp is now 1000x.
```

## Backward Compatible Time Warping

For backward compatibility, the following global shortcuts alias `TimeWarp` functionality:

### WARPMODE

Identical to `MODE`:

```
SET WARPMODE TO "PHYSICS".
SET KUNIVERSE:TIMEWARP:MODE TO "PHYSICS".

SET WARPMODE TO "RAILS".
SET KUNIVERSE:TIMEWARP:MODE TO "RAILS".
```

### WARP

Identical to `WARP`:

```
SET WARP TO 3.
SET KUNIVERSE:TIMEWARP:WARP to 3.
```

### WARPTO(timestamp)

Identical to `WARPTO`:

```
WARPTO(time:seconds + 60*60).
KUNIVERSE:TIMEWARP:WARPTO(time:seconds + 60*60).
```
</content>
