> Source: https://ksp-kos.github.io/KOS/structures/misc/time.html (mirrored offline copy for local reference)

# Time - kOS 1.4.0.0 Documentation

## Overview

The kOS documentation describes two time structures: `TimeStamp` and `TimeSpan`. A `TimeStamp` represents a single point in game time (like a calendar moment), while a `TimeSpan` represents a duration or offset of time.

**Key Distinction**: `TimeStamp` counts years and days starting at 1 (calendar-based), whereas `TimeSpan` counts from 0 (duration-based).

## TimeStamp Structure

`TimeStamp` represents a specific moment in simulated game time, not real-world time. It accounts for paused games, lag, and simulation speed variations.

### Creating TimeStamps

```
TIMESTAMP(universal_time)
```
Converts seconds since epoch into a `TimeStamp`. Optional parameter; calling `TIMESTAMP()` returns current time.

```
TIMESTAMP(year, day, hour, min, sec)
```
Creates a `TimeStamp` using calendar components. Year and day are mandatory; hour, minute, and second are optional (defaulting to 0).

### TimeStamp Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| `FULL` | String | Complete timestamp (e.g., "Year 1 Day 3 12:30:45") |
| `CLOCK` | String | Time in HH:MM:SS format |
| `CALENDAR` | String | Date in "Year XX Day XX" format |
| `YEAR` | Scalar | Year number (starts at 1) |
| `DAY` | Scalar | Day within year (starts at 1) |
| `HOUR` | Scalar | Hour (0-5 or 0-23 depending on game settings) |
| `MINUTE` | Scalar | Minute (0-59) |
| `SECOND` | Scalar | Whole seconds remainder (0-59) |
| `SECONDS` | Scalar | Total seconds since epoch (includes fractional seconds) |

### TimeStamp:SECOND vs TimeStamp:SECONDS

**`SECOND`** (singular): Remainder seconds after extracting minutes, hours, days, and years. Range [0..60).

**`SECONDS`** (plural): Total elapsed seconds since campaign start (fractional precision available).

## TimeSpan Structure

`TimeSpan` represents a duration of time with years and days counting from 0.

### Creating TimeSpans

```
TIMESPAN(universal_time)
```
Converts a scalar (seconds) into a `TimeSpan`. Optional parameter; `TIMESPAN()` creates a zero-duration span.

```
TIMESPAN(year, day, hour, min, sec)
```
Creates a duration from components. Year and day are mandatory; others optional.

### TimeSpan Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| `FULL` | String | Full duration display (e.g., "1y5d3h20m15s") |
| `CLOCK` | — | **Does not exist** for TimeSpan |
| `CALENDAR` | — | **Does not exist** for TimeSpan |
| `YEAR` | Scalar | Whole years (starts at 0) |
| `YEARS` | Scalar | Total duration expressed in years (fractional) |
| `DAY` | Scalar | Whole days remaining after last full year (starts at 0) |
| `DAYS` | Scalar | Total duration expressed in days (fractional) |
| `HOUR` | Scalar | Whole hours remaining after last full day |
| `HOURS` | Scalar | Total duration expressed in hours (fractional) |
| `MINUTE` | Scalar | Whole minutes remaining after last full hour |
| `MINUTES` | Scalar | Total duration expressed in minutes (fractional) |
| `SECOND` | Scalar | Whole seconds remaining after last full minute |
| `SECONDS` | Scalar | Total duration in seconds (fractional) |

### TimeSpan:SECOND vs TimeSpan:SECONDS

**`SECOND`** (singular): Remainder seconds after extracting minutes, hours, days, and years. Range [0..60).

**`SECONDS`** (plural): Total span duration in seconds (includes fractional component).

## Time Operators - Arithmetic

### TimeStamp Operations

**Subtraction of two TimeStamps**:
```
TimeStamp - TimeStamp = TimeSpan
```

Example:
```
set A to TIMESTAMP(1,3,1,0,0).
set B to TIMESTAMP(1,3,2,20,0).
set C to B - A.  // Results in 0y0d1h20m0s
```

**Addition/Subtraction with TimeSpan**:
```
TimeStamp + TimeSpan = TimeStamp
TimeStamp - TimeSpan = TimeStamp
```

Example:
```
set A to TIMESTAMP().
set B to A + TIMESPAN(0,0,1,30,0).  // 1 hour 30 minutes from now
set C to B - TIMESPAN(0,0,0,1,45).  // 1 minute 45 seconds before B
```

**Addition/Subtraction with Scalar** (interpreted as seconds):
```
TimeStamp + Scalar = TimeStamp
TimeStamp - Scalar = TimeStamp
```

Example:
```
set A to TIMESTAMP().
set B to A + 3600.      // 3600 seconds (1 hour) from now
set C to B - 0.5.       // Half a second before B
```

### TimeSpan Operations

**Addition/Subtraction of two TimeSpans**:
```
TimeSpan + TimeSpan = TimeSpan
TimeSpan - TimeSpan = TimeSpan
```

Example:
```
set A to TIMESPAN(0,0,0,30,0).   // 30 minutes
set B to TIMESPAN(0,0,0,10,0).   // 10 minutes
set C to A + B.                   // 40 minutes
set D to A - B.                   // 20 minutes
```

**Addition/Subtraction with Scalar** (interpreted as seconds):
```
TimeSpan + Scalar = TimeSpan
TimeSpan - Scalar = TimeSpan
```

Example:
```
set D to TIMESPAN(0,0,0,3,0).    // 3 minutes
set D to D + 5.                   // Now 3 minutes 5 seconds
```

**Multiplication and Division by Scalar**:
```
TimeSpan * Scalar = TimeSpan
TimeSpan / Scalar = TimeSpan
Scalar * TimeSpan = TimeSpan
```

(Note: `Scalar / TimeSpan` and operations with `TimeStamp` multiplied/divided by scalars are illegal)

Example:
```
set A to TIMESPAN(0,0,0,45,0).   // 45 minutes
set B to 2 * A.                   // 90 minutes
set C to A / 2.                   // 22 minutes 30 seconds
```

## Time Operators - Comparisons

### TimeStamp Comparisons

```
TimeStamp = TimeStamp    (equal)
TimeStamp <> TimeStamp   (not equal)
TimeStamp < TimeStamp    (sooner)
TimeStamp > TimeStamp    (later)
TimeStamp <= TimeStamp
TimeStamp >= TimeStamp
```

Example:
```
local end_time is TIMESTAMP() + 3.
until TIMESTAMP() > end_time {
  print "3 seconds aren't up yet...".
  wait 0.2.
}
print "3 seconds have passed.".
```

### TimeSpan Comparisons

```
TimeSpan = TimeSpan    (same length)
TimeSpan <> TimeSpan   (different length)
TimeSpan < TimeSpan    (shorter)
TimeSpan > TimeSpan    (longer)
TimeSpan <= TimeSpan
TimeSpan >= TimeSpan
```

Example:
```
local short_span is TIMESPAN(0,0,0,0,30).
local long_span is TIMESPAN(0,0,0,5,0).
if short_span < long_span {
  print "30 seconds is shorter than 5 minutes.".
}
```

### Mixed Type Comparisons

**TimeStamp with Scalar** (scalar interpreted as seconds-since-epoch):
```
TimeStamp = Scalar     TimeStamp >= Scalar
TimeStamp <> Scalar    (and all comparison operators)
TimeStamp < Scalar
TimeStamp > Scalar
TimeStamp <= Scalar
```

**TimeSpan with Scalar** (scalar interpreted as duration in seconds):
```
TimeSpan = Scalar      TimeSpan >= Scalar
TimeSpan <> Scalar     (and all comparison operators)
TimeSpan < Scalar
TimeSpan > Scalar
TimeSpan <= Scalar
```

Example:
```
local how_many_seconds_in_3_hours is 3 * 3600.
if TIMESTAMP() > how_many_seconds_in_3_hours {
  print "Campaign has existed for at least 3 hours of game time.".
}
if TIMESPAN(1,0,0,0,0) > 1000000 {
  print "One year is more than 1000000 seconds.".
}
```

### Illegal Comparisons

**TimeStamp and TimeSpan cannot be compared directly**:
```
TimeStamp = TimeSpan      (ILLEGAL)
TimeStamp <> TimeSpan     (ILLEGAL)
TimeStamp < TimeSpan      (ILLEGAL)
TimeStamp > TimeSpan      (ILLEGAL)
TimeStamp <= TimeSpan     (ILLEGAL)
TimeStamp >= TimeSpan     (ILLEGAL)
```

## Calendar Notes

The Kerbin calendar differs from Earth's. Kerbin has:
- 6 hours per day (stock setting)
- 426 days per year (stock Kerbin)

The game settings allow toggling between Kerbin time and Earth time (24-hour days). The `KUNIVERSE:HOURSPERDAY` value reflects this setting. Mods altering solar systems may change these values further.

## Special Variables

**`TIME`** (no parentheses): Returns the current timestamp, equivalent to `TIMESTAMP()` with no arguments.

```
local current is TIME.  // Gets current game time
```

**Using TIME for Physics Tick Detection**: Since the game updates physics at a fixed rate (default 50 Hz), you can detect physics ticks by checking if `TIME` has changed between script iterations.
</content>
