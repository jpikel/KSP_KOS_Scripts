> Source: https://ksp-kos.github.io/KOS/language/syntax.html (mirrored offline copy for local reference)

# KerboScript Syntax Specification

## Overview

This documentation describes syntax rules for the KerboScript programming language used in kOS 1.4.0.0. It covers what constitutes valid and invalid syntax, excluding information about specific function calls or built-in variables (covered elsewhere).

## General Rules

**Whitespace Treatment**: Spaces, tabs, and line breaks are treated identically, so indentation is flexible and user-defined.

**Statement Termination**: All statements end with a period (`.`).

### Arithmetic Operators (by precedence)

- `( )` — Grouping/parentheses
- `e` — Scientific notation (e.g., `1.23e-4` = `0.000123`)
- `^` — Exponent (e.g., `2^3` = `8`)
- `*`, `/` — Multiplication and division (equal precedence; division preserves remainders as decimals)
- `+`, `-` — Addition and subtraction (equal precedence)

### Logic Operators (by precedence)

- `( )` — Grouping
- `not` — Logical inversion
- `=`, `<>`, `>=`, `<=`, `>`, `<` — Comparators (note: equals is single `=`, not-equals is `<>`)
- `and` — Logical AND
- `or` — Logical OR

**Logic Constants**: `true`, `false` (case-insensitive). Numbers in boolean contexts follow convention: zero = false, non-zero = true.

### Reserved Keywords

add, all, at, break, choose, clearscreen, compile, copy, declare, defined, delete, do, edit, else, file, for, from, function, global, if, in, is, list, local, lock, log, off, on, once, parameter, preserve, print, reboot, remove, rename, return, run, runoncepath, runpath, set, shutdown, stage, step, switch, then, to, toggle, unlock, unset, until, volume, wait, when

### Other Symbols

- `//` — Comment (to end of line)
- `( )` — Expression grouping or function parameters
- `{ }` — Statement blocks
- `[ ]` — List or lexicon indexing
- `#` — Legacy list indexing (mostly superseded by `[ ]`)
- `,` — Argument/parameter separator
- `:` — Suffix operator (like dot notation in other languages)
- `@` — Delegate operator (suppresses immediate function calls)

### Comments

Everything from `//` to the end of line is a comment:

```
set x to 1. // this is a comment.
```

### Identifiers

Identifiers consist of letters, digits, or underscores, with the first character being a letter or underscore.

**Case-Insensitive**: `my_variable`, `My_Variable`, and `MY_VARIABLE` are identical.

**Unicode Support** (v1.1.0+): UTF-8 encoded source code supported; includes accented Latin, Cyrillic, and other alphabets with Unicode-defined letter distinctions.

**String Comparison**: String comparisons are case-insensitive throughout the language.

```
if "hello" = "HELLO" {
    print "equal".
} else {
    print "unequal".
}
```

## Suffixes

Some variable types contain sub-portions accessed via the colon (`:`) operator. The right-hand side is the "suffix":

```
list parts in mylist.
print mylist:length. // length is a suffix of mylist
```

Suffixes can be chained:

```
print ship:velocity:orbit:x.
```

In this example: "`velocity` is a suffix of `ship`"; "`orbit` is a suffix of `ship:velocity`"; "`x` is a suffix of `ship:velocity:orbit`".

## Numbers (Scalars)

Numbers are called "scalars" to distinguish them from vectors. Valid formats include:

```
12345678
12_345_678 (underscores ignored as visual spacers)
12345.6789
12_345.6789
-12345678
1.123e12
1.234e-12
```

**Limitations**: No imaginary numbers, irrational numbers, or non-terminating decimal rationals. Under the hood, numbers store as 32-bit integers or 64-bit double floats, but this is largely transparent to programmers.

## Braces (Statement Blocks)

Braces group multiple statements into a single block. Single-statement contexts can be written without braces:

```
if x = 1
  print "it's 1".
```

Multiple statements require braces:

```
if x = 1 {
  print "it's 1".
  print "yippieee.".
}
```

Braces can be inserted anywhere to create local scopes:

```
declare x to 3.
print "x here is " + x.
{
  declare x to 5.
  print "x here is " + x.
  {
    declare x to 7.
    print "x here is " + x.
  }
}
```

Each `x` is a different variable with different scope.

## Functions (Built-in)

Built-in functions are called with parentheses:

```
print ROUND(1230.12312, 2).
print SIN(45).
```

Zero-argument functions may omit parentheses:

```
CLEARSCREEN.
CLEARSCREEN().
```

## Suffixes as Functions (Methods)

Some suffixes are callable functions:

```
set x to ship:partsnamed("rtg").
print x:length().
x:remove(0).
x:clear().
```

## Suffixes as Lexicon Keys

The `Lexicon` type supports suffix notation as an alternate key syntax:

```
set MyLex to Lexicon().
MyLex:ADD("key1", "value1").
print MyLex["key1"]. // traditional indexing
print MyLex:key1.    // suffix syntax
```

(See Lexicon documentation for limitations on this syntax.)

## User Functions

User-defined functions are created with `DECLARE FUNCTION`:

```
declare function identifier {
    statements
}
```

The optional period at the end is permitted.

Functions allow code to jump to a reusable block, execute it, and return to the original location. Detailed documentation is available in the [User Functions section](user_functions.html).

## Built-In Special Variable Names

Certain variable names have reserved meaning and cannot be used as identifiers. These variables query flight state information and are essential to kOS. [The full list is in the bindings documentation](../bindings.html#bindings).

## What Does Not Exist (Yet?)

**User-Made Structures or Classes**: While kOS includes built-in classes with methods and fields, users cannot create custom classes or structures. Supporting this would increase complexity significantly and has not yet been prioritized.
