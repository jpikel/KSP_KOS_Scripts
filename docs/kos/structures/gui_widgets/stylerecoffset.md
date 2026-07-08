> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/stylerecoffset.html (mirrored offline copy for local reference)

# StyleRectOffset

## Structure Definition

`StyleRectOffset` is a sub-structure of `Style` used to define pixel measurements around widget edges. This applies to margins, padding, and stretchable image segments.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| `LEFT` | Scalar | Pixel count on the left side |
| `RIGHT` | Scalar | Pixel count on the right side |
| `TOP` | Scalar | Pixel count on the top side |
| `BOTTOM` | Scalar | Pixel count on the bottom side |
| `H` | Scalar | Sets left and right pixels uniformly; reading returns LEFT value |
| `V` | Scalar | Sets top and bottom pixels uniformly; reading returns TOP value |

## Individual Attribute Details

### StyleRectOffset:LEFT
- **Type:** Scalar
- **Access:** Get/Set
- Specifies pixel measurement on the left edge

### StyleRectOffset:RIGHT
- **Type:** Scalar
- **Access:** Get/Set
- Specifies pixel measurement on the right edge

### StyleRectOffset:TOP
- **Type:** Scalar
- **Access:** Get/Set
- Specifies pixel measurement on the top edge

### StyleRectOffset:BOTTOM
- **Type:** Scalar
- **Access:** Get/Set
- Specifies pixel measurement on the bottom edge

### StyleRectOffset:H
- **Type:** Scalar
- **Access:** Get/Set
- Assigns identical pixel values to both horizontal sides; retrieves only the LEFT value when read

### StyleRectOffset:V
- **Type:** Scalar
- **Access:** Get/Set
- Assigns identical pixel values to both vertical sides; retrieves only the TOP value when read
