> Source: https://ksp-kos.github.io/KOS/structures/collections/uniqueset.html (mirrored offline copy for local reference)

# UniqueSet

A `UniqueSet` is a collection type in kOS that stores items without duplicates and doesn't maintain order. For background on this data structure, refer to [Wikipedia's article on sets](https://en.wikipedia.org/wiki/Set_(abstract_data_type)).

## Usage Example

```
SET S TO UNIQUESET(1,2,3).
PRINT S:LENGTH. // will print 3
S:ADD(1). // 1 was already in the set so nothing happens
PRINT S:LENGTH. // will print 3 again
```

## Structure

**UniqueSet** objects inherit all suffixes from `Enumerable`.

| Suffix | Type | Description |
|--------|------|-------------|
| `ADD(item)` | None | append an item |
| `REMOVE(item)` | None | remove item |
| `CLEAR()` | None | remove all elements |
| `COPY` | UniqueSet | a new copy of this set |

**Note:** This type is serializable.

## Methods and Attributes

### UniqueSet:ADD(item)

**Parameters:**
- `item` (any type) – item to be added

Appends the new value provided to the set.

### UniqueSet:REMOVE(item)

**Parameters:**
- `item` (any type) – item to be removed

Removes the specified item from the set.

### UniqueSet:CLEAR()

**Returns:** none

Removes all items currently stored in the set.

### UniqueSet:COPY

**Type:** UniqueSet  
**Access:** Get only

Returns a new set containing identical contents to the original set.
