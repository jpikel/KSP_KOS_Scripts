> Source: https://ksp-kos.github.io/KOS/language/delegates.html (mirrored offline copy for local reference)

# Delegates (Function References) — kOS 1.4.0.0 Documentation

## Overview

Delegates allow you to store a reference to a function itself rather than the result of calling it. This enables calling the function later, choosing which function to call dynamically, or passing functions as arguments to other functions.

The feature is provided through a built-in type called `KOSDelegate`.

### Syntax: @ Symbol

To obtain a delegate of a function, place an at-sign (`@`) after the function name where parentheses would normally go:

```kos
// Example function:
function myfunc { parameter a,b. return a+b. }

// Example delegate of that function:
set aaa to myfunc@.
```

This creates a variable of type `KOSDelegate` that can be passed around, copied, or sent as an argument.

Call the function later using the `:call` suffix:

```kos
print aaa:call(1, 2).
```

Complete example:

```kos
function myfunc {
  parameter a,b.
  return a + b.
}

print myfunc(1, 2). // Prints 3, calling myfunc now.
set aaa to myfunc@. // Creates delegate, no execution yet.
print aaa:call(1, 2).  // Prints 3.
```

### Omitting :CALL

You can call a `KOSDelegate` using parentheses directly instead of the `:call` suffix:

```kos
function testfunc {print "test".}
set del to testfunc@.

// These two are equivalent:
del:call().
del().
```

### Why the '@' Sign?

In Kerboscript, mentioning a function name without parentheses—if it takes zero arguments—automatically calls it. The `@` symbol suppresses this automatic invocation, allowing you to obtain the delegate reference instead.

## Why?

Delegates are useful for passing behavior as parameters. For example, create a generic function that filters a list based on a custom condition:

```kos
function make_sublist {
  parameter
    input_list,     // Full list to subset.
    check_func.     // Delegate expecting 1 number, returning 1 number.

  local result is list().
  for num in input_list {
    if check_func:call(num) {
      result:add(num).
    }
  }
  return result.
}

// Example data:
local numlist is LIST(5, 6, 1, 49.1, 10, -2, 0, -12, 50, 0.3, 1.2, -1, 0).

function is_neg { parameter n. return (n < 0). }
function is_round { parameter n. return (n = round(n,0)). }
function is_even { parameter n. return (mod(n,2) = 0). }

print "A list of all the negatives:".
print make_sublist(numlist, is_neg@).

print "A list of all the round numbers:".
print make_sublist(numlist, is_round@).

print "A list of all the even numbers:".
print make_sublist(numlist, is_even@).
```

This technique enables functional programming patterns in Kerboscript, allowing powerful operations on data collections.

## Anonymous Functions

Create delegates from anonymous functions without the `@` character, since anonymous functions are already delegates:

```kos
set add_func to { parameter a,b. return a+b. }.
// add_func is now a KOSDelegate of the anonymous function.
```

The `lib_enum` library in KSLib provides many enumeration and data manipulation operations using delegates.

## Advanced Topics

### Can't Call Dead Delegates

If a `KOSDelegate` references user program code that no longer exists, it becomes "DEAD" and cannot be called. Test for this using the `KOSDelegate:ISDEAD` suffix.

### Pre-binding Arguments with :bind

Bind parameters to pre-set values, requiring only remaining parameters at call time:

```kos
function draw_ship_to_ship {
  parameter
    ship1,
    ship2,
    drawColor.

  local vdraw is vecdraw().
  set vdraw:start to ship1:position.
  set vdraw:vec to ship2:position - ship1:position.
  set vdraw:color to drawColor.
  set vdraw:show to true.
  return vdraw.
}

local draw_delegate is draw_ship_to_ship@.
local draw_a_to_b is draw_delegate:bind(shipA, shipB).

// Call with only the color parameter:
set greenvec to draw_a_to_b(green).
set tanvec to draw_a_to_b(rgb(0.7,0.6,0)).
set whitevec to draw_a_to_b(white).
```

Combine binding and delegate creation in one expression:

```kos
local draw_a_to_b is draw_ship_to_ship@:bind(shipA, shipB).
```

### Currying

Bind parameters one at a time in a chain:

```kos
// V() is the built-in function making vectors.
local vecx is V@:bind(10).      // Hardcodes x to 10.
local vecxy is vecx:bind(5).    // Hardcodes y to 5.
local vecxyz is vecxy:bind(1).  // Hardcodes z to 1.
local vec is vecxyz:call().     // Creates V(10, 5, 1).

// Or chain on one line:
local vec is V@:bind(10):bind(5):bind(1):call().
```

This transforms a multi-argument function into nested single-argument functions, named after mathematician Haskell Curry.

### Closures

`KOSDelegate` objects of user functions retain closure information, remembering local variables at creation time. Delegates can access local variables from their original scope even when called from elsewhere.

## Kinds of Delegate (No Suffixes)

kOS handles different function types internally. As of version 1.1.5.2, you cannot reliably make delegates of structure suffixes.

**You CAN make delegates of:**

- User functions implemented in Kerboscript:

```kos
function mysquarefunc { parameter a. return a*a. }
set x to mysquarefunc@.
set y to x:call(5). // y is 25.
```

- Built-in kOS functions (non-suffix):

```kos
set r to round@.
set s to sqrt@.
print "square root of 7, to 2 places: " + r:call(s:call(7), 2).
```

**You CANNOT make delegates of:**

- Structure suffixes (yet):

```kos
// WON'T WORK:
set altpos to latlng(10,20):altitudeposition@.

// Workaround: wrap in a user function:
function get_altpos { parameter alt. return latlng(10,20):altitudeposition(alt). }
set altpos to get_altpos@.
```
