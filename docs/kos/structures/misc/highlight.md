> Source: https://ksp-kos.github.io/KOS/structures/misc/highlight.html (mirrored offline copy for local reference)

# Part Highlighting

Being able to tint a part or collection of parts with a specific color provides "powerful visualization to show their placement and status."

## HIGHLIGHT(p,c)

This global function creates a part highlight using the syntax:

```
SET foo TO HIGHLIGHT(p,c).
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `p` | part, list of parts, or element | The target for highlighting |
| `c` | Color | The color to apply |

## HIGHLIGHT Structure

**Members:**

| Suffix | Type | Description |
|--------|------|-------------|
| `:COLOR` | Color | The color used by the highlight |
| `:ENABLED` | Boolean | Controls the visibility of the highlight |

## Example

```
list elements in elist.

// Color the first element pink
SET foo TO HIGHLIGHT( elist[0], HSV(350,0.25,1) ).

// Turn the highlight off
SET foo:ENABLED TO FALSE

// Turn the highlight back on
SET foo:ENABLED TO TRUE
```
</content>
