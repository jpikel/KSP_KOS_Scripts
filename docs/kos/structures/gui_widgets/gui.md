> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/gui.html (mirrored offline copy for local reference)

# GUI Structure Documentation

## Overview

The `GUI` structure represents the outermost window container in kOS's graphical interface system. According to the documentation, "a GUI object is a kind of Box that is the outermost window that holds all the other widgets."

## Key Characteristics

All widgets must exist within a GUI object or within nested Box structures that ultimately connect to a GUI. To remove all created GUIs, use the `CLEARGUIS` function, which handles hiding and disposing of each GUI.

## Attributes and Methods

| Suffix | Type | Description |
|--------|------|-------------|
| `X` | Scalar (pixels) | X-position of window upper-left corner; negative values measure from right edge |
| `Y` | Scalar (pixels) | Y-position of window upper-left corner; negative values measure from bottom edge |
| `DRAGGABLE` | Boolean | Enables user ability to move the window via dragging |
| `EXTRADELAY` | Scalar (seconds) | Simulated signal delay for testing purposes |
| `SKIN` | Skin | Defines default styling for widgets within the GUI |
| `TOOLTIP` | String | Current hovertext value from Label widgets |
| `SHOW()` | Method | Makes the GUI visible |
| `HIDE()` | Method | Makes the GUI disappear |

### GUI:X

Adjustable position attribute for horizontal placement. Supports negative coordinates for right-edge measurement.

### GUI:Y

Adjustable position attribute for vertical placement. Supports negative coordinates for bottom-edge measurement.

### GUI:DRAGGABLE

Toggles user-dragging capability while preserving script-based positioning control.

### GUI:EXTRADELAY

Allows testing GUI behavior under signal delays without Remote Tech installation.

### GUI:SKIN

Assigns style collections to the GUI, affecting all appropriate widget types within.

### GUI:TOOLTIP

Displays tooltip text from hovered Label widgets or enables custom tooltip implementations.

### GUI:SHOW()

Essential method to render the GUI visible on screen.

### GUI:HIDE()

Conceals the GUI from display.
