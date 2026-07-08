> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/box.html (mirrored offline copy for local reference)

# Box — kOS 1.4.0.0 Documentation

## Overview

The `Box` structure is a rectangular widget container that holds other widgets. It's a type of `WIDGET` and serves as the foundation for GUI creation in kOS. GUI windows are themselves `Box` instances created via the `GUI()` function.

Boxes can be nested within other boxes to control layout and widget arrangement. This enables organizing groups of radio buttons and forcing specific layout patterns through the automatic layout system.

## Methods and Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `WIDGET` | — | Inherited from parent |
| `ADDLABEL(text)` | `Label` | Creates a text label |
| `ADDBUTTON(text)` | `Button` | Creates a clickable button |
| `ADDCHECKBOX(text, on)` | `Button` | Creates a toggleable button |
| `ADDRADIOBUTTON(text, on)` | `Button` | Creates exclusive toggleable button |
| `ADDTEXTFIELD(text)` | `TextField` | Creates editable text input |
| `ADDPOPUPMENU()` | `PopupMenu` | Creates dropdown menu |
| `ADDHSLIDER(init, min, max)` | `Slider` | Creates horizontal slider |
| `ADDVSLIDER(init, min, max)` | `Slider` | Creates vertical slider |
| `ADDHLAYOUT()` | `Box` | Transparent horizontal container |
| `ADDVLAYOUT()` | `Box` | Transparent vertical container |
| `ADDHBOX()` | `Box` | Visible horizontal container |
| `ADDVBOX()` | `Box` | Visible vertical container |
| `ADDSTACK()` | `Box` | Stacked container (one visible at time) |
| `ADDSCROLLBOX()` | `ScrollBox` | Scrollable container |
| `ADDSPACING(size)` | `Spacing` | Blank space in pixels |
| `WIDGETS` | `List(Widget)` | Get-only: list of child widgets |
| `RADIOVALUE` | `String` | Get-only: currently selected radio button label |
| `ONRADIOCHANGE` | `KOSDelegate` | Get/Set: callback when radio selection changes |
| `SHOWONLY(widget)` | — | Display only specified widget |
| `CLEAR()` | — | Remove all child widgets |

## Detailed Method Documentation

### ADDLABEL(text)
Creates a `Label` widget displaying text.

**Parameters:**
- `text` (String): Display text

**Returns:** `Label`

### ADDBUTTON(text)
Creates a clickable button widget.

**Parameters:**
- `text` (String): Button label

**Returns:** `Button`

### ADDCHECKBOX(text, on)
Creates a toggle button with initial state.

**Parameters:**
- `text` (String): Display text
- `on` (Boolean): Initial state

**Returns:** `Button`

### ADDRADIOBUTTON(text, on)
Creates an exclusive toggle button. Only one radio button per box can be active simultaneously. Multiple radio button groups require separate boxes.

**Parameters:**
- `text` (String): Display text
- `on` (Boolean): Initial state

**Returns:** `Button`

### ADDTEXTFIELD(text)
Creates a single-line editable text input field.

**Parameters:**
- `text` (String): Initial text

**Returns:** `TextField`

### ADDPOPUPMENU()
Creates a dropdown menu button. After creation, populate via `POPUPMENU:OPTIONS`.

**Example:**
```
set mygui to GUI(100).
set mypopup to mygui:addpopupmenu().
set mypopup:options to LIST("red", "green", "yellow", "white").
mygui:show().
wait 15.
mygui:dispose().
```

**Returns:** `PopupMenu`

### ADDHSLIDER(init, min, max)
Creates horizontal slider. Direction inverts if `min` > `max`.

**Parameters:**
- `init` (Scalar): Starting value
- `min` (Scalar): Left endpoint
- `max` (Scalar): Right endpoint

**Returns:** `Slider`

### ADDVSLIDER(init, min, max)
Creates vertical slider. Direction inverts if `min` > `max`.

**Parameters:**
- `init` (Scalar): Starting value
- `min` (Scalar): Top endpoint
- `max` (Scalar): Bottom endpoint

**Returns:** `Slider`

### ADDHLAYOUT()
Creates transparent horizontally-arranged container. Widgets expand rightward as more are added.

**Returns:** `Box`

### ADDVLAYOUT()
Creates transparent vertically-arranged container. The default `GUI()` function returns a VLayout box. Widgets expand downward as more are added.

**Returns:** `Box`

### ADDHBOX()
Identical to `ADDHLAYOUT()` but with visible graphical styling.

**Returns:** `Box`

### ADDVBOX()
Identical to `ADDVLAYOUT()` but with visible graphical styling.

**Returns:** `Box`

### ADDSTACK()
Creates stacked container where multiple boxes occupy the same screen space. Only one is visible at a time.

Enables tab-like interfaces where different content variants replace each other. Use `SHOWONLY()` to control visibility.

**Returns:** `Box`

### ADDSCROLLBOX()
Creates scrollable container for oversized content. Requires explicit size limits to function properly.

**Returns:** `ScrollBox`

### ADDSPACING(size)
Creates blank space. Direction (horizontal/vertical) depends on parent layout type.

**Parameters:**
- `size` (Scalar): Pixels of space (-1 for flexible)

**Example:**
```
set mygui to GUI(400).
set mytitle to mygui:addlabel("This is my Panel").
set box1 to mygui:ADDHLAYOUT().
box1:addspacing(50).
set button1 to box1:addbutton("indented").
set box2 to mygui:ADDHLAYOUT().
box2:addspacing(100).
set button2 to box2:addbutton("indented more").
myGui:show().
print "Play with buttons for 15 seconds.".
wait 15.
myGui:dispose().
```

**Returns:** `Spacing`

## Attributes

### WIDGETS
**Type:** `List(Widget)` (Get-only)

Returns list of child widgets. Modifications to this list don't affect the actual box contents.

### RADIOVALUE
**Type:** `String` (Get-only)

Returns the text label of the currently selected radio button, or empty string if none selected.

### ONRADIOCHANGE
**Type:** `KOSDelegate` (Get/Set)

Callback executed when radio button selection changes. Receives the newly-selected `Button` as parameter.

**Example:**
```
function myradiochangehook {
  parameter whichButton.
  // Do something here
}
set someBox:onradiochange to myradiochangehook@.
```

Anonymous function example:
```
set someBox:onRadioChange to { parameter B.  print "You selected: " + B:text. }.
```

## Methods

### SHOWONLY(widget)
Hides all widgets except the specified one. Useful for stacked boxes created with `ADDSTACK()`.

**Parameters:**
- `widget` (Widget): Widget to display

### CLEAR()
Removes all child widgets and calls `DISPOSE()` on each.
