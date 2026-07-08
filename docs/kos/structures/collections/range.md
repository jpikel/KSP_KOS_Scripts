> Source: https://ksp-kos.github.io/KOS/structures/collections/range.html (mirrored offline copy for local reference)

# Range — kOS 1.4.0.0 Documentation

## Range

The `Range` structure represents a sequence of scalar whole numbers. The sequence can start and finish at any whole number, can be either descending or ascending, and can skip numbers.

> "This is one of the few places in kOS where there is a distinction between decimal (floating point, or fractional) scalar numbers and whole (integer, or round) scalar numbers."

### Construction Methods

There are 3 ways to construct a Range:

**`RANGE(START, STOP, STEP)`**

Creates a sequence starting with START, stopping just before STOP (not including it), counting by increments of STEP. The bounds are [START, STOP).

- `RANGE(3,8,1)` contains: 3, 4, 5, 6, 7
- `RANGE(3,8,2)` contains: 3, 5, 7
- `RANGE(2,-9,3)` contains: 2, -1, -4, -7 (counts backward automatically when START > STOP)

**`RANGE(START, STOP)`**

Same as above with STEP assumed to be 1.

**`RANGE(STOP)`**

Same as above with STEP = 1 and START = 0.

### Code Examples

```
FOR I IN RANGE(5) {
  PRINT I.
}
// will print numbers 0,1,2,3,4

FOR I IN RANGE(2, 5) {
  PRINT I*I.
}
// will print 4, 9 and 16
```

## Structure

### Range

Range objects are a type of Enumerable.

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of Enumerable | — | Range objects inherit Enumerable methods |
| START | Scalar | Initial element of the range |
| STOP | Scalar | Range limit |
| STEP | Scalar | Step size |

**Note:** This type is serializable.

### Range:START

- **Type:** Scalar
- **Access:** Get only
- Returns the initial element of the range. Must be a round number.

### Range:STOP

- **Type:** Scalar
- **Access:** Get only
- Returns the range limit. Must be a round number.

### Range:STEP

- **Type:** Scalar
- **Access:** Get only
- Returns the step size. Must be a round number.
