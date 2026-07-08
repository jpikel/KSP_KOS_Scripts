> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/scrollbox.html (mirrored offline copy for local reference)

# ScrollBox

## Structure Definition

`ScrollBox` objects are created using the `BOX:ADDSCROLLBOX` method. A scrollbox is a container whose contents can exceed its visible area, with scrollbars for navigation.

To set the visible size, use the `:style` suffix:

```kos
set sb to mygui:addscrollbox().
set sb:style:width to 200.
set sb:style:height to 200.
```

By default, the layout manager expands the scrollbox to fill available space in the containing window.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `BOX` | — | Inherited from parent BOX structure |
| `HALWAYS` | Boolean | Always show the horizontal scrollbar |
| `VALWAYS` | Boolean | Always show the vertical scrollbar |
| `POSITION` | Vector | Position of scrolled content (Z ignored) |

## Detailed Attributes

### ScrollBox:HALWAYS

**Type:** Boolean  
**Access:** Get/Set

Set to `true` to force the horizontal scrollbar to display regardless of whether the content requires it.

### ScrollBox:VALWAYS

**Type:** Boolean  
**Access:** Get/Set

Set to `true` to force the vertical scrollbar to display regardless of whether the content requires it.

### ScrollBox:POSITION

**Type:** Vector  
**Access:** Get/Set

Returns or sets the scroll position. The X component indicates the horizontal offset, Y indicates the vertical offset, and Z is ignored. You can assign a new vector to scroll to a specific location.
