> Source: https://ksp-kos.github.io/KOS/structures/misc/pidloop.html (mirrored offline copy for local reference)

# PIDLoop Documentation in Markdown

## PIDLoop

A PID loop is a standard control mechanism used to move a control lever to cause a measured phenomenon to settle on a target value. Examples include:

- A car's cruise control moving the accelerator pedal to seek a target speed
- A ship at sea moving the rudder to seek a target compass heading
- An electric oven changing current to the heating element to seek a target temperature

PID stands for "Proportional, Integral, Derivative". It tracks the measured value and how it changes over time to decide how to set the control.

The kOS documentation includes a [tutorial about PID loops](../../tutorials/pidloops.html#pidloops) covering general principles and code examples. However, kOS includes a built-in PID loop type you can use directly.

## Constructors

The PIDLoop constructor function has optional parameters with defaults:

```
SET MYPID TO PIDLOOP(Kp, Ki, Kd, min_output, max_output, epsilon).
```

| Parameter | Default if left off | Meaning |
|-----------|-------------------|---------|
| Kp | 1.0 | Proportional gain |
| Ki | 0.0 | Integral gain |
| Kd | 0.0 | Derivative gain |
| min_output | ~-1.7e308 | The minimum value this PIDLoop will output |
| max_output | ~1.7e308 | The maximum value this PIDLoop will output |
| epsilon | 0.0 | The PIDLoop will ignore any input error smaller than this |

### Examples

```kos
// With zero parameters, the PIDLoop has default parameters:
// kp = 1, ki = 0, kd = 0
// maxoutput = maximum number value
// minoutput = minimum number value
SET PID TO PIDLOOP().

// Create a PIDLoop with a few stated parameters:
SET PID TO PIDLOOP(2.5).
SET PID TO PIDLOOP(2.0, 0.05, 0.1).
SET PID TO PIDLOOP(2.0, 0.05, 0.1, -1, 1).
```

### Example of using it

```kos
// Throttle up when below target altitude, throttle down when above
// target altitude, trying to hover:
local target_alt is 100.
set HOVERPID to PIDLOOP(
    50,  // adjust throttle 0.1 per 5m in error from desired altitude.
    0.1, // adjust throttle 0.1 per second spent at 1m error in altitude.
    30,  // adjust throttle 0.1 per 3 m/s speed toward desired altitude.
    0,   // min possible throttle is zero.
    1    // max possible throttle is one.
  ).
set HOVERPID:SETPOINT to target_alt.
set mythrot to 0.
lock throttle to mythrot.
until false {
  set mythrot to HOVERPID:UPDATE(TIME:SECONDS, alt:radar).
  wait 0.
}
```

## Basic PIDloop Example

Here is a simple example that would move a throttle on a hovering rocket to get it to settle in at an `alt:radar` of 100 meters:

```kos
// Example PIDLoop usage to hover a rocket at 100 meters off the ground:
// Please use it with a rocket that has lots of fuel to test it,
// and a TWR between about 1.75 and 2.0.

lock steering to up.

print "Setting up PID structure:".
set hoverPID to PIDLoop(0.02, 0.0015, 0.02, 0, 1).
set hoverPID:SETPOINT to 100.

set wanted_throttle to 0. // for now.
lock throttle to wanted_throttle.

print "Now starting loop:".
print "Make sure you stage until the engine is active.".
print "You will have to kill it with CTRL-C".
until false {
  set wanted_throttle to hoverPID:UPDATE(time:seconds, alt:radar).
  print "Radar Alt " + round(alt:radar,1) + "m, PID wants throttle=" + round(wanted_throttle,3).
  wait 0.
}
```

## Using SETPOINT is better than using Zero

The `PIDloop` type has a `SETPOINT` suffix, which tells the loop what the desired target value is. While the following two approaches might seem equivalent, they produce different results:

**Version (A):**

```kos
// assume `wanted` is a variable with the desired target value:
// when initializing, do:
set myPid to PIDLOOP(1, 0.2, 0.02, -1, 1).

// later, when updating in a loop, do:
set ctrl to myPid:UPDATE(time:seconds, measurement - wanted).
```

**Version (B):**

```kos
// assume `wanted` is a variable with the desired target value:
// when initializing, do:
set myPid to PIDLOOP(1, 0.2, 0.02, -1, 1).
set myPid:SETPOINT to wanted.

// Later, when updating in a loop, do:
set ctrl to myPid:UPDATE(time:seconds, measurement).
```

With kOS's PIDLoop, Version (B) is better. When calculating the D term, "PIDLoop uses the change in the raw measure, not the error of the measure, to calculate the rate of change." This becomes relevant when your script changes its target value. If you change `MyPid:SETPOINT` to a new value, the PIDLoop is aware the D value didn't suddenly change to an enormously large number, because it measures the change in raw value not the change in error. Using Version (B) allows it to respond less violently to target value changes.

## Structure

### PIDLoop

| Suffix | Type | Description |
|--------|------|-------------|
| `LASTSAMPLETIME` | Scalar | decimal value of the last sample time |
| `KP` | Scalar | The proportional gain factor |
| `KI` | Scalar | The integral gain factor |
| `KD` | Scalar | The derivative gain factor |
| `INPUT` | Scalar | The most recent input value |
| `SETPOINT` | Scalar | The current setpoint |
| `ERROR` | Scalar | The most recent error value |
| `OUTPUT` | Scalar | The most recent output value |
| `MAXOUTPUT` | Scalar | The maximum output value |
| `MINOUTPUT` | Scalar | The maximum output value |
| `EPSILON` | Scalar | The "don't care" tolerance of error |
| `IGNOREERROR` | Scalar | Alias for `EPSILON` |
| `ERRORSUM` | Scalar | The time weighted sum of error |
| `PTERM` | Scalar | The proportional component of output |
| `ITERM` | Scalar | The integral component of output |
| `DTERM` | Scalar | The derivative component of output |
| `CHANGERATE` | Scalar (/s) | The most recent input rate of change |
| `RESET` | none | Reset the integral and derivative components |
| `UPDATE(time, input)` | Scalar | Returns output based on time and input |

### PIDLoop:LASTSAMPLETIME

**Type:** Scalar

**Access:** Get only

The value representing the time of the last sample. This value is equal to the time parameter of the `UPDATE` method.

### PIDLoop:KP

**Type:** Scalar

**Access:** Get/Set

The proportional gain factor.

### PIDLoop:KI

**Type:** Scalar

**Access:** Get/Set

The integral gain factor.

### PIDLoop:KD

**Type:** Scalar

**Access:** Get/Set

The derivative gain factor.

### PIDLoop:INPUT

**Type:** Scalar

**Access:** Get only

The value representing the input of the last sample. This value is equal to the input parameter of the `UPDATE` method.

### PIDLoop:SETPOINT

**Type:** Scalar

**Access:** Get/Set

The current setpoint. This is the value to which input is compared when `UPDATE` is called. It may not be synced with the last sample.

It is desirable to use `SETPOINT` for the reasons described above.

### PIDLoop:ERROR

**Type:** Scalar

**Access:** Get only

The calculated error from the last sample (setpoint - input).

### PIDLoop:OUTPUT

**Type:** Scalar

**Access:** Get only

The calculated output from the last sample.

### PIDLoop:MAXOUTPUT

**Type:** Scalar

**Access:** Get/Set

The current maximum output value. This value also helps with regulating integral wind up mitigation.

### PIDLoop:MINOUTPUT

**Type:** Scalar

**Access:** Get/Set

The current minimum output value. This value also helps with regulating integral wind up mitigation.

### PIDLoop:EPSILON

**Type:** Scalar

**Access:** Get/Set

Default = 0.

The size of the "don't care" tolerance window of the error measurement.

When the error measurement (difference between input and setpoint) is smaller than this number, then this PID loop will simply pretend the error is actually zero and react accordingly (it won't output any control deflection to bother correcting the error until after it's bigger than epsilon.) This can be handy when you want a null zone in the input measure. (This is different from having a null zone in the output, as in having a lever that can't do anything unless it's moved far enough. This is more of a null zone on the input measurement.)

Because the PIDloop will pretend any error smaller than epsilon is zero, it also will not incur any "integral windup" for that error.

### PIDLoop:IGNOREERROR

**Type:** Scalar

**Access:** Get/Set

This is just an alias that is the same thing as `EPSILON`.

### PIDLoop:ERRORSUM

**Type:** Scalar

**Access:** Get only

The value representing the time weighted sum of all errors. It will be equal to `ITERM` / `KI`. This value is adjusted by the integral windup mitigation logic.

### PIDLoop:PTERM

**Type:** Scalar

**Access:** Get only

The value representing the proportional component of `OUTPUT`.

### PIDLoop:ITERM

**Type:** Scalar

**Access:** Get only

The value representing the integral component of `OUTPUT`. This value is adjusted by the integral windup mitigation logic.

### PIDLoop:DTERM

**Type:** Scalar

**Access:** Get only

The value representing the derivative component of `OUTPUT`.

### PIDLoop:CHANGERATE

**Type:** Scalar

**Access:** Get only

The rate of change of the `INPUT` during the last sample. It will be equal to (input - last input) / (change in time).

### PIDLoop:RESET()

**Returns:** none

Call this method to clear the `ERRORSUM`, `ITERM`, and `LASTSAMPLETIME` components of the PID calculation.

### PIDLoop:UPDATE(time, input)

**Parameters:**

- **time** (Scalar) – the decimal time in seconds
- **input** (Scalar) – the input variable to compare to the setpoint

**Returns:** Scalar representing the calculated output

Upon calling this method, the PIDLoop will calculate the output based on this basic framework (see below for detailed derivation): output = error * kp + errorsum * ki + (change in input) / (change in time) * kd. This method is usually called with the current time in seconds (TIME:SECONDS), however it may be called using whatever rate measurement you prefer. Windup mitigation is included, based on `MAXOUTPUT` and `MINOUTPUT`. Both integral components and derivative components are guarded against a change in time greater than 1s, and will not be calculated on the first iteration.

## PIDLoop Update Derivation

The internal update method of the `PIDLoop` structure is the equivalent of the following in kerboscript:

```kos
// assume that the terms LastInput, LastSampleTime, ErrorSum, Kp, Ki, Kd, Setpoint, MinOutput, MaxOutput, and Epsilon are previously defined
declare function Update {
    declare parameter sampleTime, input.
    set Error to Setpoint - input.
    if Error > -Epsilon and Error < Epsilon {
      set Error to 0. // pretend there is no error.
      set input to Setpoint. // pretend there is no error.
    }
    set PTerm to error * Kp.
    set ITerm to 0.
    set DTerm to 0.
    if (LastSampleTime < sampleTime) {
        set dt to sampleTime - LastSampleTime.
        // only calculate integral and derivative if their gain is not 0.
        if Ki <> 0 {
            set ITerm to (ErrorSum + Error * dt) * Ki.
        }
        set ChangeRate to (input - LastInput) / dt.
        if Kd <> 0 {
            set DTerm to -ChangeRate * Kd.
        }
    }
    set Output to pTerm + iTerm + dTerm.
    // if the output goes beyond the max/min limits, reset it and adjust ITerm.
    if Output > MaxOutput {
        set Output to MaxOutput.
        // adjust the value of ITerm as well to prevent the value
        // from winding up out of control.
        if (Ki <> 0) and (LastSampleTime < sampleTime) {
            set ITerm to Output - min(Pterm + DTerm, MaxOutput).
        }
    }
    else if Output < MinOutput {
        set Output to MinOutput.
        // adjust the value of ITerm as well to prevent the value
        // from winding up out of control.
        if (Ki <> 0) and (LastSampleTime < sampleTime) {
            set ITerm to Output - max(Pterm + DTerm, MinOutput).
        }
    }
    set LastSampleTime to sampleTime.
    set LastInput to input.
    if Ki <> 0 set ErrorSum to ITerm / Ki.
    else set ErrorSum to 0.
    return Output.
}
```
</content>
