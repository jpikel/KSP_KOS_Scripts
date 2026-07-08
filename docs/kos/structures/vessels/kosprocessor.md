> Source: https://ksp-kos.github.io/KOS/structures/vessels/kosprocessor.html (mirrored offline copy for local reference)

# kOSProcessor

The following is the documentation for the kOSProcessor structure in kOS 1.4.0.0:

## kOSProcessor

The type of structures returned by kOS when querying a module that contains a kOS processor.

### Structure Definition

**kOSProcessor** objects are a type of `PartModule` and inherit all suffixes from that structure.

| Suffix | Type | Description |
|--------|------|-------------|
| `MODE` | String | OFF, READY or STARVED |
| `ACTIVATE` | None | Activates this processor |
| `DEACTIVATE` | None | Deactivates this processor |
| `TAG` | String | This processor's name tag |
| `VOLUME` | Volume | This processor's hard disk |
| `BOOTFILENAME` | String | The filename for the boot file on this processor |
| `CONNECTION` | Connection | Returns your connection to this processor |

### kOSProcessor:MODE

**Access:** Get only

**Type:** String

Indicates the current state of this processor. OFF indicates deactivated, READY indicates active, or STARVED indicates no power.

### kOSProcessor:ACTIVATE()

**Returns:** None

Activate this processor.

### kOSProcessor:DEACTIVATE()

**Returns:** None

Deactivate this processor.

### kOSProcessor:TAG

**Access:** Get only

**Type:** String

This processor's name tag.

### kOSProcessor:VOLUME

**Access:** Get only

**Type:** Volume

This processor's hard disk.

### kOSProcessor:BOOTFILENAME

**Access:** Get or Set

**Type:** String

The filename for the boot file on this processor. This may be set to an empty string "" or to "None" to disable the use of a boot file.

### kOSProcessor:CONNECTION

**Return:** Connection

Returns your connection to this processor.
