> Source: https://ksp-kos.github.io/KOS/math/vector.html (mirrored offline copy for local reference)

# Vectors — kOS 1.4.0.0 Documentation

## Vectors

### Creation

#### V(x,y,z)

**Parameters:**
- **x** – (scalar) x coordinate
- **y** – (scalar) y coordinate
- **z** – (scalar) z coordinate

**Returns:** Vector

This creates a new vector from 3 components in (x,y,z):

```
SET vec TO V(x,y,z).
```

A new Vector called `vec` is created. The Vector object represents a three-dimensional euclidean vector. To understand most vectors in kOS, you need to understand the underlying coordinate system of KSP. If you are having trouble making sense of the direction the axes point in, consult the reference frame documentation.

> Note: Remember that the XYZ grid in Kerbal Space Program uses a left-handed coordinate system.

---

### Structure

#### Vector

**Members:**

| Suffix | Type | Get | Set |
|--------|------|-----|-----|
| X | Scalar | yes | yes |
| Y | Scalar | yes | yes |
| Z | Scalar | yes | yes |
| MAG | Scalar | yes | yes |
| NORMALIZED | Vector | yes | no |
| SQRMAGNITUDE | Scalar | yes | no |
| DIRECTION | Direction | yes | yes |
| VEC | Vector | yes | no |

> Note: This type is serializable.

#### Vector:X

**Type:** Scalar  
**Access:** Get/Set

The x component of the vector.

#### Vector:Y

**Type:** Scalar  
**Access:** Get/Set

The y component of the vector.

#### Vector:Z

**Type:** Scalar  
**Access:** Get/Set

The z component of the vector.

#### Vector:MAG

**Type:** Scalar  
**Access:** Get/Set

The magnitude of the vector, as a scalar number, by the Pythagorean Theorem.

#### Vector:NORMALIZED

**Type:** Vector  
**Access:** Get only

This creates a unit vector pointing in the same direction as this vector. This is the same effect as multiplying the vector by the scalar `1 / vec:MAG`.

#### Vector:SQRMAGNITUDE

**Type:** Scalar  
**Access:** Get only

The magnitude of the vector, squared. Use instead of `vec:MAG^2` if you need the square of the magnitude as this skips the step in the Pythagorean formula where you take the square root in the first place. Taking the square root and then squaring that would introduce floating point error needlessly.

#### Vector:DIRECTION

**Type:** Direction  
**Access:** Get/Set

**GET:**  
The vector rendered into a Direction (note that information loss occurs when doing this).

**SET:**  
Tells the vector to keep its magnitude but point in a new direction, adjusting its (x,y,z) numbers accordingly.

#### Vector:VEC

**Type:** Vector  
**Access:** Get only

This is a suffix that creates a copy of this vector. Useful if you want to copy a vector and then change the copy. Normally if you `SET v2 TO v1`, then `v1` and `v2` are two names for the same vector and changing one would change the other.

---

### Operations and Methods

| Method / Operator | Return Type |
|------------------|-------------|
| * (asterisk) | Scalar or Vector |
| + (plus) | Vector |
| - (minus) | Vector |
| - (unary) | Vector |
| VDOT, VECTORDOTPRODUCT, * (asterisk) | Scalar |
| VCRS, VECTORCROSSPRODUCT | Vector |
| VANG, VECTORANGLE | Scalar (deg) |
| VXCL, VECTOREXCLUDE | Vector |

#### * (Asterisk)

Scalar multiplication or dot product of two Vectors:

```
SET a TO 2.
SET vec1 TO V(1,2,3).
SET vec2 TO V(2,3,4).
PRINT a * vec1.     // prints: V(2,4,6)
PRINT vec1 * vec2.  // prints: 20
```

Note that the unary minus operator is really a multiplication of the vector by a scalar of (-1):

```
PRINT -vec1.     // these two both print the
PRINT (-1)*vec1. // exact same thing.
```

#### +, -

Adding and subtracting a Vector with another Vector:

```
SET a TO 2.
SET vec1 TO V(1,2,3).
SET vec2 TO V(2,3,4).
PRINT vec1 + vec2.  // prints: V(3,5,7)
PRINT vec2 - vec1.  // prints: V(1,1,1)
```

Note that the unary minus operator is the same thing as multiplying the vector by a scalar of (-1), and is not technically an addition or subtraction operator:

```
// These two both print the same exact thing:
PRINT -vec1.
PRINT (-1)*vec1.
```

#### VDOT(v1,v2)

Same as VECTORDOTPRODUCT(v1,v2) and v1 * v2.

#### VECTORDOTPRODUCT(v1,v2)

**Parameters:**
- **v1** – (Vector)
- **v2** – (Vector)

**Returns:** The vector dot-product  
**Return type:** Scalar

This is the dot product of two vectors returning a scalar number. This is the same as v1 * v2:

```
SET vec1 TO V(1,2,3).
SET vec2 TO V(2,3,4).

// These are different ways to perform the same operation.
// All of them will print the value: 20
// -------------------------------------------------------
PRINT VDOT(vec1, vec2).
PRINT VECTORDOTPRODUCT(vec1, vec2).
PRINT vec1 * vec2. // multiplication of two vectors with asterisk "*" performs a VDOT().
```

#### VCRS(v1,v2)

Same as VECTORCROSSPRODUCT(v1,v2)

#### VECTORCROSSPRODUCT(v1,v2)

**Parameters:**
- **v1** – (Vector)
- **v2** – (Vector)

**Returns:** The vector cross-product  
**Return type:** Vector

The vector cross product of two vectors in the order (v1,v2) returning a new Vector:

```
SET vec1 TO V(1,2,3).
SET vec2 TO V(2,3,4).

// These will both print: V(-1,2,-1)
PRINT VCRS(vec1, vec2).
PRINT VECTORCROSSPRODUCT(vec1, vec2).
```

When visualizing the direction that a vector cross product will point, remember that KSP uses a left-handed coordinate system, and this means a cross-product of two vectors will point in the opposite direction of what it would had KSP been using a right-handed coordinate system.

#### VANG(v1,v2)

Same as VECTORANGLE(v1,v2).

#### VECTORANGLE(v1,v2)

**Parameters:**
- **v1** – (Vector)
- **v2** – (Vector)

**Returns:** Angle between two vectors  
**Return type:** Scalar

This returns the angle between v1 and v2. It is the same result as:

```
arccos( (VDOT(v1,v2) / (v1:MAG * v2:MAG) ) )
```

#### VXCL(v1,v2)

Same as VECTOREXCLUDE(v1,v2)

#### VECTOREXCLUDE(v1,v2)

This is a vector, `v2` with all of `v1` excluded from it. In other words, the projection of `v2` onto the plane that is normal to `v1`.

---

### Examples

Some examples of using the Vector object:

```
// initializes a vector with x=100, y=5, z=0
SET varname TO V(100,5,0).

varname:X.    // Returns 100.
V(100,5,0):Y. // Returns 5.
V(100,5,0):Z. // Returns 0.

// Returns the magnitude of the vector
varname:MAG.

// Changes x coordinate value to 111.
SET varname:X TO 111.

// Lengthen or shorten vector to make its magnitude 10.
SET varname:MAG to 10.

// get vector pointing opposite to surface velocity.
SET retroSurf to (-1)*velocity:surface.

// use cross product to find normal to the orbit plane.
SET norm to VCRS(velocity:orbit, ship:body:position).
```
