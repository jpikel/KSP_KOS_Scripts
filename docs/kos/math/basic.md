> Source: https://ksp-kos.github.io/KOS/math/basic.html (mirrored offline copy for local reference)

# Basic Math Functions — kOS 1.4.0.0 Documentation

## Fundamental Constants

The `CONSTANT` bound variable contains fundamental constants. While previously accessed as `CONSTANT():PI`, the modern syntax is `CONSTANT:PI`.

| Identifier | Description |
|---|---|
| `G` | Newton's Gravitational Constant |
| `g0` | Gravity acceleration (m/s²) at sea level on Earth |
| `E` | Base of natural logarithm (Euler's number) |
| `PI` | π |
| `c` | Speed of light in vacuum (m/s) |
| `AtmToKPa` | Atmospheres to kiloPascals conversion |
| `KPaToAtm` | kiloPascals to Atmospheres conversion |
| `DegToRad` | Degrees to Radians conversion |
| `RadToDeg` | Radians to Degrees conversion |
| `Avogadro` | Avogadro's Constant |
| `Boltzmann` | Boltzmann's Constant |
| `IdealGas` | Ideal Gas Constant |

### Constant:G

Newton's Gravitational Constant (6.67384E-11). The game derives this from the Sun's mass and gravitational parameter rather than storing it explicitly. Modded universes could theoretically have varying G values, so using a body's `Mu` property is safer than calculating `mass*G`.

Example:
```
PRINT "Gravitational parameter of Kerbin, calculated:".
PRINT constant:G * Kerbin:Mass.
PRINT "Gravitational parameter of Kerbin, hardcoded:".
PRINT Kerbin:Mu.
PRINT "The above two numbers had *better* agree.".
PRINT "If they do not, then your solar system is badly configured.".
```

### Constant:g0

Standard gravity acceleration at sea level on Earth: 9.80655 m/s². Critical for ISP calculations in the rocket equation. Note: This is Earth's g0, not Kerbin's, which differs slightly. For most calculations beyond ISP, calculate local gravity based on actual radius to body center.

### Constant:E

Natural logarithm base "e":

```
PRINT "e^2 is:".
PRINT constant:e ^ 2.
```

### Constant:PI

Ratio of circle circumference to diameter (3.14159265…):

```
SET diameter to 10.
PRINT "circumference is:".
PRINT constant:pi * diameter.
```

### Constant:C

Speed of light in vacuum (meters per second):

```
SET speed to SHIP:VELOCITY:ORBIT:MAG.
SET percentOfLight to (speed / constant:c) * 100.
PRINT "We're going " + percentOfLight + "% of lightspeed!".
```

**Note:** KSP uses purely Newtonian physics. Faster-than-light travel is possible with sufficient delta-V, and no relativistic effects occur. This constant is primarily useful for RemoteTech mod calculations involving signal delays.

### Constant:AtmToKPa

Conversion constant for atmospheres to kiloPascals:

```
PRINT "1 atm is:".
PRINT 1 * constant:AtmToKPa + " kPa.".
```

### Constant:KPaToATM

Conversion constant for kiloPascals to atmospheres:

```
PRINT "100 kPa is:".
PRINT 100 * constant:KPaToATM + " atmospheres".
```

### Constant:DegToRad

Conversion constant for degrees to radians (equivalent to `constant:pi / 180` but pre-computed):

```
PRINT "A right angle is:".
PRINT 90 * constant:DegToRad + " radians".
```

### Constant:RadToDeg

Conversion constant for radians to degrees (equivalent to `180 / constant:pi` but pre-computed):

```
PRINT "A radian is:".
PRINT 1 * constant:RadToDeg + " degrees".
```

### Constant:Avogadro

Avogadro's Constant. Used in advanced atmospheric property calculations for drag analysis.

### Constant:Boltzmann

Boltzmann Constant. Used in advanced atmospheric property calculations for drag analysis.

### Constant:IdealGas

Ideal Gas Constant. Used in advanced atmospheric property calculations for drag analysis.

---

## Mathematical Functions

| Function | Description |
|---|---|
| `ABS(a)` | Absolute value |
| `CEILING(a)` | Round up |
| `CEILING(a,b)` | Round up to nearest place |
| `FLOOR(a)` | Round down |
| `FLOOR(a,b)` | Round down to nearest place |
| `LN(a)` | Natural logarithm |
| `LOG10(a)` | Logarithm base 10 |
| `MOD(a,b)` | Modulus |
| `MIN(a,b)` | Return lesser value |
| `MAX(a,b)` | Return greater value |
| `RANDOM()` | Random fractional number [0..1] |
| `RANDOMSEED()` | Start new random sequence with seed |
| `ROUND(a)` | Round to whole number |
| `ROUND(a,b)` | Round to nearest place |
| `SQRT(a)` | Square root |
| `CHAR(a)` | Character from Unicode value |
| `UNCHAR(a)` | Unicode value from character |

### ABS(a)

Returns absolute value:

```
PRINT ABS(-1). // prints 1
```

### CEILING(a)

Rounds up to nearest whole number:

```
PRINT CEILING(1.887). // prints 2
```

### CEILING(a,b)

Rounds up to nearest place value:

```
PRINT CEILING(1.887,2). // prints 1.89
```

### FLOOR(a)

Rounds down to nearest whole number:

```
PRINT FLOOR(1.887). // prints 1
```

### FLOOR(a,b)

Rounds down to nearest place value:

```
PRINT CEILING(1.887,2). // prints 1.88
```

### LN(a)

Natural logarithm:

```
PRINT LN(2). // prints 0.6931471805599453
```

### LOG10(a)

Logarithm base 10:

```
PRINT LOG10(2). // prints 0.30102999566398114
```

### MOD(a,b)

Returns remainder from integer division. Not traditional Euclidean division; result sign matches the dividend:

```
PRINT MOD(21,6). // prints 3
PRINT MOD(-21,6). // prints -3
```

### MIN(a,b)

Returns the lower of two values:

```
PRINT MIN(0,100). // prints 0
```

### MAX(a,b)

Returns the higher of two values:

```
PRINT MAX(0,100). // prints 100
```

### RANDOM(key)

Returns next random floating point number [0..1] using a pseudo-random number generator.

**Basic usage:**

```
PRINT RANDOM(). //prints a random number
PRINT "Let's roll a 6-sided die 10 times:".
FOR n in range(0,10) {
  // To make RANDOM give you an integer in the range [0..n-1], use floor(n*RANDOM()).
  // For a die giving values 1 to 6:
  print (1 + floor(6*RANDOM())).
}
```

The optional `key` parameter is a string for tracking separate pseudo-random sequences by name with deterministic repeatability (case-insensitive).

- Omitting `key` uses the default unnamed sequencer
- Supplying `key` creates/accesses a named sequencer

**Deterministic usage example:**

```
// Create two sequencers with same seed for identical sequences
RANDOMSEED("sequence1",12345).
RANDOMSEED("sequence2",12345).

PRINT "5 coin flips from SEQUENCE 1:".
FOR n in range(0,5) {
  print choose "heads" if RANDOM("sequence1") < 0.5 else "tails".
}

PRINT "5 coin flips from SEQUENCE 2, which should be the same:".
FOR n in range(0,5) {
  print choose "heads" if RANDOM("sequence2") < 0.5 else "tails".
}

PRINT "5 more coin flips from SEQUENCE 1:".
FOR n in range(0,5) {
  print choose "heads" if RANDOM("sequence1") < 0.5 else "tails".
}

PRINT "5 more coin flips from SEQUENCE 2, which should be the same:".
FOR n in range(0,5) {
  print choose "heads" if RANDOM("sequence2") < 0.5 else "tails".
}
```

### RANDOMSEED(key, seed)

**No return value.**

Initializes a new random number sequence from a seed with a key name for future reference. Enables pseudo-random sequences that repeat identically when reinitialized with the same seed.

- `key` (string): Name to reference this sequence later (case-insensitive)
- `seed` (integer): Initial value for deterministic sequence generation

Example:

```
RANDOMSEED("generator A",1000).
RANDOMSEED("generator B",1000).
PRINT "Generators A and B should emit identical ".
PRINT "sequences because they both started at seed 1000.".
PRINT "3 numbers from Generator A:".
PRINT floor(RANDOM("generator A")*100).
PRINT floor(RANDOM("generator A")*100).
PRINT floor(RANDOM("generator A")*100).
PRINT "3 numbers from Generator B - they should ".
PRINT "be the same as above:".
PRINT floor(RANDOM("generator B")*100).
PRINT floor(RANDOM("generator B")*100).
PRINT floor(RANDOM("generator B")*100).

PRINT "Resetting generator A but not Generator B:".
RANDOMSEED("generator A",1000).

PRINT "3 more numbers from Generator A which got reset".
PRINT "so they should match the first ones again:".
PRINT floor(RANDOM("generator A")*100).
PRINT floor(RANDOM("generator A")*100).
PRINT floor(RANDOM("generator A")*100).
PRINT "3 numbers from Generator B, which didn't get reset:".
PRINT floor(RANDOM("generator B")*100).
PRINT floor(RANDOM("generator B")*100).
PRINT floor(RANDOM("generator B")*100).
```

Calling `RANDOMSEED` with an existing key name resets that sequence with a new seed.

### ROUND(a)

Rounds to nearest whole number:

```
PRINT ROUND(1.887). // prints 2
```

### ROUND(a,b)

Rounds to nearest place value:

```
PRINT ROUND(1.887,2). // prints 1.89
```

### SQRT(a)

Returns square root:

```
PRINT SQRT(7.89). // prints 2.80891438103763
```

### CHAR(a)

**Parameters:**
- `a` (number): Unicode code point

**Returns:** (string) Single-character string containing the specified Unicode character

```
PRINT CHAR(34) + "Apples" + CHAR(34). // prints "Apples"
```

### UNCHAR(a)

**Parameters:**
- `a` (string): Single character

**Returns:** (number) Unicode value representing the character

```
PRINT UNCHAR("A"). // prints 65
```

---

## Trigonometric Functions

| Function | Description |
|---|---|
| `SIN(a)` | Sine of angle |
| `COS(a)` | Cosine of angle |
| `TAN(a)` | Tangent of angle |
| `ARCSIN(x)` | Angle whose sine is x |
| `ARCCOS(x)` | Angle whose cosine is x |
| `ARCTAN(x)` | Angle whose tangent is x |
| `ARCTAN2(y,x)` | Angle whose tangent is y/x |

### SIN(a)

**Parameters:**
- `a` (deg): Angle in degrees

**Returns:** Sine of the angle

```
PRINT SIN(6). // prints 0.10452846326
```

### COS(a)

**Parameters:**
- `a` (deg): Angle in degrees

**Returns:** Cosine of the angle

```
PRINT COS(6). // prints 0.99452189536
```

### TAN(a)

**Parameters:**
- `a` (deg): Angle in degrees

**Returns:** Tangent of the angle

```
PRINT TAN(6). // prints 0.10510423526
```

### ARCSIN(x)

**Parameters:**
- `x` (Scalar)

**Returns:** (deg) Angle whose sine is x

```
PRINT ARCSIN(0.67). // prints 42.0670648
```

### ARCCOS(x)

**Parameters:**
- `x` (Scalar)

**Returns:** (deg) Angle whose cosine is x

```
PRINT ARCCOS(0.67). // prints 47.9329352
```

### ARCTAN(x)

**Parameters:**
- `x` (Scalar)

**Returns:** (deg) Angle whose tangent is x

```
PRINT ARCTAN(0.67). // prints 33.8220852
```

### ARCTAN2(y,x)

**Parameters:**
- `y` (Scalar)
- `x` (Scalar)

**Returns:** (deg) Angle whose tangent is y/x

```
PRINT ARCTAN2(0.67, 0.89). // prints 36.9727625
```

The two parameters resolve ambiguities in arctangent calculation. See the Wikipedia page on atan2 for detailed information.
