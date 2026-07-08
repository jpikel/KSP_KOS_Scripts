> Source: https://ksp-kos.github.io/KOS/structures/vessels/partmodule.html (mirrored offline copy for local reference)

# PartModule Documentation

## Overview

The `PartModule` structure provides access to functionality exposed through right-click menus and action groups in Kerbal Space Program. According to the documentation, "Almost everything done with at right-click menus and action group action can be accessed via the PartModule objects that are attached to Parts of a Vessel."

For detailed context on how modules relate to parts and vessels, the documentation recommends reviewing the "Ship parts and Modules" reference page.

## Structure Members

| Suffix | Type | Description |
|--------|------|-------------|
| NAME | string | Name of this part module |
| PART | Part | Part attached to |
| ALLFIELDS | List of strings | Accessible fields |
| ALLFIELDNAMES | List of strings | Accessible fields (name only) |
| ALLEVENTS | List of strings | Triggerable events |
| ALLEVENTNAMES | List of strings | Triggerable event names |
| ALLACTIONS | List of strings | Triggerable actions |
| ALLACTIONNAMES | List of strings | Triggerable event names |
| GETFIELD(name) | varies | Get value of a field by name |
| SETFIELD(name,value) | — | Set value of a field by name |
| DOEVENT(name) | — | Trigger an event button |
| DOACTION(name,bool) | — | Activate action by name with True or False |
| HASFIELD(name) | Boolean | Check if field exists |
| HASEVENT(name) | Boolean | Check if event exists |
| HASACTION(name) | Boolean | Check if action exists |

## Detailed Member Descriptions

### NAME
**Access:** Get only

Returns the module name as specified in the part's cfg file.

### PART
**Access:** Get only

Returns the `Part` object to which this module is attached.

### ALLFIELDS
**Access:** Get only

Returns a list of all KSPFields currently accessible via GETFIELD or SETFIELD. This list may change as gameplay progresses.

### ALLFIELDNAMES
**Access:** Get only

Similar to ALLFIELDS but returns unformatted names for easier script usage.

### ALLEVENTS
**Access:** Get only

Returns a list of all KSPEvents currently triggerable via DOEVENT. Subject to change during gameplay.

### ALLEVENTNAMES
**Access:** Get only

Similar to ALLEVENTS but returns unformatted names.

### ALLACTIONS
**Access:** Get only

Returns a list of all KSPActions currently triggerable via DOACTION.

### ALLACTIONNAMES
**Access:** Get only

Similar to ALLACTIONS but returns unformatted names.

### GETFIELD(name)
**Parameters:**
- name (String): Name of the field

**Returns:** varies

Retrieves the value of a field visible on the right-click menu. The name parameter should match the GUI label, not the internal variable name.

### SETFIELD(name,value)
**Parameters:**
- name (String): Name of the field
- value: The value to set

Sets a field value. Only works for parts attached to the CPU Vessel. Values are constrained as follows:

- **Boolean fields:** Accept true, false, 0, or 1
- **Integer fields:** Must be whole numbers
- **Floating-point fields:** Constrained to slider min/max ranges with increment steps
- **String fields:** Currently unsettable

**Symmetry Note:** Unlike GUI interaction, SETFIELD does not automatically update symmetrical parts. To modify symmetrical parts, manually iterate through them using `Part:SYMMETRYPARTNER(index)`.

### DOEVENT(name)
**Parameters:**
- name (String): Name of the event

Triggers an event button currently visible on the right-click menu. Only works for parts on the CPU Vessel.

### DOACTION(name,bool)
**Parameters:**
- name (String): Name of the action
- bool (Boolean): True to activate, False to deactivate

Activates an action group-able action directly, bypassing the action group system. Only works for parts on the CPU Vessel.

### HASFIELD(name)
**Parameters:**
- name (String): Name of the field

**Returns:** Boolean

Checks if a field is currently available for GETFIELD or SETFIELD operations.

### HASEVENT(name)
**Parameters:**
- name (String): Name of the event

**Returns:** Boolean

Checks if an event is currently available for DOEVENT operations.

### HASACTION(name)
**Parameters:**
- name (String): Name of the action

**Returns:** Boolean

Checks if an action is currently available for DOACTION operations.

## Security and Design Notes

### Exposure Principles

The kOS developers have deliberately restricted access to only those fields, events, and actions visible to users in the GUI, respecting mod author intentions. Fields not shown in right-click menus remain hidden from scripts.

### Access Rules

**KSPFields:** Readable if visible on the right-click menu; settable only if the GUI displays a tweakable control AND that control is currently enabled.

**KSPEvents:** Triggerable only if a GUI button is currently visible on the right-click menu.

**KSPActions:** Triggerable if they would be available for action group assignment in the VAB/SPH, even if never actually assigned.

### Runtime Variability

Module fields, events, and actions can change during gameplay. Examples include docking port "Undock" buttons appearing only when connected, or toggle events that swap visibility based on state. The context determines which elements are currently available.
