> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/stylestate.html (mirrored offline copy for local reference)

# StyleState

## Structure Definition

**StyleState** is a sub-structure of `Style` that defines properties applied under specific dynamic conditions. For instance, it allows you to set different colors for a widget when focused versus unfocused.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| `BG` | String | Name of a "9-slice" image file |
| `TEXTCOLOR` | Color | The color of text on the label |

## StyleState:BG

**Type:** String  
**Access:** Get/Set

This string specifies an image filename stored in the archive folder (not on local drives). Image files are located relative to volume 0 (Ships/Scripts directory), and the ".png" extension is optional. These files can be accessed even when out of archive range, as they represent visual control panel elements rather than actual ship files.

The image uses a "9-slice" design that handles stretching properly to any size:

- **Four corner pieces:** Used as-is without stretching
- **Top and bottom edges:** Stretched horizontally only
- **Left and right edges:** Stretched vertically only
- **Center piece:** Stretched both horizontally and vertically

The `Style:BORDER` attribute defines the coordinates marking these nine sections.

If set to an empty string `""`, the background defaults to the normal image. If that is also empty, it defaults to the standard `BG` image. If all are empty, the background becomes completely transparent.

## StyleState:TEXTCOLOR

**Type:** Color  
**Access:** Get/Set

Specifies the foreground text color within the widget when it is in this particular state.
