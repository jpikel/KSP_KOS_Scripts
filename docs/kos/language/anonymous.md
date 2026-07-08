> Source: https://ksp-kos.github.io/KOS/language/anonymous.html (mirrored offline copy for local reference)

# Anonymous Functions (A kind of Delegate)

## Overview

The documentation describes a feature allowing developers to create delegates without explicitly naming functions. These "anonymous functions" can be assigned directly to variables or passed as arguments to other functions.

## Syntax

To create an anonymous function in kerboscript, omit the function name and keyword, using only the curly braces containing the function body:

```
set some_variable to {
  // Function body here
}.
```

The period terminating the statement is mandatory since this represents a SET statement. The variable then holds a KOSDelegate callable via `some_variable()` or `some_variable:call()`.

## Passing Functions to Other Functions

A practical use case involves passing filter logic to functions. The documentation provides an example where a `select_bodies` function accepts a delegate parameter that determines which celestial bodies to include based on custom criteria.

Rather than defining a named function separately, developers can pass an inline anonymous function:

```
local small_bodies is select_bodies( 
  { parameter b. return (b:RADIUS < Mun:RADIUS).} 
).
```

## Lexicon of Functions

Anonymous functions enable creating collections of delegates within lexicons, simulating object-oriented patterns:

```
return LEXICON(
    "isSmall", {return ves:mass < 50.},
    "isBig", {return ves:mass > 150.},
    "circularEnough", {return ves:obt:eccentricity < 0.1.}
).
```

This approach allows treating functions as data, enabling functional programming patterns within kerboscript's capabilities.
