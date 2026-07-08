> Source: https://ksp-kos.github.io/KOS/structures/collections/lexicon.html (mirrored offline copy for local reference)

# Lexicon — kOS 1.4.0.0 Documentation

## Lexicon

A `Lexicon` is an associative array, similar to the `LIST` type. Unlike normal arrays that use integer positions, lexicons store key-value pairs where keys can be any type.

### Basic Example

```
set arr to lexicon().
arr:add( "ABC", 1234.1 ).
arr:add( "Carmine", 4.1 ).
print arr["ABC"]. // prints 1234.1
print arr["Carmine"]. // prints 4.1
```

### Lexicons are Case-Insensitive

By default, kerboscript lexicons use case-insensitive keys when keys are strings. This behavior can be changed with the `:CASESENSITIVE` flag.

### Constructing a Lexicon

**Empty lexicon:**
```
set mylexicon to lexicon().
```

**With arguments (alternating keys and values):**
```
set mylexicon to lexicon("key1", "value1", "key2", "value2").
```

**From an enumerable:**
```
set mylist to list("key1", "value1", "key2", "value2").
set mylexicon to lexicon(mylist).
```

### Lexicons Can Use Suffix Syntax

Lexicons support special dot notation for key access:

```
local mylex is lexicon(
  "key1", "value1", "key2", "value2", "key3", "value3").
print mylex:key1. // prints "value1".
print mylex:key2. // prints "value2".
print mylex:key3. // prints "value3".
```

This is equivalent to square-bracket syntax:
```
print mylex["key1"].
print mylex:key1.
```

**The key must follow valid identifier rules** to use suffix syntax:

```
local mylex is lexicon(
  "key_no_spaces", 100, "key with spaces", 200).
print mylex["key_no_spaces"].   // Works
print mylex["key with spaces"]. // Works
print mylex:key_no_spaces.      // Works
print mylex:key with spaces.    // ERROR
```

**Keys must exist before access:**

```
local mylex is lexicon().
print mylex:mykey. // Error: key doesn't exist yet
set mylex["mykey"] to "value".

// Correct order:
local mylex is lexicon().
set mylex["mykey"] to "value".
print mylex:mykey. // Works
```

### Clashes Between Built-in Suffixes and Lexicon Keys

kOS prefers built-in suffix names over lexicon keys:

```
local mylex is lexicon().
set mylex["LENGTH"] to 20.

print mylex:length. // prints 1 (the built-in suffix)
print mylex["length"]. // prints 20 (the key)
```

### Suffix Keys Work with HASSUFFIX and SUFFIXNAMES

Lexicon keys that are valid identifiers will be included in `SUFFIXNAMES` output and return `true` for `HASSUFFIX` checks.

## Structure

### Lexicon

| Suffix | Type | Description |
|--------|------|-------------|
| `ADD(key,value)` | None | Append an item to the lexicon |
| `CASESENSITIVE` | Boolean | Changes the behavior of string-based keys; by default case insensitive. Setting this clears the lexicon. |
| `CASE` | Boolean | Synonym for CASESENSITIVE |
| `CLEAR` | None | Remove all items in the lexicon |
| `COPY` | Lexicon | Returns a (shallow) copy of the lexicon's contents |
| `DUMP` | String | Verbose dump of all contained elements |
| `HASKEY(keyvalue)` | Boolean | Does the lexicon have a key of the given value? |
| `HASVALUE(value)` | Boolean | Does the lexicon have a value of the given value? |
| `KEYS` | List | Gives a flat List of the keys in the lexicon |
| `VALUES` | List | Gives a flat List of the values in the lexicon |
| `LENGTH` | Scalar | Number of pairs in the lexicon |
| `REMOVE(keyvalue)` | None | Removes the pair with the given key |
| `HASSUFFIX(name)` | Boolean | True if the suffix OR a key with the name exists |
| `SUFFIXNAMES` | List of strings | Gives both the suffixes AND the keys that work as suffixes |

**Note:** This type is serializable.

### Lexicon:ADD(key, value)

**Parameters:**
- **key** – (any type) a unique key
- **value** – (any type) a value to be associated with the key

Adds an additional pair to the lexicon.

### Lexicon:CASESENSITIVE

**Type:** Boolean  
**Access:** Get or Set

Controls case sensitivity behavior for string keys. By default, all kerboscript lexicons use case-insensitive keys, meaning `mylexicon["AAA"]` is the same as `mylexicon["aaa"]`. Setting this to `true` makes them different.

Changing this value clears the entire contents of the lexicon to avoid potential key clashes. Set this only on new lexicons immediately after creation.

### Lexicon:CASE

**Type:** Boolean  
**Access:** Get or Set

Synonym for CASESENSITIVE.

### Lexicon:REMOVE(key)

**Parameters:**
- **key** – The keyvalue of the pair to be removed

Removes the pair with the given key from the lexicon.

### Lexicon:CLEAR()

Removes all pairs from the lexicon, making it empty.

### Lexicon:LENGTH

**Type:** Scalar  
**Access:** Get only

Returns the number of pairs in the lexicon.

### Lexicon:COPY()

**Return type:** Lexicon  
**Access:** Get only

Returns a new lexicon containing the same pairs as this lexicon. This is a "shallow" copy, meaning that if a value refers to another Lexicon, Vessel, or Part, the new copy still refers to the same object.

### Lexicon:HASKEY(key)

**Parameters:**
- **key** – (any type)

**Returns:** Boolean

Returns true if the lexicon contains the provided key.

### Lexicon:HASVALUE(key)

**Parameters:**
- **key** – (any type)

**Returns:** Boolean

Returns true if the lexicon contains the provided value.

### Lexicon:DUMP

**Type:** String  
**Access:** Get only

Returns a string containing a verbose dump of the lexicon's contents.

The difference between `DUMP` and normal printing is that `DUMP` recursively shows the contents of every complex object inside the lexicon:

```
// Just gives a shallow list:
print mylexicon.

// Walks the entire tree of contents, descending into
// any Lists or Lexicons stored inside this Lexicon:
print mylexicon:dump.
```

### Lexicon:KEYS

**Type:** List  
**Access:** Get only

Returns a List of the keys stored in this lexicon.

### Lexicon:VALUES

**Type:** List  
**Access:** Get only

Returns a List of the values stored in this lexicon.

### Lexicon:HASSUFFIX(name)

**Parameters:**
- **name** – String name of the suffix being tested for

**Return type:** Boolean  
**Access:** Get only

Similar to `Structure:HASSUFFIX(name)`, but also returns `true` if the name matches one of the lexicon's keys that could be used with the lexicon suffix syntax.

### Lexicon:SUFFIXNAMES

**Type:** List of strings  
**Access:** Get only

All structures have a `SUFFIXNAMES` attribute showing their suffixes. For lexicons, this additionally includes any keys that could be called using the lexicon suffix syntax.

## Access to Individual Elements

`lexicon[expression]` – Another syntax to access elements. Works for get or set. Any arbitrary complex expression may be used, not just a number or variable name.

`FOR VAR IN LEXICON:KEYS { ... }.` – A type of loop in which var iterates over all items of the lexicon from item 0 to item LENGTH-1.

## Implicit ADD When Using Index Brackets with New Key Values

### (The Difference Between GETTING and SETTING with Nonexistent Keys)

Attempting to GET a value with a nonexistent key produces an error:

```
SET ARR TO LEXICON().
SET X TO ARR["somekey"].  // Error: KOSKeyNotFoundException
```

However, using a nonexistent key to SET a value implicitly adds it:

```
SET ARR TO LEXICON().
SET ARR["somekey"] TO 100. // Adds new value to the lexicon.
```

This is equivalent to:
```
SET ARR TO LEXICON().
ARR:ADD("somekey",100).
```

Using `ADD()` produces a duplicate key error if the key exists:

```
SET ARR TO LEXICON().
ARR:ADD("somekey",100).
ARR:ADD("somekey",200).  // Error: duplicate key
```

Using SET with brackets replaces the existing value without error:

```
SET ARR TO LEXICON().
SET ARR["somekey"] to 100.
SET ARR["somekey"] to 200. // No error: replaces value
```

In summary: Using `[..]` to set a value either replaces the existing value (if the key exists) or creates a new key-value pair (if the key doesn't exist).

## Examples

```
SET BAR TO LEXICON().       // Creates a new empty lexicon in BAR variable
BAR:ADD("FIRST",10).        // Adds a new element with key "FIRST"
BAR:ADD("SECOND",20).       // Adds a new element with key "SECOND"
BAR:ADD("LAST",30).         // Adds a new element with key "LAST"

PRINT BAR["FIRST"].         // Prints 10
PRINT BAR["SECOND"].        // Prints 20
PRINT BAR["LAST"].          // Prints 30

SET FOO TO LEXICON().           // Creates a new empty lexicon in FOO variable
FOO:ADD("ALTITUDE", ALTITUDE).  // Adds current altitude number to the lexicon
FOO:ADD("ETA", ETA:APOAPSIS).   // Adds current seconds to apoapsis

// At this point, the lexicon would be:
//
//  FOO["ALTITUDE"] = 99999. // or whatever your altitude was when you added it.
//  FOO["ETA"] = 99. // or whatever your ETA:APOAPSIS was when you added it.

PRINT FOO:LENGTH.        // Prints 2
PRINT FOO:LENGTH().      // Also prints 2. LENGTH can omit parentheses.
SET x TO "ALTITUDE". PRINT FOO[x].  // Prints the same as FOO["ALTITUDE"].

FOO:REMOVE("ALTITUDE").  // Removes the "ALTITUDE" element from the lexicon.
```
