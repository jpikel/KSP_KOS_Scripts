> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/volumefile.html (mirrored offline copy for local reference)

# VolumeFile

File name and size information. You can obtain a list of values of type VolumeFile using the LIST FILES command.

## structure VolumeFile

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of `VolumeItem` | — | `VolumeFile` objects are a type of `VolumeItem` |
| `READALL` | `FileContent` | Reads file contents |
| `WRITE(String\|FileContent)` | `Boolean` | Writes the given string to the file |
| `WRITELN(string)` | `Boolean` | Writes the given string and a newline to the file |
| `CLEAR` | None | Clears this file |

## VolumeFile:READALL()

**Returns:** `FileContent`

Reads the content of the file.

## VolumeFile:WRITE(String|FileContent)

**Returns:** `Boolean`

"Writes the given string or a FileContent to the file. Returns true if successful (lack of space on the Volume can cause a failure)."

## VolumeFile:WRITELN(string)

**Returns:** `Boolean`

"Writes the given string followed by a newline to the file. Returns true if successful."

## VolumeFile:CLEAR()

**Returns:** None

Clears this file
