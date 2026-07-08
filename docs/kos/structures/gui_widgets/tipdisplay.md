> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/tipdisplay.html (mirrored offline copy for local reference)

# TipDisplay

## Overview

The `TipDisplay` widget is a specialized form of a `Label` widget that you can add to Box objects using `BOX:ADDTIPDISPLAY`. It provides a designated location within your GUI window to display tooltips when users hover over other widgets.

## Purpose and Usage

Rather than displaying tooltips in floating windows near the cursor (as typical GUI systems do), kOS requires you to explicitly place a `TipDisplay` widget within your GUI to show tooltip text. It's recommended to have only one `TipDisplay` per window, typically positioned as a separate line at the top or bottom.

## Characteristics

A `TipDisplay` widget functions as a `Label` in all respects, supporting all the same suffixes. Its special behaviors include:

- **Custom styling**: Uses a style called "tipDisplay" for independent style configuration
- **Automatic text population**: The `TEXT` value automatically displays tooltips from hovered widgets, or shows an empty string if no tooltip is available

## Limitations

Unity3D's IMGUI system has tooltip support constraints:

- Tooltips work reliably on widgets derived from `Label`, such as buttons and labels
- Other widget types generally do not support tooltips
- `TEXTFIELD` has specific tooltip limitations documented on its own page

## Available Suffixes

All suffixes available to the `Label` structure are supported by `TipDisplay`.

## Example

```
local done is false.
local g is gui(200).
local tiptext is g:addtipdisplay().

local buttonsBox is g:addhbox().

local b1 is buttonsBox:addbutton("low").
set b1:tooltip to "Makes low pitch note.".
set b1:onclick to {getvoice(0):play(note(200,0.5)).}.

local b2 is buttonsBox:addbutton("medium").
set b2:tooltip to "Makes medium pitch note.".
set b2:onclick to {getvoice(0):play(note(300,0.5)).}.

local b3 is buttonsBox:addbutton("high").
set b3:tooltip to "Makes high pitch note.".
set b3:onclick to {getvoice(0):play(note(400,0.5)).}.

local bClose is g:addbutton("Close").
set bClose:tooltip to "Ends program.".
set bClose:onclick to {set done to true.}.

g:show().
wait until done.
g:dispose().
```
