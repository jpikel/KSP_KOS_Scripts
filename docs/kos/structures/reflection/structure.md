> Source: https://ksp-kos.github.io/KOS/structures/reflection/structure.html (mirrored offline copy for local reference)

# Structure — kOS 1.4.0.0 Documentation

## Overview

The `Structure` type serves as "the root of all kOS data types." Every value in kOS—whether primitive (like `1.0`, `false`, or `"abc"`) or complex—inherits from this base type, providing universal suffixes applicable anywhere.

Examples of type checking:

```
print Mun:typename().
// Body

print ("hello"):typename().
// String

print (12345.678):typename().
// Scalar
```

## Structure Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| `TOSTRING` | String | The string displayed when using PRINT |
| `HASSUFFIX(name)` | Boolean | Tests whether a suffix with the given name exists |
| `SUFFIXNAMES` | List of Strings | Returns all available suffix names |
| `ISSERIALIZABLE` | Boolean | True if compatible with WRITEJSON |
| `TYPENAME` | String | Returns the type name of the object |
| `ISTYPE(name)` | Boolean | True if value is of or derives from the given type |
| `INHERITANCE` | String | Describes the type hierarchy chain |

### TOSTRING

**Type:** String  
**Access:** Get only

Retrieves the string representation that would appear when printing a value, without displaying it.

### HASSUFFIX(name)

**Parameters:**
- **name** – String name of the suffix being tested

**Return type:** Boolean  
**Access:** Get only

Returns `True` if the object possesses the named suffix. The search is case-insensitive. Example with conditional logic:

```
print thingy:hassuffix("maxthrust").
// True for vessels, False for bodies
```

Note: Lexicon objects return `True` for suffix-usable keys.

### SUFFIXNAMES

**Type:** List of Strings  
**Access:** Get only

Returns an alphabetically sorted list of all available suffixes, including inherited ones. Example:

```
set v1 to V(12,41,0.1).
print v1:suffixnames.
// List of 14 items: [0] = DIRECTION, [1] = HASSUFFIX, ...
```

Note: Lexicon objects include suffix-usable keys in this list.

### TYPENAME

**Type:** String  
**Access:** Get only

Returns the kOS type name. Examples:

```
set x to 1.
print x:typename.
// Scalar

set x to ship:parts[2].
print x:typename.
// Part

set x to Mun.
print x:typename.
// Body
```

### ISTYPE(name)

**Parameter:** string name of the type being checked  
**Type:** Boolean  
**Access:** Get only

Returns `True` if the value is of the specified type or derives from it. The search is case-insensitive. Example:

```
set x to SHIP.
print x:istype("Vessel").
// True
print x:istype("Orbitable").
// True
print x:istype("Structure").
// True
print x:istype("Body").
// False
```

### INHERITANCE

**Type:** String  
**Access:** Get only

Displays the complete type inheritance chain. Example:

```
set x to SHIP.
print x:inheritance.
// Vessel derived from Orbitable derived from Structure
```

### ISSERIALIZABLE

**Type:** Boolean  
**Access:** Get only

Returns `True` only if the value's type is compatible with "the built-in serialization function WRITEJSON."
