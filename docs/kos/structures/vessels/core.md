> Source: https://ksp-kos.github.io/KOS/structures/vessels/core.html (mirrored offline copy for local reference)

# Core

Core represents your ability to identify and interact directly with the running kOS processor. You can use it to access the parent vessel, or to perform operations on the processor's part. You obtain a CORE structure by using the bound variable `core`.

## structure CORE

### Members

| Suffix | Type |
|--------|------|
| All suffixes of [`kOSProcessor`](kosprocessor.html#structure:KOSPROCESSOR) | - |
| [`VESSEL`](#attribute:CORE:VESSEL) | [`Vessel`](vessel.html#structure:VESSEL) |
| [`ELEMENT`](#attribute:CORE:ELEMENT) | [`Element`](element.html#structure:ELEMENT) |
| [`TAG`](#attribute:CORE:TAG) | [`String`](../misc/string.html#structure:STRING) |
| [`VERSION`](#attribute:CORE:VERSION) | [`VersionInfo`](../misc/versioninfo.html#structure:VERSIONINFO) |
| [`CURRENTVOLUME`](#attribute:CORE:CURRENTVOLUME) | [`Volume`](../volumes_and_files/volume.html#structure:VOLUME) |
| [`MESSAGES`](#attribute:CORE:MESSAGES) | [`MessageQueue`](../communication/message_queue.html#structure:MESSAGEQUEUE) |

### CORE:VESSEL

**Type:** VesselTarget

**Access:** Get only

"The vessel containing the current processor."

### CORE:ELEMENT

**Type:** Element

**Access:** Get only

"The element object containing the current processor."

### CORE:VERSION

**Type:** [`VersionInfo`](../misc/versioninfo.html#structure:VERSIONINFO)

**Access:** Get only

"The kOS version currently running."

### CORE:TAG

**Type:** [`String`](../misc/string.html#structure:STRING)

**Access:** Get/Set

"The kOS name tag currently assigned to the part this core is inside. This is the same thing as" `CORE:PART:TAG`.

### CORE:CURRENTVOLUME

**Type:** [`Volume`](../volumes_and_files/volume.html#structure:VOLUME)

**Access:** Get only

"The currently selected volume for the current processor. This may be useful to prevent deleting files on the Archive, or for interacting with multiple local hard disks."

### CORE:MESSAGES

**Type:** [`MessageQueue`](../communication/message_queue.html#structure:MESSAGEQUEUE)

**Access:** Get only

"Returns this processor's message queue."
