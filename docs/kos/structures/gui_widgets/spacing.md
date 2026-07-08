> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/spacing.html (mirrored offline copy for local reference)

# Spacing

## Structure Definition

The `Spacing` structure represents an invisible widget used for layout control in kOS GUIs. As noted in the documentation, these widgets are "created via `BOX:ADDSPACING`" and serve to "push other widgets further to the right or further down."

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `WIDGET` | — | Inherited from parent widget structure |
| `AMOUNT` | `Scalar` | The amount of space, or -1 for flexible spacing |

## AMOUNT Attribute

**Type:** `Scalar`

**Access:** Get/Set

This attribute specifies the number of pixels the spacing occupies. The orientation (horizontal or vertical) depends on whether the spacing is added to a horizontal-layout box or a vertical-layout box.
