> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/path.html (mirrored offline copy for local reference)

# Path Structure Documentation

## Path

The Path structure represents a filesystem path and provides helpful suffixes for path manipulation. You can instantiate new Path objects using the `path()` function.

Path instances work as arguments wherever string paths are accepted:

```
copypath("../file", path()).
```

## Structure: PATH

| Suffix | Type | Description |
|--------|------|-------------|
| `VOLUME` | Volume | Volume this path belongs to |
| `SEGMENTS` | List of String | List of this path's segments |
| `LENGTH` | Scalar | Number of segments in this path |
| `NAME` | String | Name of file or directory this path points to |
| `HASEXTENSION` | Boolean | True if path contains an extension |
| `EXTENSION` | String | This path's extension |
| `ROOT` | Path | Root path of this path's volume |
| `PARENT` | Path | Parent path |
| `CHANGENAME(name)` | Path | Returns a new path with its name (last segment) changed |
| `CHANGEEXTENSION(extension)` | Path | Returns a new path with extension changed |
| `ISPARENT(path)` | Boolean | True if path is the parent of this path |
| `COMBINE(name1, [name2, ...])` | Path | Returns a new path created by adding further elements to this one |

## Path:VOLUME

**Type:** Volume  
**Access:** Get only

The volume to which this path belongs.

## Path:SEGMENTS

**Type:** List of String  
**Access:** Get only

"List of segments this path contains. Segments are parts of the path separated by /. For example path 0:/directory/subdirectory/script.ks contains the following segments: directory, subdirectory and script.ks."

## Path:LENGTH

**Type:** Scalar  
**Access:** Get only

The number of segments contained in this path.

## Path:NAME

**Type:** String  
**Access:** Get only

The name of the file or directory this path points to (equivalent to the last segment).

## Path:HASEXTENSION

**Type:** Boolean  
**Access:** Get only

True when the last segment of this path includes an extension.

## Path:EXTENSION

**Type:** String  
**Access:** Get only

The extension of the last segment of this path.

## Path:ROOT

**Type:** Path  
**Access:** Get only

Returns a new path pointing to the root directory of this path's volume.

## Path:PARENT

**Type:** Path  
**Access:** Get only

Returns a new path pointing to this path's parent directory. Raises an exception if this path has no parent (when length equals 0).

## Path:CHANGENAME(name)

**Parameters:**
- **name** – String: new path name

**Returns:** Path

Returns a new path with the last segment replaced, or adds a segment if none exists.

## Path:CHANGEEXTENSION(extension)

**Parameters:**
- **extension** – String: new path extension

**Returns:** Path

Returns a new path with the extension of the last segment replaced, or adds an extension if none exists.

## Path:ISPARENT(path)

**Parameters:**
- **path** – Path: path to check

**Returns:** Boolean

Returns true when the specified path is the parent of this path.

## Path:COMBINE(name1, [name2, ...])

**Parameters:**
- **name** – String: segments to add

**Returns:** Path

"Returns a new path that represents the file or directory that would be reached by starting from this path and then appending the path elements given in the list."

Example:

```
set p to path("0:/home").
set p2 to p:combine("d1", "d2", "file.ks").
print p2
0:/home/d1/d2/file.ks
```
