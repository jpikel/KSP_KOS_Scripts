> Source: https://ksp-kos.github.io/KOS/structures/misc/steeringmanager.html (mirrored offline copy for local reference)

# SteeringManager — kOS 1.4.0.0 Documentation

See [the cooked control tuning explanation](../../commands/flight/cooked.html#cooked-tuning) for information to help with tuning the steering manager. It's important to read that section first to understand which setting below is affecting which portion of the steering system.

The SteeringManager is a bound variable, not a suffix to a specific vessel. This prevents access to the SteeringManager of other vessels. You can access the steering manager as shown below:

```
// Display the ship facing, target facing, and world coordinates vectors.
SET STEERINGMANAGER:SHOWFACINGVECTORS TO TRUE.

// Change the torque calculation to multiply the available torque by 1.5.
SET STEERINGMANAGER:ROLLTORQUEFACTOR TO 1.5.
```

## structure SteeringManager

| Suffix | Type | Description |
|--------|------|-------------|
| `PITCHPID` | `PIDLoop` | The PIDLoop for the pitch rotational velocity PID. |
| `YAWPID` | `PIDLoop` | The PIDLoop for the yaw rotational velocity PID. |
| `ROLLPID` | `PIDLoop` | The PIDLoop for the roll rotational velocity PID. |
| `ENABLED` | `Boolean` | Returns true if the SteeringManager is currently controlling the vessel |
| `TARGET` | `Direction` | The direction that the vessel is currently steering towards |
| `RESETPIDS()` | none | Called to call RESET on all steering PID loops. |
| `RESETTODEFAULT()` | none | Called to reset all steering tuning parameters. |
| `SHOWFACINGVECTORS` | `Boolean` | Enable/disable display of ship facing, target, and world coordinates vectors. |
| `SHOWANGULARVECTORS` | `Boolean` | Enable/disable display of angular rotation vectors |
| `SHOWSTEERINGSTATS` | `Boolean` | Enable/disable printing of the steering information on the terminal |
| `WRITECSVFILES` | `Boolean` | Enable/disable logging steering to csv files. |
| `PITCHTS` | `Scalar` (s) | Settling time for the pitch torque calculation. |
| `YAWTS` | `Scalar` (s) | Settling time for the yaw torque calculation. |
| `ROLLTS` | `Scalar` (s) | Settling time for the roll torque calculation. |
| `TORQUEEPSILONMIN` | `Scalar` (s) | Torque deadzone when not rotating at max rate |
| `TORQUEEPSILONMAX` | `Scalar` (s) | Torque deadzone when rotating at max rotation rate |
| `MAXSTOPPINGTIME` | `Scalar` (s) | The maximum amount of stopping time to limit angular turn rate. |
| `ROLLCONTROLANGLERANGE` | `Scalar` (deg) | The maximum value of `ANGLEERROR` for which to control roll. |
| `ANGLEERROR` | `Scalar` (deg) | The angle between vessel:facing and target directions |
| `PITCHERROR` | `Scalar` (deg) | The angular error in the pitch direction |
| `YAWERROR` | `Scalar` (deg) | The angular error in the yaw direction |
| `ROLLERROR` | `Scalar` (deg) | The angular error in the roll direction |
| `PITCHTORQUEADJUST` | `Scalar` (kN) | Additive adjustment to pitch torque (calculated) |
| `YAWTORQUEADJUST` | `Scalar` (kN) | Additive adjustment to yaw torque (calculated) |
| `ROLLTORQUEADJUST` | `Scalar` (kN) | Additive adjustment to roll torque (calculated) |
| `PITCHTORQUEFACTOR` | `Scalar` | Multiplicative adjustment to pitch torque (calculated) |
| `YAWTORQUEFACTOR` | `Scalar` | Multiplicative adjustment to yaw torque (calculated) |
| `ROLLTORQUEFACTOR` | `Scalar` | Multiplicative adjustment to roll torque (calculated) |

### SteeringManager:PITCHPID

**Type:** `PIDLoop`

**Access:** Get only

Returns the PIDLoop object responsible for calculating the target angular velocity in the pitch direction. This allows direct manipulation of the gain parameters, and other components of the `PIDLoop` structure. Changing the loop's MAXOUTPUT or MINOUTPUT values will have no effect as they are overwritten every physics frame. They are set to limit the maximum turning rate to that which can be stopped in a `MAXSTOPPINGTIME` seconds (calculated based on available torque, and the ship's moment of inertia).

### SteeringManager:YAWPID

**Type:** `PIDLoop`

**Access:** Get only

Returns the PIDLoop object responsible for calculating the target angular velocity in the yaw direction. This allows direct manipulation of the gain parameters, and other components of the `PIDLoop` structure. Changing the loop's MAXOUTPUT or MINOUTPUT values will have no effect as they are overwritten every physics frame. They are set to limit the maximum turning rate to that which can be stopped in a `MAXSTOPPINGTIME` seconds (calculated based on available torque, and the ship's moment of inertia).

### SteeringManager:ROLLPID

**Type:** `PIDLoop`

**Access:** Get only

Returns the PIDLoop object responsible for calculating the target angular velocity in the roll direction. This allows direct manipulation of the gain parameters, and other components of the `PIDLoop` structure. Changing the loop's MAXOUTPUT or MINOUTPUT values will have no effect as they are overwritten every physics frame. They are set to limit the maximum turning rate to that which can be stopped in a `MAXSTOPPINGTIME` seconds (calculated based on available torque, and the ship's moment of inertia).

**Note**

The SteeringManager will ignore the roll component of steering until after both the pitch and yaw components are close to being correct. In other words it will try to point the nose of the craft in the right direction first, before it makes any attempt to roll the craft into the right orientation. As long as the pitch or yaw is still far off from the target aim, this PIDloop won't be getting used at all.

### SteeringManager:ENABLED

**Type:** `Boolean`

**Access:** Get only

Returns true if the SteeringManager is currently controlling the vessel steering.

### SteeringManager:TARGET

**Type:** `Direction`

**Access:** Get only

Returns direction that the is currently being targeted. If steering is locked to a vector, this will return the calculated direction in which kOS chose an arbitrary roll to go with the vector. If steering is locked to "kill", this will return the vessel's last facing direction.

### SteeringManager:RESETPIDS()

**Returns:** none

Resets the integral sum to zero for all six steering PID Loops.

### SteeringManager:RESETTODEFAULT()

**Returns:** none

Resets the various tuning parameters of the `SteeringManager` to their default values as if the ship had just been loaded. This internally will also call `SteeringManager:RESETPIDS`.

### SteeringManager:SHOWFACINGVECTORS

**Type:** `Boolean`

**Access:** Get/Set

Setting this suffix to true will cause the steering manager to display graphical vectors (see `VecDraw`) representing the forward, top, and starboard of the facing direction, as well as the world x, y, and z axis orientation (centered on the vessel). Setting to false will hide the vectors, as will disabling locked steering.

### SteeringManager:SHOWANGULARVECTORS

**Type:** `Boolean`

**Access:** Get/Set

Setting this suffix to true will cause the steering manager to display graphical vectors (see `VecDraw`) representing the current and target angular velocities in the pitch, yaw, and roll directions. Setting to false will hide the vectors, as will disabling locked steering.

### SteeringManager:SHOWSTEERINGSTATS

**Type:** `Boolean`

**Access:** Get/Set

Setting this suffix to true will cause the steering manager to clear the terminal screen and print steering data each update.

### SteeringManager:WRITECSVFILES

**Type:** `Boolean`

**Access:** Get/Set

Setting this suffix to true will cause the steering manager log the data from all 6 PIDLoops calculating target angular velocity and target torque. The files are stored in the [KSP Root]GameDatakOSPluginsPluginDatakOS folder, with one file per loop and a new file created for each new manager instance (i.e. every launch, every revert, and every vessel load). These files can grow quite large, and add up quickly, so it is recommended to only set this value to true for testing or debugging and not normal operation.

### SteeringManager:PITCHTS

**Type:** `Scalar`

**Access:** Get/Set

Represents the settling time for the PID calculating pitch torque based on target angular velocity. The proportional and integral gain is calculated based on the settling time and the moment of inertia in the pitch direction. Ki = (moment of inertia) * (4 / (settling time)) ^ 2. Kp = 2 * sqrt((moment of inertia) * Ki).

### SteeringManager:YAWTS

**Type:** `Scalar`

**Access:** Get/Set

Represents the settling time for the PID calculating yaw torque based on target angular velocity. The proportional and integral gain is calculated based on the settling time and the moment of inertia in the yaw direction. Ki = (moment of inertia) * (4 / (settling time)) ^ 2. Kp = 2 * sqrt((moment of inertia) * Ki).

### SteeringManager:ROLLTS

**Type:** `Scalar`

**Access:** Get/Set

Represents the settling time for the PID calculating roll torque based on target angular velocity. The proportional and integral gain is calculated based on the settling time and the moment of inertia in the roll direction. Ki = (moment of inertia) * (4 / (settling time)) ^ 2. Kp = 2 * sqrt((moment of inertia) * Ki).

### SteeringManager:TORQUEEPSILONMIN

**Type:** `Scalar`

**Access:** Get/Set

**DEFAULT VALUE:** 0.0002

Tweaking this value can help make the controls stop wiggling so fast.

You cannot set this value higher than `SteeringManager:TORQUEEPSILONMAX`. If you attempt to do so, then `SteeringManager:TORQUEEPSILONMAX` will be increased to match the value just set `SteeringManager:TORQUEEPSILONMIN` to.

To see how to use this value, look at the description of `SteeringManager:TORQUEEPSILONMAX` below, which has the full documentation about how these two values, Min and Max, work together.

### SteeringManager:TORQUEEPSILONMAX

**Type:** `Scalar`

**Access:** Get/Set

**DEFAULT VALUE:** 0.001

Tweaking this value can help make the controls stop wiggling so fast. If you have problems wasting too much RCS propellant because kOS "cares too much" about getting the rotation rate exactly right and is wiggling the controls unnecessarily when rotating toward a new direction, setting this value a bit higher can help.

You cannot set this value lower than `SteeringManager:TORQUEEPSILONMIN`. If you attempt to do so, then `SteeringManager:TORQUEEPSILONMIN` will be decreased to match the value just set `SteeringManager:TORQUEEPSILONMAX` to.

**HOW IT WORKS:**

If the error in the desired rotation rate is smaller than the current epsilon, then the PID that calculates desired torque will ignore that error and not bother correcting it until it gets bigger. The actual epsilon value used in the steering manager's internal PID controller is always something between `SteeringManager:TORQUEEPSILONMIN` and `SteeringManager:TORQUEEPSILONMAX`. It varies between these two values depending on whether the vessel is currently rotating at near the maximum rotation rate the SteeringManager allows (as determined by `SteeringManager:MAXSTOPPINGTIME`) or whether it's quite far from its maximum rotation rate. `SteeringManager:TORQUEEPSILONMAX` is used when the vessel is at it's maximum rotation rate (i.e. it's coasting around to a new orientation and shouldn't pointlessly spend RCS fuel trying to hold that angular velocity precisely). `SteeringManager:TORQUEEPSILONMIN` is used when the vessel is not trying to rotate at all and is supposed to be using the steering just to hold the aim at a standstill. In between these two states, it uses a value partway between the two, linearly interpolated between them.

If you desire a constant epsilon, set both the min and max values to the same value.

**MIN VESSEL CAPABILITY:**

Warning: Setting `SteeringManager:ROTATIONEPSILONMAX` too large can make the SteeringManager fail to try turning the craft at all. Use this formula to decide what is probably the maximum safe value you can set it to without it causing this problem:

Let ω = rotational acceleration the vessel is capable of, expressed in degrees/second²

Then ε, the maximum safe `RotationEpsilonMax` to pick, is:

ε = ω · MAXSTOPPINGTIME

Where MAXSTOPPINGTIME is `SteeringManager:MAXSTOPPINGTIME`

### SteeringManager:MAXSTOPPINGTIME

**Type:** `Scalar` (s)

**Access:** Get/Set

This value is used to limit the turning rate when calculating target angular velocity. The ship will not turn faster than what it can stop in this amount of time. The maximum angular velocity about each axis is calculated as: (max angular velocity) = MAXSTOPPINGTIME * (available torque) / (moment of inertia).

**Note**

This setting affects all three of the rotational velocity PID's at once (pitch, yaw, and roll), rather than affecting the three axes individually one at a time.

### SteeringManager:ROLLCONTROLANGLERANGE

**Type:** `Scalar` (deg)

**Access:** Get/Set

The maximum value of `ANGLEERROR` for which kOS will attempt to respond to error along the roll axis. If this is set to 5 (the default value), the facing direction will need to be within 5 degrees of the target direction before it actually attempts to roll the ship. Setting the value to 180 will effectively allow roll control at any error amount. When `ANGLEERROR` is greater than this value, kOS will only attempt to kill all roll angular velocity. The value is clamped between 180 and 1e-16.

### SteeringManager:ANGLEERROR

**Type:** `Scalar` (deg)

**Access:** Get only

The angle between the ship's facing direction forward vector and the target direction's forward. This is the combined pitch and yaw error.

### SteeringManager:PITCHERROR

**Type:** `Scalar` (deg)

**Access:** Get only

The pitch angle between the ship's facing direction and the target direction.

### SteeringManager:YAWERROR

**Type:** `Scalar` (deg)

**Access:** Get only

The yaw angle between the ship's facing direction and the target direction.

### SteeringManager:ROLLERROR

**Type:** `Scalar` (deg)

**Access:** Get only

The roll angle between the ship's facing direction and the target direction.

### SteeringManager:PITCHTORQUEADJUST

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide an additive bias to the calculated available pitch torque used in the pitch torque PID. (available torque) = ((calculated torque) + PITCHTORQUEADJUST) * PITCHTORQUEFACTOR.

### SteeringManager:YAWTORQUEADJUST

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide an additive bias to the calculated available yaw torque used in the yaw torque PID. (available torque) = ((calculated torque) + YAWTORQUEADJUST) * YAWTORQUEFACTOR.

### SteeringManager:ROLLTORQUEADJUST

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide an additive bias to the calculated available roll torque used in the roll torque PID. (available torque) = ((calculated torque) + ROLLTORQUEADJUST) * ROLLTORQUEFACTOR.

### SteeringManager:PITCHTORQUEFACTOR

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide a multiplicative factor bias to the calculated available pitch torque used in the torque PID. (available torque) = ((calculated torque) + PITCHTORQUEADJUST) * PITCHTORQUEFACTOR.

### SteeringManager:YAWTORQUEFACTOR

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide a multiplicative factor bias to the calculated available yaw torque used in the torque PID. (available torque) = ((calculated torque) + YAWTORQUEADJUST) * YAWTORQUEFACTOR.

### SteeringManager:ROLLTORQUEFACTOR

**Type:** `Scalar` (kNm)

**Access:** Get/Set

You can set this value to provide a multiplicative factor bias to the calculated available roll torque used in the torque PID. (available torque) = ((calculated torque) + ROLLTORQUEADJUST) * ROLLTORQUEFACTOR.
</content>
