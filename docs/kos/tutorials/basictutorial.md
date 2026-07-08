> Source: https://ksp-kos.github.io/KOS/tutorials/basictutorial.html (mirrored offline copy for local reference)

# KOS and programming introduction

This tutorial is designed for beginners new to programming who want to learn using KOS.

## Table of Contents

- [Accessing the KOS terminal](#accessing-the-kos-terminal)
  - [Making scripts in-game](#making-scripts-in-game)
  - [Making scripts with an editor](#making-scripts-with-an-editor)
- [Print and set](#print-and-set)
- [If statements](#if-statements)
- [if vs else if](#if-vs-else-if)
- [Until, lock and wait](#until-lock-and-wait)
- [Lists and lexicons](#lists-and-lexicons)
- [Functions](#functions)

---

## Accessing the KOS terminal

To use KOS, you need a KOS processor on your vessel. Find it in the 'control' tab of the editor alongside RCS thrusters and reaction wheels. Right-click the processor to adjust settings.

There are two approaches: create scripts in-game or use a text editor.

### Making scripts in-game

Place your vessel with a KOS processor on the launchpad and right-click it. Press 'open terminal' and click the window that appears.

Create a file by typing:

```
edit hello.
```

Remember the period at the end. Edit your script, then run it with:

```
run hello.
```

Note: In-game scripts disappear when the vessel is gone, as they're stored locally on the processor.

### Making scripts with an editor

Navigate to your KSP folder at `Ships/Script/` and create an empty file. Avoid spaces in filenames and capital letters on Linux systems.

All KOS scripts should end with `.ks`. Example filename:

```
hello.ks
```

Scripts created with editors are stored in the archive, accessible across save games and persistent.

To access the archive:

```
switch to 0.
```

To run `hello.ks`:

```
run hello.
```

---

## Print and set

Start with the `print` command. Type this and press ENTER:

```
print "hello world".  // shows: hello world
```

Everything after `//` is a comment—ignored by the script but helpful for humans.

Example:

```
// print "hello world 1".
print "hello world 2".
```

Only outputs: `hello world 2`

Clear the screen with:

```
clearscreen.
```

Use `set` to store values in variables:

```
set x to "hello world".
```

Now `x` refers to `"hello world"`. Print it:

```
set x to "hello world".
print x. // shows: hello world
```

Key rule: Normal text requires quotes; variables, numbers, and booleans do not.

```
set x to "hello world".
set y to true.
set z to 123.

print x.   // shows: hello world
print "x". // shows: x
print y.   // shows: true
print "y". // shows: y
print z.   // shows: 123
print "z". // shows: z
```

Replace variables:

```
set x to "hello world".
set x to "updated text".
print x. // shows: updated text
```

Copy variables to preserve old values:

```
set x to "hello world".
set y to x.
set x to "updated text".

print y. // shows: hello world
print x. // shows: updated text
```

Use words as variable names (without spaces):

```
set WhateverThisVariableIs to false.
print WhateverThisVariableIs. // shows: false
```

---

## If statements

Check values with `if`:

```
set x to 1.

if x = 1 {
  print "x is one".
}
```

Output: `x is one`

Note: No period after `if`, but curly brackets `{ }` are required for multiple statements. They're optional for single statements:

```
if x = 1
  print "x is one".
```

Use `if` with booleans:

```
set SomeBoolean to true.

if SomeBoolean = true {
  print "this is true".
}
```

### Comparison operators:

- **Equals or greater:** `1 >= 1` or `2 >= 1`
- **Equals or less:** `1 <= 1` or `1 <= 2`
- **Not equal:** `1 <> 2`

Add alternative logic with `else`:

```
set SomeAnimal to "Dog".

if SomeAnimal = "Cat" {
  print "this is a cat".
} else {
  print "this is not a cat".
}
```

Extend with `else if`:

```
set SomeAnimal to "Dog".

if SomeAnimal = "Cat" {
  print "this is a cat".
} else if SomeAnimal = "Dog" {
  print "this is a dog".
} else {
  print "this is neither a cat nor a dog".
}
```

Output: `this is a dog`

---

## if vs else if

### Example 1: Using `else if`

```
if distance <= 1 {
  print "Distance is within a meter.".
} else if distance <= 100 {
  print "Distance is within 100 meters.".
} else {
  print "Distance is farther than 100 m.".
}
```

### Example 2: Using only `if`

```
if distance <= 1 {
  print "Distance is within a meter.".
}
if distance <= 100 {
  print "Distance is within 100 meters.".
}
if distance > 1000 {
  print "Distance is farther than 1 kilometer.".
}
```

With Example 1 and distance < 1 meter: outputs only the first message.

With Example 2: outputs multiple messages, causing unwanted results.

The `else if` approach is cleaner and prevents redundant condition checks.

---

## Until, lock and wait

The `wait` command pauses execution:

```
wait 10.
print "done waiting".
```

Waits 10 seconds before printing. `wait 0` waits one physics tick (useful for maneuvers).

The `until` command loops until a condition is true:

```
set x to 0.
until x > 100 {
  print x.
  set x to x + 1.
}
```

Prints 0 through 100, incrementing each iteration.

### Time and Lock

Get current in-game time:

```
print time:seconds.
```

Store time in a variable:

```
set CurrentTime to time:seconds.
```

This creates a snapshot. The variable doesn't update as time passes:

```
set CurrentTime to time:seconds.
print CurrentTime. // shows: 60
wait 10.
print CurrentTime. // shows: 60
```

Use `lock` for variables that constantly update:

```
lock TimeSecondsPlusTen to time:seconds + 10.
```

At 60 seconds, this prints 70. At 4000 seconds, it prints 4010.

### Using until, lock and wait in an example

```
set Adder to 0.
lock Multiplier to Adder * 2.
set TimePlusFive to time:seconds + 5.

until time:seconds > TimePlusFive {
  print Multiplier.
  set Adder to Adder + 1.
  wait 1.
}
```

Output:

```
0
2
4
6
8
10
```

### Wait until

Pause until a condition is true:

```
set TimePlusFive to time:seconds + 5.
wait until time:seconds > TimePlusFive.
print "done waiting".
```

Takes 5 seconds to complete. The condition is checked once per physics tick.

---

## Lists and lexicons

Create a list:

```
set Value1 to 0.
set Value2 to 5.
set Value3 to 10.
set Value4 to 15.
set Value5 to 20.

set ValueList to list(Value1, Value2, Value3, Value4, Value5).
print ValueList.
```

Output:

```
[0] = 0
[1] = 5
[2] = 10
[3] = 15
[4] = 20
```

Lists are zero-indexed. Access items:

```
print ValueList[2]. // shows 10
```

Loop through lists with `for`:

```
for Whatever in ValueList {
  print Whatever.
}
```

Output:

```
0
5
10
15
20
```

Use variables as indices:

```
set x to 3.
print ValueList[x]. // shows 15
```

### Lexicons

Lexicons store key-value pairs:

```
set MyLexicon to lexicon("MyValue1", 100, "MyValue2", 200, "MyValue3", 300).
```

More readable format:

```
set MyLexicon to lexicon(
  "MyValue1", 100,
  "MyValue2", 200,
  "MyValue3", 300
).
```

Access values by key:

```
print MyLexicon["MyValue1"]. // shows 100
print MyLexicon["MyValue2"]. // shows 200
print MyLexicon["MyValue3"]. // shows 300
```

Note: `MyLexicon[100]` does not work.

---

## Functions

Functions encapsulate reusable code. Basic example:

```
Function OneThroughFivePrint {
  print 1.
  print 2.
  print 3.
  print 4.
  print 5.
}
```

Call it:

```
OneThroughFivePrint().
```

Output:

```
1
2
3
4
5
```

### Functions with parameters

Add parameters for flexibility:

```
Function VelocityCalculator {
  Parameter OrbitHeight.

  set KerbinRadius to 600000.
  set TotalRadius to OrbitHeight + KerbinRadius.
  set OrbitalPeriod to ship:orbit:period.
  print (2 * 3.1416 * TotalRadius) / OrbitalPeriod.
}
```

Call with a parameter:

```
VelocityCalculator(400000).
```

### Return values

Use `return` to send data back:

```
Function VelocityCalculator {
  Parameter OrbitHeight.

  set KerbinRadius to 600000.
  set TotalRadius to OrbitHeight + KerbinRadius.
  set OrbitalPeriod to ship:orbit:period.
  return (2 * 3.1416 * TotalRadius) / OrbitalPeriod.
  // everything after return is skipped
  print "this will be skipped".
}

set CurrentVelocity to VelocityCalculator(400000).
print CurrentVelocity.
```

---

## Suffixes

Access orbital information using suffixes:

```
print ship:orbit:apoapsis.    // shows the ship's apoapsis
print kerbin:orbit:apoapsis.  // shows kerbin's apoapsis
print ship:body:orbit:apoapsis. // shows kerbin's apoapsis if orbiting kerbin
```

Other orbit properties:

```
print ship:orbit:periapsis.      // shows periapsis
print ship:orbit:period.         // shows orbital period
print ship:orbit:inclination.    // shows inclination
print ship:orbit:eccentricity.   // shows eccentricity
print ship:orbit:semimajoraxis.  // shows semimajor axis
```

Access celestial body properties:

```
print kerbin:name.     // shows kerbin
print kerbin:mass.     // shows kerbin's mass
print kerbin:radius.   // shows kerbin's radius
print kerbin:mu.       // shows gravitational parameter
```

When orbiting kerbin:

```
print ship:body:name.     // shows kerbin
print ship:body:mass.     // shows kerbin's mass
print ship:body:radius.   // shows kerbin's radius
print ship:body:mu.       // shows gravitational parameter
```

For complete suffix documentation, see [Orbit Structure Reference](https://ksp-kos.github.io/KOS/structures/orbits/orbit.html) and [Orbitable Structure Reference](https://ksp-kos.github.io/KOS/structures/orbits/orbitable.html).

---

Copyright 2013-2021, Developed and maintained by kOS Team, Originally By Nivekk.
