> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/skin.html (mirrored offline copy for local reference)

# Skin — kOS 1.4.0.0 Documentation

## Overview

A `Skin` is a collection of `Style` settings that define default appearances for various widget types within a GUI. When you modify styles on a `GUI:SKIN`, those changes apply to subsequently created widgets in that window. Some styles control widget subparts, such as `HORIZONTALSLIDERTHUMB` used by horizontal sliders.

The documentation notes: "If you create your own composite widgets, you can use ADD and GET to centralize setting up the style of your composite widgets."

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| `BOX` | `Style` | Style for `Box` widgets |
| `BUTTON` | `Style` | Style for `Button` widgets |
| `HORIZONTALSCROLLBAR` | `Style` | Horizontal scrollbar style |
| `HORIZONTALSCROLLBARLEFTBUTTON` | `Style` | Left button of horizontal scrollbar |
| `HORIZONTALSCROLLBARRIGHTBUTTON` | `Style` | Right button of horizontal scrollbar |
| `HORIZONTALSCROLLBARTHUMB` | `Style` | Thumb of horizontal scrollbar |
| `HORIZONTALSLIDER` | `Style` | Horizontal slider style |
| `HORIZONTALSLIDERTHUMB` | `Style` | Thumb of horizontal slider |
| `VERTICALSCROLLBAR` | `Style` | Vertical scrollbar style |
| `VERTICALSCROLLBARLEFTBUTTON` | `Style` | Left button of vertical scrollbar |
| `VERTICALSCROLLBARRIGHTBUTTON` | `Style` | Right button of vertical scrollbar |
| `VERTICALSCROLLBARTHUMB` | `Style` | Thumb of vertical scrollbar |
| `VERTICALSLIDER` | `Style` | Vertical slider style |
| `VERTICALSLIDERTHUMB` | `Style` | Thumb of vertical slider |
| `LABEL` | `Style` | Style for `Label` widgets |
| `SCROLLVIEW` | `Style` | Style for `ScrollBox` widgets |
| `TEXTFIELD` | `Style` | Style for `TextField` widgets |
| `TOGGLE` | `Style` | Style for toggle buttons (checkboxes, radio buttons) |
| `FLATLAYOUT` | `Style` | Style for transparent `Box` widgets |
| `POPUPMENU` | `Style` | Style for `PopupMenu` widgets |
| `POPUPWINDOW` | `Style` | Style for popup windows |
| `POPUPMENUITEM` | `Style` | Style for menu items |
| `LABELTIPOVERLAY` | `Style` | Style for tooltip overlays |
| `WINDOW` | `Style` | Style for GUI windows |
| `FONT` | `string` | Font name (defaults apply if `STYLE:FONT` unchanged) |
| `SELECTIONCOLOR` | Color | Background color of selected text |

## Methods

### `ADD(name, style)`

**Parameters:**
- `name` – String
- `style` – Style (to clone)

**Returns:** `Style`

Adds a new named style to the skin. This creates a copy of the provided style, so subsequent modifications don't affect the original.

### `HAS(name)`

**Parameters:**
- `name` – String

**Returns:** Boolean

Checks whether the skin contains a style with the given name.

### `GET(name)`

**Parameters:**
- `name` – String

**Returns:** `Style`

Retrieves a style by name, including custom styles added with `ADD`.
