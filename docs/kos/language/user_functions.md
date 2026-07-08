> Source: https://ksp-kos.github.io/KOS/language/user_functions.html (mirrored offline copy for local reference)

# KerboScript User Functions Documentation

## Overview

This documentation covers user-defined functions in KerboScript, the scripting language for the kOS mod. Functions allow you to create reusable blocks of code that can be called from your programs.

## Key Concepts

### Function Declaration

Functions are declared using the `DECLARE FUNCTION` command with this syntax:

```
[declare] [local|global] function identifier { statements }
```

Examples of valid declarations:

```kerboscript
function hi { print "hello". }
local function hi { print "hello". }
global function hi { print "hello". }
```

### Scope Rules

When `local` or `global` keywords are omitted, the default depends on location:
- **Outermost file scope**: defaults to `global`
- **Inside braces**: defaults to `local`

### Parameters and Arguments

Functions accept parameters using `DECLARE PARAMETER` or `PARAMETER` statements:

```kerboscript
function print_corner {
  parameter mode.
  parameter text.
  
  local row is 0.
  local col is 0.
  
  if mode = 2 or mode = 4 {
    set col to terminal:width - text:length.
  }.
  if mode = 3 or mode = 4 {
    set row to terminal:height - 1.
  }.
  
  print text at (col, row).
}.

print_corner(4,"That's me in the corner").
```

### Optional Parameters

Parameters can have default values using the `IS` keyword:

```kerboscript
FUNCTION MYFUNC {
  PARAMETER P1, P2, P3 is 0, P4 is "cheese".
  print P1 + ", " + P2 + ", " + P3 + ", " + P4.
}

MYFUNC(1,2).         // prints "1, 2, 0, cheese"
MYFUNC(1,2,3).       // prints "1, 2, 3, cheese"
MYFUNC(1,2,3,"hi").  // prints "1, 2, 3, hi"
```

**Important**: Mandatory parameters cannot follow optional ones.

### Local Variables

Use `LOCAL` or `DECLARE LOCAL` for function-scoped variables:

```kerboscript
declare x to 5.
local y is 2*x - 1.
declare local halfSpeed to SHIP:VELOCITY:ORBIT:MAG / 2.
```

**Note**: Initializers are mandatory for `DECLARE` statements in current versions.

### Return Values

Functions can return values using the `RETURN` statement:

```kerboscript
declare function north_velocity {
  declare parameter which_vessel.
  
  return VDOT(which_vessel:velocity:surface, 
              which_vessel:north:vector).
}.
```

## Important Behaviors

### Pass-by-Value (with caveat)

Parameters are passed by value for primitive types—the function receives a copy. Changes to the parameter don't affect the original:

```kerboscript
function embiggen {
  parameter x.
  set x to x + 10.
  print "x has been embiggened to " + x.
}.

set global_val to 30.
embiggen(global_val).
print global_val.  // still prints 30
```

**Exception**: Structures (objects with suffixes) are passed by reference:

```kerboscript
function half_vector {
  parameter vec.
  set vec:x to vec:x/2.
  set vec:y to vec:y/2.
  set vec:z to vec:z/2.
}.

set global_vec to V(10,20,30).
half_vector(global_vec).
print global_vec.  // now v(5,10,15)
```

### Recursion

Recursive functions are supported, provided all variables are declared locally to avoid conflicts across recursive calls.

### Nested Functions

Functions can be declared inside other functions, limiting their scope to the containing function:

```kerboscript
function getMean {
  parameter aList.
  
  function getSum {
    parameter aList.
    local sum is 0.
    for num in aList {
      set sum to sum + num.
    }.
    return sum.
  }.
  
  return getSum(aList) / aList:LENGTH.
}.
```

## Important Restrictions

### Interpreter Compatibility

**Functions cannot be called from the interpreter terminal.** They work only within script programs. Attempting to call program-defined functions from the interactive prompt produces unpredictable errors.

### Calling Without Parentheses

While possible, calling functions without parentheses is discouraged:

```kerboscript
example_function.  // works but not recommended
```

This only works reliably when the function is in the same file.

## Libraries and File Management

### RUN ONCE / RUNONCEPATH

To load libraries with initialization code that should execute only once:

```kerboscript
run once counterlib.
run once counterlib.  // won't re-run
runoncepath("counterlib").  // same effect
```

Example with persistent state:

**counterlib:**
```kerboscript
global current_num is 0.

function counter_next {
   set current_num to current_num + 1.
   return current_num.
}
```

## Common Pitfalls

### Inconsistent Returns

Avoid mixing returns with and without values in the same function, though the compiler won't warn you:

```kerboscript
// Poor design - inconsistent returns
DECLARE FUNCTION foo {
   DECLARE PARAMETER x.
   IF X < 0 {
     RETURN.  // no value
   } ELSE {
     RETURN "hello".  // string value
   }
}
```

### Accidental Globals

Typos in variable names create unintended globals. Use `@LAZYGLOBAL OFF` to enforce explicit declarations:

```kerboscript
@lazyglobal off.

local function mean {
  local sum is 0.
  for item in the_list {
    set dum to sum + item.  // ERROR - 'dum' undefined
  }.
}.
```

## Default Parameter Short-Circuit Logic

Optional parameter initializers execute only when arguments are missing, not when values are provided.
