> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/style.html (mirrored offline copy for local reference)

# Style Documentation - kOS 1.4.0.0

## Overview

The Style structure represents widget styling in kOS GUIs. Styles can be applied directly to individual widgets or to the GUI:SKIN to affect all subsequently created widgets of a particular type.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| HSTRETCH | Boolean | Should the widget stretch horizontally? (default depends on widget subclass) |
| VSTRETCH | Boolean | Should the widget stretch vertically? |
| WIDTH | Scalar (pixels) | Fixed width (or 0 if flexible) |
| HEIGHT | Scalar (pixels) | Fixed height (or 0 if flexible) |
| MARGIN | StyleRectOffset | Spacing between this and other widgets |
| PADDING | StyleRectOffset | Spacing between widget exterior and contents |
| BORDER | StyleRectOffset | Size of edges in 9-slice image for backgrounds |
| OVERFLOW | StyleRectOffset | Extra space around background image |
| ALIGN | String | One of "CENTER", "LEFT", or "RIGHT" |
| FONT | String | Font name or "" for default |
| FONTSIZE | Scalar | Text size |
| RICHTEXT | Boolean | Enable/disable rich-text formatting |
| NORMAL | StyleState | Properties in normal state |
| ON | StyleState | Properties when under mouse and "on" |
| NORMAL_ON | StyleState | Alias for ON |
| HOVER | StyleState | Properties when under mouse |
| HOVER_ON | StyleState | Properties when under mouse and "on" |
| ACTIVE | StyleState | Properties when active (e.g., button held) |
| ACTIVE_ON | StyleState | Properties when active and "on" |
| FOCUSED | StyleState | Properties with keyboard focus |
| FOCUSED_ON | StyleState | Properties with keyboard focus and "on" |
| BG | String | Same as NORMAL:BG; 9-slice image file name |
| TEXTCOLOR | Color | Same as NORMAL:TEXTCOLOR |
| WORDWRAP | Boolean | Allow labels on multiple lines at word boundaries |

## Important Notes

The ALIGN attribute requires either HSTRETCH set to true or a fixed WIDTH to function meaningfully. It currently applies only to widgets with scalar content (Label and subclasses).

For fonts, kOS recommends using universally available options: Arial, CALIBRI, HEADINGFONT, calibri, calibrib, calibriz, calibril, and dotty.
