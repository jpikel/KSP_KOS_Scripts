> Source: https://ksp-kos.github.io/KOS/structures/misc/boolean.html (mirrored offline copy for local reference)

# Boolean

## Structure Boolean

Members: (Boolean values have no suffixes, other than the `Structure` suffixes all values have.)

A Boolean value represents the smallest unit of data in a computer program, containing exactly one of two values: `True` or `False`.

### Setting Boolean Values

You can assign Boolean values using the keywords `true` or `false`:

```
set myVariable to true.
set myVariable to false.
```

You can also set a Boolean equal to any true/false expression:

```
set x to 781.
set itHas3Digits to (x >= 100 and x <= 999).
print itHas3Digits.
True.
```

When printed to the terminal, a Boolean value displays as `"True"` or `"False"`.

## Operators

Boolean expressions support these operators:

- `not a` returns true if a is false, or false if a is true.
- `a and b` returns true if and only if both a and b are true, else returns false.
- `a or b` returns true if either a is true, b is true, or both are true. Only returns false when both a and b are false.

The order of operations is: `not`, then `and`, then `or`. Parentheses override this precedence.

## Example

Boolean variables can be used wherever conditional checks are needed:

```
set should_stage to false.

// set should_stage to true if the ship has no active engines right now:
//
set should_stage to (ship:maxthrust = 0).

// set should_stage to true if any of the active engines are flamed out,
// which should cover most "asparagus staging" strategies:
//
list engines in englist.
for eng in englist {

  // note, eng:flameout is a Boolean value here, being used as the
  // conditional check of this if-statement:
  //
  if eng:flameout {
    set should_stage to true.
  }
}

// Note 'should_stage' is a Boolean value here, being used as the
// conditional check of this if-statement:
//
if should_stage {
  stage.
}
```
</content>
