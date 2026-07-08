> Source: https://ksp-kos.github.io/KOS/structures/misc/colors.html (mirrored offline copy for local reference)

# Colors

## Overview

Colors in kOS can be specified for use with VECDRAW, HIGHLIGHT, and HUDTEXT functions. The system supports multiple methods for color definition.

## Named Colors

Pre-defined color constants are available:

- RED
- GREEN
- BLUE
- YELLOW
- CYAN
- MAGENTA
- PURPLE (alias for MAGENTA)
- WHITE
- BLACK

## RGB Function

```
SET myColor TO RGB(r,g,b).
```

Creates a color from red, green, and blue components:

| Parameter | Description |
|-----------|-------------|
| `r` | Floating point 0.0 to 1.0 for red component |
| `g` | Floating point 0.0 to 1.0 for green component |
| `b` | Floating point 0.0 to 1.0 for blue component |

## RGBA Function

```
SET myColor TO RGBA(r,g,b,a).
```

Same as RGB but includes an alpha (transparency) channel:

| Parameter | Description |
|-----------|-------------|
| `r, g, b` | Same as RGB function |
| `a` | Floating point 0.0 to 1.0 for alpha (1.0 = opaque, 0.0 = transparent) |

## RGBA Structure

| Suffix | Type | Description |
|--------|------|-------------|
| :R or :RED | Scalar | Red component |
| :G or :GREEN | Scalar | Green component |
| :B or :BLUE | Scalar | Blue component |
| :A or :ALPHA | Scalar | Alpha component (1 = opaque, 0 = transparent) |
| :HTML or :HEX | String | HTML color format (e.g., "#ff0000"), ignores alpha |

## RGB Examples

```
SET myarrow TO VECDRAW.
SET myarrow:VEC to V(10,10,10).
SET myarrow:COLOR to YELLOW.
SET mycolor TO YELLOW.
SET myarrow:COLOR to mycolor.
SET myarrow:COLOR to RGB(1.0,1.0,0.0).

// COLOUR spelling works too
SET myarrow:COLOUR to RGB(1.0,1.0,0.0).

// half transparent yellow.
SET myarrow:COLOR to RGBA(1.0,1.0,0.0,0.5).

PRINT GREEN:HTML. // prints #00ff00
```

## HSV Function

```
SET myColor TO HSV(h,s,v).
```

Creates a color from hue, saturation, and value:

| Parameter | Description |
|-----------|-------------|
| `h` | Floating point 0.0 to 1.0 for hue component |
| `s` | Floating point 0.0 to 1.0 for saturation component |
| `v` | Floating point 0.0 to 1.0 for value component |

## HSVA Function

```
SET myColor TO HSVA(h,s,v,a).
```

Same as HSV but includes an alpha channel:

| Parameter | Description |
|-----------|-------------|
| `h, s, v` | Same as HSV function |
| `a` | Floating point 0.0 to 1.0 for alpha (1.0 = opaque, 0.0 = transparent) |

## HSVA Structure

Contains all RGBA suffixes plus:

| Suffix | Type | Description |
|--------|------|-------------|
| :H or :HUE | Scalar | Hue component (0.0 to 360.0) |
| :S or :SATURATION | Scalar | Saturation component (0.0 to 1.0) |
| :V or :VALUE | Scalar | Value component (0.0 to 1.0) |

## HSV Examples

```
SET myarrow TO VECDRAW.
SET myarrow:VEC to V(10,10,10).
SET myarrow:COLOR to HSV(60,1,1). // Yellow
SET myarrow:COLOR:S to 0.5. // Light yellow
SET myarrow:COLOR:H to 0. // pink
```
</content>
