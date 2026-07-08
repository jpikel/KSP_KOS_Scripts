> Source: https://ksp-kos.github.io/KOS/structures/collections/enumerable.html (mirrored offline copy for local reference)

# Enumerable

`Enumerable` is a parent structure that contains a set of suffixes common to few structures in kOS. As a user of kOS you will never handle pure instances of this structure, but rather concrete types like `List`, `Range`, `Queue` etc.

## Structure

**structure** `Enumerable`

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| `ITERATOR` | `Iterator` | for iterating over the elements |
| `REVERSEITERATOR` | `Iterator` | for iterating over the elements in the reverse order |
| `LENGTH` | `Scalar` | number of elements in the enumerable |
| `CONTAINS(item)` | `Boolean` | check if enumerable contains an item |
| `EMPTY` | `Boolean` | check if enumerable is empty |
| `DUMP` | `String` | verbose dump of all contained elements |

## Enumerable:ITERATOR

**Type:** `Iterator`

**Access:** Get only

An alternate means of iterating over an enumerable. See: `Iterator`.

## Enumerable:REVERSEITERATOR

**Type:** `Iterator`

**Access:** Get only

An alternate means of iterating over an enumerable. Order of items is reversed. See: `Iterator`.

## Enumerable:LENGTH

**Type:** `Scalar`

**Access:** Get only

Returns the number of elements in the enumerable.

## Enumerable:CONTAINS(item)

**Parameters:**
- **item** – element whose presence in the enumerable should be checked

**Returns:** `Boolean`

Returns true if the enumerable contains an item equal to the one passed as an argument.

## Enumerable:EMPTY

**Type:** `Boolean`

**Access:** Get only

Returns true if the enumerable has zero items in it.

## Enumerable:DUMP

**Type:** `String`

**Access:** Get only

Returns a string containing a verbose dump of the enumerable's contents.
