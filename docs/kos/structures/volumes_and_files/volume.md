> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/volume.html (mirrored offline copy for local reference)

# Volume

Represents a `kOSProcessor` hard disk or the archive.

## structure Volume

| Suffix | Type | Description |
|--------|------|-------------|
| `FREESPACE` | `Scalar` | Free space left on the volume |
| `CAPACITY` | `Scalar` | Total space on the volume |
| `NAME` | `String` | Get or set volume name |
| `RENAMEABLE` | `Scalar` | True if the name can be changed |
| `ROOT` | `VolumeDirectory` | Volume's root directory |
| `FILES` | `Lexicon` | Lexicon of all files and directories on the volume |
| `POWERREQUIREMENT` | `Scalar` | Amount of power consumed when this volume is set as the current volume |
| `EXISTS(path)` | `Boolean` | Returns true if the given file or directory exists |
| `CREATE(path)` | `VolumeFile` | Creates a file |
| `CREATEDIR(path)` | `VolumeDirectory` | Creates a directory |
| `OPEN(path)` | `VolumeItem` or `Boolean` | Opens a file or directory |
| `DELETE(path)` | `Boolean` | Deletes a file or directory |

### Volume:FREESPACE

**Type:** `Scalar`

**Access:** Get only

Indicates the available storage capacity remaining on this volume.

### Volume:CAPACITY

**Type:** `Scalar`

**Access:** Get only

Indicates the total storage capacity of this volume.

### Volume:NAME

**Type:** `String`

**Access:** Get and Set

Retrieves or modifies the volume name. This identifier can substitute for the volumeId in file and volume-related operations.

### Volume:RENAMEABLE

**Type:** `Boolean`

**Access:** Get only

Indicates whether renaming this volume is permitted. The archive volume cannot be renamed.

### Volume:FILES

**Type:** `Lexicon` of `VolumeItem`

**Access:** Get only

Provides a collection of all files and directories stored on this volume, with item names as keys and corresponding `VolumeItem` structures as values.

### Volume:ROOT

**Type:** `VolumeDirectory`

**Access:** Get only

Returns the top-level directory of the volume.

### Volume:POWERREQUIREMENT

**Type:** `Scalar`

**Access:** Get only

Specifies the electrical power consumed when this volume becomes the active volume.

### Volume:EXISTS(path)

**Returns:** `Boolean`

Checks whether a file or directory is present at the specified location. This returns true if a matching file exists or if a file with the same name plus ".ks" or ".ksm" extension exists. Use `Volume:FILES:HASKEY(name)` for strict matching.

Paths must not include volume identifiers or names and must be absolute.

### Volume:OPEN(path)

**Returns:** `VolumeItem` or `Boolean` false

Accesses the file or directory at the specified path, returning a `VolumeItem` structure. Returns false if the path does not exist.

Paths must not include volume identifiers or names and must be absolute.

### Volume:CREATE(path)

**Returns:** `VolumeFile`

Establishes a new file at the designated path and returns its `VolumeFile` structure. Operation fails if the file already exists.

Paths must not include volume identifiers or names and must be absolute.

### Volume:CREATEDIR(path)

**Returns:** `VolumeDirectory`

Establishes a new directory at the designated path and returns its `VolumeDirectory` structure. Operation fails if the directory already exists.

Paths must not include volume identifiers or names and must be absolute.

### Volume:DELETE(path)

**Returns:** boolean

Removes the specified file or directory (including contents). Returns true on successful deletion, false otherwise.

Paths must not include volume identifiers or names and must be absolute.
