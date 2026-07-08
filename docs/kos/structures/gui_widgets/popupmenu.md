> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/popupmenu.html (mirrored offline copy for local reference)

# PopupMenu — kOS 1.4.0.0 Documentation

## PopupMenu

**structure** PopupMenu

`PopupMenu` objects are created by calling `BOX:ADDPOPUPMENU`.

A `PopupMenu` is a special kind of button for choosing from a list of things. It looks like a button displaying the currently selected item. When a user clicks the button, it pops up a list of displayed strings to choose from, and when one is selected the popup closes and the new choice displays on the button.

The menu displays string values in the OPTIONS property. If OPTIONS contains non-string items, their `TOSTRING` suffixes are used by default for display. You can change this behavior by setting the popupmenu's `OPTIONSUFFIX`.

### Example

```
local popup is gui:addpopupmenu().

// Make the popup display the Body:NAME's instead of the Body:TOSTRING's:
set popup:OPTIONSUFFIX to "NAME".

list bodies in bodies.
for planet in bodies {
        if planet:hasbody and planet:body \= Sun {
                popup:addoption(planet).
        }
}
set popup:value to body.
```

## Suffix Table

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `BUTTON` | — | — |
| `OPTIONS` | `List` | List of options to display |
| `OPTIONSUFFIX` | `String` | Name of suffix used for display names. Default = TOSTRING |
| `ADDOPTION(value)` | — | Add a value to the end of the options list |
| `VALUE` | Any | Returns the current selected value |
| `INDEX` | `Scalar` | Returns the index of the current selected value |
| `CHANGED` | `Boolean` | Has the user chosen something? |
| `ONCHANGE` | `KOSDelegate` (`String`) | Function called when `CHANGED` state changes |
| `CLEAR` | — | Removes all options |
| `MAXVISIBLE` | `Scalar` (integer) | How many choices to show at once (scrollable if more exist) |

## PopupMenu:OPTIONS

**Type:** `List` (of any Structure)

**Access:** Get/Set

This is the list of options the user can choose from. They don't need to be Strings, but must be capable of having a string extracted for display using the `OPTIONSUFFIX` suffix.

## PopupMenu:OPTIONSUFFIX

**Type:** `String`

**Access:** Get/Set

This decides how strings are extracted from items in `OPTIONS`. While typically used with string lists, any object type can be used provided all items share a common suffix that builds a string. The default is `"TOSTRING"`, a suffix all kOS objects have. Set this to another suffix's string name to use alternatives.

## PopupMenu:ADDOPTION(value)

**Parameters:**
- **value** – any kOS type provided it has the suffix mentioned in `OPTIONSUFFIX`

**Type value:** `Structure`

**Access:** Get/Set

This appends another choice to the `OPTIONS` list.

## PopupMenu:VALUE

**Type:** `Structure`

**Access:** Get/Set

Returns the value currently chosen from the list. If no selection has been made, returns an empty `String` (`""`).

Setting this value chooses which item is selected. If set to something not in the list, the attempt is rejected and the choice becomes de-selected.

## PopupMenu:INDEX

**Type:** `Scalar`

**Access:** Get/Set

Returns the numeric index into the `OPTIONS` list corresponding to the current choice. `-1` means nothing is selected.

Setting this value changes the selected choice. Setting to `-1` de-selects the choice.

## PopupMenu:CHANGED

**Type:** `Boolean`

**Access:** Get/Set

Indicates whether the choice has changed since last checked.

Reading this has a side effect: it causes the value to become `false` if it was `true`. This is intended for the polling technique of reading widgets. Query this field until it returns `true`, then check the current value.

## PopupMenu:ONCHANGE

**Type:** `KOSDelegate`

**Access:** Get/Set

A `KOSDelegate` callback invoked when a new selection is made. The function must accept one parameter (the new value) and return nothing.

### Example

```
set myPopupMenu:ONCHANGE to { parameter choice. print "You have selected: " + choice:TOSTRING. }.
```

## PopupMenu:CLEAR()

**Returns:** (nothing)

Wipes out all contents of the `OPTIONS` list.

## PopupMenu:MAXVISIBLE

**Type:** `Scalar`

**Access:** Get/Set

**Default:** 15

Sets the largest number of choices the layout system will grow the popup window to support before using a scrollbar. This value is a rough hint. Setting too large may make the popup too large to fit on screen with many items.
