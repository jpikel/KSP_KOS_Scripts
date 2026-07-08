> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/widget.html (mirrored offline copy for local reference)

# Widget Documentation - kOS 1.4.0.0

## Widget Structure

The Widget is the base class for all GUI elements in kOS. Every GUI widget shares a common set of properties and methods.

## Methods

**Widget:SHOW()**
- Parameters: None
- Return value: None
- Makes the widget appear on screen. Equivalent to setting `Widget:VISIBLE` to true.
- Note: "Unless you use `show()` on the outermost Box of the GUI panel, nothing will ever be visible."

**Widget:HIDE()**
- Parameters: None
- Return value: None
- Makes the widget disappear from the screen. Equivalent to setting `Widget:VISIBLE` to false.

**Widget:DISPOSE()**
- Parameters: None
- Return value: None
- Permanently removes the widget and prevents it from being made visible again.

## Attributes

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| VISIBLE | Scalar | Get/Set | Controls widget visibility. New widgets default to visible except outermost Box. |
| ENABLED | Boolean | Get/Set | When false, widget is greyed out and non-interactive. Defaults to true. |
| STYLE | Style | Get/Set | Controls widget appearance. Can be customized or swapped between widget types. |
| GUI | GUI | Get-only | Returns the outermost GUI container holding this widget. |
| PARENT | Box | Get-only | Returns the Box directly containing this widget. |
| HASPARENT | Boolean | Get-only | Returns false if widget has no parent; true otherwise. Prevents errors when accessing PARENT. |

## Usage Pattern

The typical workflow is described as:
1. Create a GUI panel with `GUI(200)`
2. Add widgets using methods like `panel:addbutton`, `panel:addhslider`, etc.
3. Call `panel:show()` to display the panel

Visibility behavior: "Hiding a widget will hide all widgets inside it, regardless of their individual visibility settings."
