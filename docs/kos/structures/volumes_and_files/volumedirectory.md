> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/volumedirectory.html (mirrored offline copy for local reference)

# VolumeDirectory

Represents a directory on a kOS file system.

Instances of this class are enumerable; each iteration step provides a `VolumeFile` or `VolumeDirectory` contained within this directory.

## structure VolumeDirectory

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of `VolumeItem` | — | `VolumeDirectory` objects are a type of `VolumeItem` |
| `LEXICON` | `LEXICON` of `VolumeFile` or `VolumeDirectory` | Lists all files and directories |
| `LEX` | `LEXICON` of `VolumeFile` or `VolumeDirectory` | Alias for `LEXICON` |
| `LIST` | `LEXICON` of `VolumeFile` or `VolumeDirectory` | Alias for `LEXICON` |

### VolumeDirectory:LEXICON()

**Returns:** `Lexicon` of `VolumeFile` or `VolumeDirectory`

Returns a Lexicon containing all files and directories in this directory. Each key-value pair uses the string name as the key and the corresponding `VolumeFile` or `VolumeDirectory` as the value.

### VolumeDirectory:LEX()

An alias for `LEXICON`.

### VolumeDirectory:LIST()

An alias for `LEXICON`. The name "List" returns a Lexicon rather than a List for backward compatibility reasons.
