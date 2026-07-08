> Source: https://ksp-kos.github.io/KOS/language/features.html (mirrored offline copy for local reference)

# General Features of the KerboScript Language

## Overview

KerboScript is the scripting language for the kOS mod. This documentation page covers fundamental language characteristics including case insensitivity, expression evaluation, typing behavior, and special features like triggers.

## Key Language Characteristics

**Case Insensitivity**: "Everything in KerboScript is case-insensitive, including your own variable names and filenames. This extends to string comparison as well."

**Dynamic Typing**: Variables can hold any type of object and change types at runtime based on assignments.

**Lazy Globals**: Variables don't require pre-declaration. Assigning a value to an undefined variable automatically creates it as a global variable. This behavior can be disabled with `@LAZYGLOBAL OFF`.

## Expression Types

The language supports four basic expression types:

- **Numbers (Scalars)**: Mathematical operations follow standard order of operations
- **Strings**: Text values that can be concatenated using the `+` operator
- **Booleans**: True/False values for conditional checks
- **Structures**: Complex types containing multiple sub-values accessed via colon (`:`) operator

## Structure Access

Structures allow accessing nested information:

```
PRINT "The Mun's periapsis altitude is: " + MUN:PERIAPSIS.
PRINT "The ship's surface velocity is: " + SHIP:VELOCITY:SURFACE.
```

Structure methods can perform actions and accept parameters for operations on contained data.

## Boolean Short-Circuiting

The language implements short-circuit evaluation for AND/OR operations, meaning unnecessary calculations are skipped once the result is determined.

## User Functions and Triggers

Users can define custom functions using the `DECLARE FUNCTION` syntax. The language also supports triggers—interrupt-driven code sections activated by conditions—using `WHEN` and `ON` statements.
