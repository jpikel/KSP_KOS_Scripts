> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/label.html (mirrored offline copy for local reference)

# Label

## Structure: LABEL

`Label` widgets are created inside Box objects via `BOX:ADDLABEL`. A `Label` is a widget that displays text or an image passively without user interaction.

Other interactive widgets derive from `Label`, such as `Button` and `TextField`.

## Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `WIDGET` | — | Inherited from parent widget |
| `TEXT` | `String` | The text displayed on the label |
| `IMAGE` | `String` | Filename of an image for the label |
| `TOOLTIP` | `String` | A tooltip for the label |

## Label:TEXT

**Type:** `String`  
**Access:** Get/Set

The text shown on the label. This text can contain limited richtext markup (described below) unless suppressed using `Style:RICHTEXT`:

```
set thislabel:RICHTEXT to false.
```

## Label:IMAGE

**Type:** `String`  
**Access:** Get/Set

The filename of an image file to use in the label's background. Filenames must be in the Archive volume (i.e., "/Ships/Script"), but are exempt from normal comms restrictions since they represent onboard control panel graphics.

PNG format images work best; JPG files also work. You may omit the ".png" extension, and the suffix will assume PNG format. For other formats, you must include the file extension explicitly.

## Label:TOOLTIP

**Type:** `String`  
**Access:** Get/Set

When the user hovers over this item, the global tooltip value for the GUI window is set to this string. This can be read via `GUIWidgets:TOOLTIP` or displayed using a `TIPDISPLAY` widget.

**Exception:** `TEXTFIELD` widgets cannot display proper tooltips due to Unity3D limitations. Instead, `TOOLTIP` becomes hint text displayed in greyed-out color when the field is empty.

## Rich Text

Labels and other text widgets support limited markup called Rich Text (from Unity):

- **`<b>string</b>`** — Bold face
- **`<i>string</i>`** — Italic face
- **`<size=nnn>string</size>`** — Font size (pixels or points)
- **`<color=name>string</color>`** — Named color (opaque)
- **`<color=#nnnnnnnn>string</color>`** — Hex color (RRGGBBAA format)

Suppress this feature by setting `Style:RICHTEXT` to false:

```
set mylabel:style:richtext to false.
```

### Examples

```
set mylabel1:text to "This is <b>important</b>".
set mylabel2:text to "This is <i>important</i>".
set mylabel3:text to "This is <size=30>important</size>".
set mylabel4:text to "This is <color=orange>important</color>".
set mylabel5:text to "This is <color=#ffaa00FF>important</color>".
set mylabel6:text to "This is <color=#ffaa0080>important</color>".
```
