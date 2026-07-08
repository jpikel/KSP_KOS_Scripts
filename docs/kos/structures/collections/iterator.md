> Source: https://ksp-kos.github.io/KOS/structures/collections/iterator.html (mirrored offline copy for local reference)

# Iterator — kOS 1.4.0.0 Documentation

## Iterator

An iterator is a programming construct that enables sequential access to elements within a collection. According to the documentation, "An ITERATOR is a generic computer programming concept" that allows retrieval of values at specific positions and advancement through collection items.

### Overview

Iterators work with Lists and most collection types in kOS. When initially created via a collection's ITERATOR suffix, the index position starts at -1 (before the first element). The VALUE attribute is unusable until NEXT is called for the first time.

### Example Usage

```
SET MyList TO LIST( "Hello", "Aloha", "Bonjour").
SET MyCurrent TO MyList:ITERATOR.
PRINT "before the first NEXT, position = " + MyCurrent:INDEX.
UNTIL NOT MyCurrent:NEXT {
    PRINT "Item at position " + MyCurrent:INDEX + " is [" + MyCurrent:VALUE + "].".
}
```

**Output:**
```
before the first NEXT, position = -1.
Item at position 0 is [Hello].
Item at position 1 is [Aloha].
Item at position 2 is [Bonjour].
```

To restart iteration, obtain a new iterator by calling the collection's ITERATOR suffix again.

## Members

| Suffix | Type | Description |
|--------|------|-------------|
| NEXT | Boolean | Move iterator to the next item |
| ATEND | Boolean | Check if iterator is at the end of the list |
| INDEX | Scalar | Current index starting from zero |
| VALUE | varies | The object currently being pointed to |

### NEXT()

**Returns:** Boolean

Advances the iterator to the next item. Returns true if an item exists; false if already at the list's end.

### ATEND

**Access:** Get only  
**Type:** Boolean

Indicates whether the iterator has reached the list's end and cannot advance further.

### INDEX

**Access:** Get only  
**Type:** Scalar (integer)

The numerical position within the list, starting at 0 for the first item. Initially -1 before the first NEXT call.

### VALUE

**Access:** Get only  
**Type:** varies

Returns the element at the current iterator position.
