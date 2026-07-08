> Source: https://ksp-kos.github.io/KOS/structures/collections/list.html (mirrored offline copy for local reference)

# List — kOS 1.4.0.0 Documentation

## Overview

A List is a collection structure in kOS that can contain any type of object. It's commonly returned by system functions like the LIST command, and you can create your own List variables.

## Constructing a List

The `LIST()` function creates lists with optional initial values:

```
set mylist to list().
set mylist to list(10,20,30).
set mylist to list("10","20","30").
set mylist to list( list("a","b","c"), list(1,2,3) ).
```

Lists can contain heterogeneous types and can be nested for multidimensional arrays.

## Structure Definition

**List** is an Enumerable structure with the following methods and attributes:

| Suffix | Type | Description |
|--------|------|-------------|
| `ADD(item)` | None | Append an item |
| `INSERT(index,item)` | None | Insert item at index |
| `REMOVE(index)` | None | Remove item by index |
| `CLEAR()` | None | Remove all elements |
| `COPY` | List | New copy of this list |
| `SUBLIST(index,length)` | List | New list subset |
| `JOIN(separator)` | String | Join elements into string |
| `FIND(item)` | Scalar | First index of item |
| `INDEXOF(item)` | Scalar | Alias for FIND |
| `FINDLAST(item)` | Scalar | Last index of item |
| `LASTINDEXOF(item)` | Scalar | Alias for FINDLAST |

## Method Details

### List:ADD(item)
Appends a new value to the end of the list.

### List:INSERT(index,item)
Inserts a value at the specified position (0-indexed), shifting other elements right.

### List:REMOVE(index)
Removes the item at the given index.

### List:CLEAR()
Removes all items from the list.

### List:COPY
Returns a new list containing the same elements.

### List:SUBLIST(index,length)
Returns a new list containing a subset starting at the given index with the specified length.

### List:JOIN(separator)
Returns a string created by converting each element to a string, separated by the given separator.

### List:FIND(item)
Returns the first index where the item is found, or `-1` if not found. Uses linear search.

### List:INDEXOF(item)
Alias for `FIND(item)`.

### List:FINDLAST(item)
Same as `FIND(item)` but searches backward from the end.

### List:LASTINDEXOF(item)
Alias for `FINDLAST(item)`.

## Accessing Individual Elements

List indexes start at zero (0 to LENGTH-1).

**Syntax options:**
- `list[expression]` - Preferred syntax for getting/setting elements
- `FOR VAR IN LIST { ... }` - Loop iterating through all items
- `ITERATOR` - Alternative iteration method
- `list#x` - Deprecated syntax for backward compatibility

### Usage Examples

```
SET BAR TO LIST(5,3,6).
SET FOO TO LIST().
FOO:ADD(5).
FOO:ADD(ALTITUDE).
FOO:ADD(ETA:APOAPSIS).

PRINT FOO:LENGTH.
PRINT FOO[0].
PRINT FOO[1].
PRINT FOO[2].
SET x TO 2. PRINT FOO[x].
SET y to 3. PRINT FOO[y/3 + 1].
SET FOO[0] to 4.
FOO:INSERT(0,"skipper 1").
FOO:INSERT(2,"skipper 2").
FOO:REMOVE(1).
FOO:REMOVE(FOO:LENGTH - 1).
SET BAR TO FOO:COPY.
FOO:CLEAR.
FOR var in BAR {
  print var.
}.
```

## Multidimensional Arrays

2-D arrays are lists whose elements are themselves lists. Access uses `list[x][y]` syntax.

```
SET FOO TO LIST().
FOO:ADD(LIST()).
FOO[0]:ADD("A").
FOO[0]:ADD("B").
FOO:ADD(LIST()).
FOO[1]:ADD(10).
FOO[1]:ADD(20).
FOO:ADD(LIST()).
FOO[FOO:LENGTH - 1]:ADD(3.14159).
FOO[FOO:LENGTH - 1]:ADD(7).

PRINT FOO[0][0].
PRINT FOO[0][1].
PRINT FOO[1][0].
PRINT FOO[1][1].
PRINT FOO[2][0].
PRINT FOO[2][1].
```

## Comparing Two Lists

Using `=` compares whether two variables reference the *same* list object, not whether their contents are equal. To compare contents, check elements individually:

```
set still_same to true.
FROM {local i is 0.}
  UNTIL i > LISTA:LENGTH or not still_same
  STEP {set i to i + 1.}
DO
{
  set still_same to (LISTA[i] = LISTB[i]).
}
if still_same {
  print "they are equal".
}
```

**Note:** This type is serializable.
