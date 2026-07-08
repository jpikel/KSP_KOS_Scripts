> Source: https://ksp-kos.github.io/KOS/structures/gui.html (mirrored offline copy for local reference)

# Creating GUIs — kOS 1.4.0.0 Documentation

## Overview

Users can create GUI objects displayed on-screen (separate from the terminal window) featuring buttons, labels, and standard GUI elements. Combined with boot files, entirely GUI-driven vessel controls become possible.

## GUI Callbacks versus Polling

Two interaction styles exist:

**Callback Technique**: Assign [`KOSDelegate`](misc/kosdelegate.html#structure:KOSDELEGATE) functions to widget "hook suffixes." The widget calls your function when events occur.

```
set thisButton:ONCLICK to myclickFunction@.
// Program continues executing
```

GUI callbacks triggered by user activity run at higher priority than normal code, preventing simultaneous callback execution by default.

**Polling Technique**: Actively check widgets repeatedly within your script to detect changes.

```
until thisButton:TAKEPRESS {
  wait 0.
}
```

**Recommendation**: "Prefer using the callback technique most of the time. It consumes less CPU resources and reduces simulation burden."

### Callback Example ("Hello World")

```
// Create GUI window
LOCAL my_gui IS GUI(200).
// Add widgets
LOCAL label IS my_gui:ADDLABEL("Hello world!").
SET label:STYLE:ALIGN TO "CENTER".
SET label:STYLE:HSTRETCH TO True.
LOCAL ok TO my_gui:ADDBUTTON("OK").
my_gui:SHOW().

// Handle interactions via callbacks
LOCAL isDone IS FALSE.
function myClickChecker {
  SET isDone TO TRUE.
}
SET ok:ONCLICK TO myClickChecker@.
wait until isDone.

print "OK pressed. Now closing demo.".
my_gui:HIDE().
```

### Polling Example ("Hello World")

```
// Create GUI window
LOCAL my_gui IS GUI(200).
// Add widgets
LOCAL label IS my_gui:ADDLABEL("Hello world!").
SET label:STYLE:ALIGN TO "CENTER".
SET label:STYLE:HSTRETCH TO True.
LOCAL ok TO my_gui:ADDBUTTON("OK").
my_gui:SHOW().

// Handle interactions via polling
LOCAL isDone IS FALSE.
UNTIL isDone {
  if (ok:TAKEPRESS)
    SET isDone TO TRUE.
  WAIT 0.1.
}
print "OK pressed. Now closing demo.".
my_gui:HIDE().
```

## Creating a Window

### GUI(width [, height])

Creates a new [`GUI`](gui_widgets/gui.html#structure:GUI) object. If height is omitted, it resizes automatically. Setting width to 0 forces automatic width resizing:

```
SET my_gui TO GUI(200).
SET button TO my_gui:ADDBUTTON("OK").
my_gui:SHOW().
UNTIL button:TAKEPRESS WAIT(0.1).
my_gui:HIDE().
```

**Warning**: Setting both width and height to 0 may produce undesirable layouts. Specify at least one dimension for better control.

## Removing All Windows

### CLEARGUIS()

Clears all GUI windows created by the current CPU, calling [`GUI:HIDE`](gui_widgets/gui.html#method:GUI:HIDE) and `GUI:DISPOSE` on each. Other CPUs' GUIs remain unaffected.

**Note**: Primarily designed for cleaning up after crashed programs that left unresponsive GUI windows.

## Communication Delay

With communication delay enabled (e.g., RemoteTech), GUI interaction experiences the same signal delays as vessel control. Immediate control occurs if a kerbal is aboard; otherwise, delays apply to both control and GUI changes.

Test GUI behavior under simulated delay using the [`GUI:EXTRADELAY`](gui_widgets/gui.html#attribute:GUI:EXTRADELAY) suffix.

## Structure Reference

Widget hierarchy:

- **WIDGET** (base type)
  - **BOX** (rectangular container)
    - **GUI** (outermost window panel)
    - **SCROLLBOX** (scrollable subset view)
  - **LABEL** (text/image display)
    - **BUTTON** (clickable/toggle label)
      - **POPUPMENU** (button showing selection list)
    - **TEXTFIELD** (user-editable label)
    - **TIPDISPLAY** (tooltip display area)
  - **SLIDER** (movable value editor)
  - **SPACING** (whitespace for layout)
