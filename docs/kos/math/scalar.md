> Source: https://ksp-kos.github.io/KOS/math/scalar.html (mirrored offline copy for local reference)

# Scalar — kOS 1.4.0.0 Documentation

## Scalar

**Structure:** Scalar

### Members

Scalar values have no suffixes beyond those inherited from the `Structure` type.

A Scalar represents a numeric value without directional orientation in 3D space—essentially a plain number. The system abstracts away distinctions between integer, floating-point, and fixed-point types to remain accessible to newcomers.

## Scalar Syntax

Numbers can be represented multiple ways in source code and string inputs to `String:TOSCALAR`:

**Underscores as visual spacers** (not leading):
```
1234567
1_234_567
1_2__3456_7
```

**Decimal notation** (must lead with digit):
```
1234
12.34
.1234
0.1234
0.123_4
```

**Scientific notation** (shifts decimal place):
```
123.4e4      // = 1234000
1.234e+4     // = 12340
1.234e-14    // = 0.00000000000001234
123_456.78e-4 // = 12.345678
```

## Operators

| Operation | Description |
|-----------|-------------|
| `a ^ b` | Exponentiation |
| `-a` | Negation |
| `a * b`, `a / b` | Multiplication, division |
| `a + b`, `a - b` | Addition, subtraction |

Operations follow standard order of precedence.

## Scientific Notation

Example usage:
```
set x to 1.23e5.
print x.  // prints 123000

set x to 1.23e-5.
print x.  // prints 0.0000123
```

## Limitations of Scalars

### Real Numbers Only

kOS lacks support for imaginary or complex numbers. Operations like `sqrt(-4)` produce NaN ("Not a Number") errors rather than imaginary results. Similarly, `arcsin(1.01)` fails since no angle produces a sine of 1.01.

### Rational Numbers Only

Constants like `constant:pi` return rational approximations accurate to roughly 15 decimal places, not true irrational values.

### Precision Decreases with Magnitude

While `99.001` stores exactly, `999999999999999.001` becomes rounded. The constraint is significant digits (approximately 15 decimal places), not decimal positions.
