> Source: https://ksp-kos.github.io/KOS/structures/misc/string.html (mirrored offline copy for local reference)

# String Structure Documentation - kOS 1.4.0.0

## Overview

A `String` is an immutable sequence of characters in kOS. Once created, strings cannot be directly modified, though new strings can be derived from existing ones.

## Creating Strings

Strings use special syntax for creation:

```kos
SET s TO "Hello, Strings!".
```

Since strings are immutable, modifications create new strings:

```kos
SET s TO "Hello, Strings!".
SET t TO s:REPLACE("Hello", "Goodbye").
```

## Accessing Individual Characters

### Using an Iterator (FOR Loop)

Strings can be iterated over like lists:

```kos
LOCAL str is "abcde".

FOR c IN str {
  PRINT c.  // prints "a" the first time, then "b", etc.
}
```

### Using Index Notation

Characters can be accessed by index (zero-based):

```kos
LOCAL str is "abcde".
local index is 0.
until index = str:LENGTH {
  print str[index].
  set index to index + 1.
}
```

**Note:** Strings are read-only via indexing. This will error:

```kos
set str[0] to "X".  // ERROR - cannot modify string characters
```

## Boolean Operators

### Equality

The `=` and `<>` operators compare strings. Comparison is **case-insensitive**: "a" and "A" are treated as identical.

### Ordering

The `<`, `>`, `<=`, `>=` operators compare strings alphabetically by Unicode value (case-insensitive). Comparison proceeds left-to-right until a difference is found. If one string is shorter and all compared characters match, the shorter string is "less than."

### Mixing Strings and Non-Strings

When comparing a string with a non-string, the non-string converts to its string representation first:

```kos
print (1234 < 99).    // prints "False" (numeric comparison)
print ("1234" < 99).  // prints "True" (string comparison: "1" < "9")
```

### Case Sensitivity Note

All string comparisons, substring matches, pattern matches, and searches are **case-insensitive** by default. The only way to force case-sensitive comparison is to examine characters individually using the `unchar()` function.

## Structure Members

| Suffix | Type | Description |
|--------|------|-------------|
| `CONTAINS(string)` | Boolean | True if the given string is contained within this string |
| `ENDSWITH(string)` | Boolean | True if this string ends with the given string |
| `FIND(string)` | Scalar | Returns the index of first occurrence (0-based), or -1 if not found |
| `FINDAT(string, startAt)` | Scalar | Returns index of first occurrence starting from `startAt`, or -1 |
| `FINDLAST(string)` | Scalar | Returns the index of last occurrence, or -1 if not found |
| `FINDLASTAT(string, startAt)` | Scalar | Returns index of last occurrence starting from `startAt`, or -1 |
| `INDEXOF(string)` | Scalar | Alias for `FIND(string)` |
| `INSERT(index, string)` | String | Returns new string with given string inserted at index |
| `ITERATOR` | Iterator | Generates an iterator object over characters |
| `LASTINDEXOF(string)` | Scalar | Alias for `FINDLAST(string)` |
| `LENGTH` | Scalar (integer) | Number of characters in the string (read-only) |
| `MATCHESPATTERN(pattern)` | Boolean | Tests if string matches the given regex pattern |
| `PADLEFT(width)` | String | Returns right-aligned string padded to width with spaces |
| `PADRIGHT(width)` | String | Returns left-aligned string padded to width with spaces |
| `REMOVE(index, count)` | String | Returns new string with `count` characters removed starting at `index` |
| `REPLACE(oldString, newString)` | String | Returns new string with all occurrences of `oldString` replaced |
| `SPLIT(separator)` | List | Breaks string into list of strings at each separator occurrence |
| `STARTSWITH(string)` | Boolean | True if this string starts with the given string |
| `SUBSTRING(start, count)` | String | Returns new string with `count` characters starting from position `start` |
| `TOLOWER` | String | Returns new string with all characters in lowercase (read-only) |
| `TOUPPER` | String | Returns new string with all characters in uppercase (read-only) |
| `TRIM` | String | Returns new string with no leading or trailing whitespace (read-only) |
| `TRIMEND` | String | Returns new string with no trailing whitespace (read-only) |
| `TRIMSTART` | String | Returns new string with no leading whitespace (read-only) |
| `TONUMBER(defaultIfError)` | Scalar | Parses string as number; returns `defaultIfError` on error |
| `TOSCALAR(defaultIfError)` | Scalar | Alias for `TONUMBER(defaultIfError)` |

## Method Details

### String:CONTAINS(string)

Returns `True` if the given string is contained anywhere within this string.

### String:ENDSWITH(string)

Returns `True` if this string ends with the given string.

### String:FIND(string)

Returns the index (0-based) of the first occurrence of the given string. Returns -1 if not found. Empty string `""` always returns 0 (matches at start).

### String:FINDAT(string, startAt)

Returns the index of the first occurrence of the given string, searching from position `startAt`. Returns -1 if not found. Empty string `""` always returns the start position.

### String:FINDLAST(string)

Returns the index of the last occurrence of the given string. Returns -1 if not found. Empty string `""` always matches.

### String:FINDLASTAT(string, startAt)

Returns the index of the last occurrence of the given string, searching backward from position `startAt`. Returns -1 if not found.

### String:INDEXOF(string)

Alias for `FIND(string)`.

### String:INSERT(index, string)

Returns a new string with the given string inserted at the specified index position.

### String:ITERATOR

Access only. Returns an iterator object enabling character-by-character iteration (used implicitly in FOR loops).

### String:LASTINDEXOF(string)

Alias for `FINDLAST(string)`.

### String:LENGTH

Read-only. Returns the number of characters in the string.

### String:MATCHESPATTERN(pattern)

Returns `True` if the string matches the given regular expression pattern. The match is not anchored—"foo" matches "foobar", "barfoo", and "barfoobar". Use `^` to anchor to start and `$` to anchor to end.

### String:PADLEFT(width)

Returns a new right-aligned string padded to the specified width with spaces.

### String:PADRIGHT(width)

Returns a new left-aligned string padded to the specified width with spaces.

### String:REMOVE(index, count)

Returns a new string with `count` characters removed starting at the specified index.

### String:REPLACE(oldString, newString)

Returns a new string with all occurrences of `oldString` replaced by `newString`.

### String:SPLIT(separator)

Breaks the string into a list of smaller strings at each occurrence of the separator. The separator itself is not included in the resulting strings.

### String:STARTSWITH(string)

Returns `True` if this string starts with the given string.

### String:SUBSTRING(start, count)

Returns a new string containing `count` characters starting from position `start` (0-based).

### String:TOLOWER

Read-only. Returns a new string with all characters converted to lowercase.

### String:TOUPPER

Read-only. Returns a new string with all characters converted to uppercase.

### String:TRIM

Read-only. Returns a new string with all leading and trailing whitespace removed.

### String:TRIMEND

Read-only. Returns a new string with all trailing whitespace removed.

### String:TRIMSTART

Read-only. Returns a new string with all leading whitespace removed.

### String:TONUMBER(defaultIfError)

Parses the string as a numeric value. The optional `defaultIfError` parameter is returned if parsing fails. Without this parameter, a parsing error halts the script.

Supported formats include optional leading sign, decimal point, fractional parts, and scientific notation (e.g., "1.23e3" = 1230, "1.23e-3" = 0.00123). Underscores can be included to space digit groups and are ignored (e.g., "1_000").

Examples:

```kos
set str to "16.8".
print "half of " + str + " is " + str:tonumber() / 2.
// Output: half of 16.8 is 8.4

set str to "Garbage 123".
set val to str:tonumber(-9999).
if val = -9999 {
  print "that string isn't a number".
}

set str to "Garbage".
set val to str:tonumber().  // Script errors here
```

### String:TOSCALAR(defaultIfError)

Alias for `TONUMBER(defaultIfError)`.

## Complete Example

```kos
SET s TO "Hello, Strings!".
PRINT "Original String:               " + s.                    // Hello, Strings!
PRINT "string[7]:                     " + s[7].                 // S
PRINT "LENGTH:                        " + s:LENGTH.             // 15
PRINT "SUBSTRING(7, 6):               " + s:SUBSTRING(7, 6).    // String
PRINT "CONTAINS('ring'):              " + s:CONTAINS("ring").   // True
PRINT "CONTAINS('bling'):             " + s:CONTAINS("bling").  // False
PRINT "ENDSWITH('ings!'):             " + s:ENDSWITH("ings!").  // True
PRINT "ENDSWITH('outs!'):             " + s:ENDSWITH("outs").   // False
PRINT "FIND('l'):                     " + s:FIND("l").          // 2
PRINT "FINDLAST('l'):                 " + s:FINDLAST("l").      // 3
PRINT "FINDAT('l', 0):                " + s:FINDAT("l", 0).     // 2
PRINT "FINDAT('l', 3):                " + s:FINDAT("l", 3).     // 3
PRINT "FINDLASTAT('l', 9):            " + s:FINDLASTAT("l", 9). // 3
PRINT "FINDLASTAT('l', 2):            " + s:FINDLASTAT("l", 2). // 2
PRINT "INSERT(7, 'Big '):             " + s:INSERT(7, "Big ").  // Hello, Big Strings!

PRINT " ".
PRINT "                               |------ 18 ------|".
PRINT "PADLEFT(18):                   " + s:PADLEFT(18).        //    Hello, Strings!
PRINT "PADRIGHT(18):                  " + s:PADRIGHT(18).       // Hello, Strings!
PRINT " ".

PRINT "REMOVE(1, 3):                  " + s:REMOVE(1, 3).               // Ho, Strings!
PRINT "REPLACE('Hell', 'Heaven'):     " + s:REPLACE("Hell", "Heaven").  // Heaveno, Strings!
PRINT "STARTSWITH('Hell'):            " + s:STARTSWITH("Hell").         // True
PRINT "STARTSWITH('Heaven'):          " + s:STARTSWITH("Heaven").       // False
PRINT "TOUPPER:                       " + s:TOUPPER().                  // HELLO, STRINGS!
PRINT "TOLOWER:                       " + s:TOLOWER().                  // hello, strings!

PRINT " ".
PRINT "'  Hello!  ':TRIM():           " + "  Hello!  ":TRIM().          // Hello!
PRINT "'  Hello!  ':TRIMSTART():      " + "  Hello!  ":TRIMSTART().     // Hello!
PRINT "'  Hello!  ':TRIMEND():        " + "  Hello!  ":TRIMEND().       //   Hello!

PRINT " ".
PRINT "Chained: " + "Hello!":SUBSTRING(0, 4):TOUPPER():REPLACE("ELL", "ELEPHANT").
// Output: HELEPHANT
```
</content>
