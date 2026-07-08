> Source: https://ksp-kos.github.io/KOS/commands/files.html (mirrored offline copy for local reference)

# File I/O — kOS 1.4.0.0 Documentation

## File I/O

For information about where files are kept and how to deal with volumes, see the Volumes page in the general topics section.

### Understanding Directories

kOS supports directory structures similar to real operating systems. Directories can contain other directories, creating a tree-like structure. Unlike files, directories do not consume space on the volume, allowing unlimited directory creation.

### Paths

kOS uses path strings to describe file and directory locations. Two path types exist: absolute paths (which explicitly state all location data) and relative paths (which describe location relative to the current directory).

**Path Format:**

Absolute paths follow this structure:
```
volumeIdOrName:\[/directory/subdirectory/...\]/filename
```

The first slash after the colon is optional.

Valid absolute path examples:
```
0:flight_data/data.json
secondcpu:
1:/boot.ks
```

The special `..` directory name denotes a parent directory. Invalid paths include those pointing to the parent of a volume's root directory.

**Current Directory:**

kOS maintains a current directory concept. Use `cd(path)` to change directories and `PATH()` to print the current directory path. The `LIST` command shows current directory contents.

**Relative Paths:**

Relative paths are transformed into absolute paths by adding them to the current directory. Empty relative paths point to the current directory.

```
CD("0:/scripts").
DELETEPATH("launch.ks").  // removes 0:/scripts/launch.ks
COPYPATH("../launch.ks", "").  // copies 0:/launch.ks to 0:/scripts/launch.ks
```

**Bareword Arguments:**

Path arguments can omit quotes in limited cases:
- Simple relative paths work without quotes: `RUN script.`, `CD(dir.ext)`
- Bareword paths containing only A-Z, 0-9, underscore, and periods work
- Paths with special characters require quotes
- Case-sensitive filesystems require quotes for mixed-case filenames

Valid examples:
```
COPYPATH(myfilename, "1:").
COPYPATH("myfilename", "1:").
COPYPATH(myfilename.ks, "1:").
```

**Other Data Types as Paths:**

Paths can accept Path, Volume, VolumeFile, or VolumeDirectory structures.

#### path(pathString)

Creates a Path structure representing the given path string. Omit the argument to reference the current directory.

#### scriptpath()

Returns a Path structure representing the currently running script's path.

### Volumes

#### volume(volumeIdOrName)

Returns a Volume structure for the specified volume by ID or name. Omit the argument for the current volume.

#### SWITCH TO Volume|volumeId|volumeName

Changes the current directory to the specified volume's root directory.

Example:
```
SWITCH TO 0.
SET VOLUME(1):NAME TO "AwesomeDisk".
SWITCH TO "AwesomeDisk".
PRINT VOLUME(1):NAME.
```

### Files and Directories

#### LIST

Shows a printed list of files and subdirectories in the current working directory. This is shorthand for `LIST FILES`.

#### CD(PATH)

Changes the current directory to the specified path. Fails if the path is invalid or doesn't point to an existing directory.

#### COPYPATH(FROMPATH, TOPATH)

Copies files or directories from FROMPATH to TOPATH with behavior dependent on the source and destination:

**File source scenarios:**
- Destination is a directory: file copies into it
- Destination is a file: contents overwrite destination file
- Destination doesn't exist: new file created with parent directories as needed

**Directory source scenarios:**
- Destination is a directory: source directory copies inside it
- Destination is a file: command fails
- Destination doesn't exist: new directory created with contents copied

**Non-existing source:** Command fails

#### MOVEPATH(FROMPATH, TOPATH)

Moves files or directories from FROMPATH to TOPATH with behavior matching COPYPATH.

#### DELETEPATH(PATH)

Deletes the file or directory at PATH. Directories remove along with all contained items.

#### EXISTS(PATH)

Returns true if a file or directory exists at the given path; false otherwise.

#### CREATE(PATH)

Creates a file at the given path. Creates parent directories as needed. Fails if an item already exists at the path.

#### CREATEDIR(PATH)

Creates a directory at the given path. Creates parent directories as needed. Fails if an item already exists at the path.

#### OPEN(PATH)

Returns a VolumeFile or VolumeDirectory structure for the item at PATH. Returns false if nothing exists at the path.

### JSON

#### WRITEJSON(OBJECT, PATH)

Serializes an object to JSON format and saves it at the given path.

Example:
```
SET L TO LEXICON().
SET NESTED TO QUEUE().

L:ADD("key1", "value1").
L:ADD("key2", NESTED).

NESTED:PUSH("nestedvalue").

WRITEJSON(L, "output.json").
```

#### READJSON(PATH)

Reads and deserializes a file created with WRITEJSON.

Example:
```
SET L TO READJSON("output.json").
PRINT L["key1"].
```

### Miscellaneous

#### Running Scripts

Run saved script files using run commands:

```
RUNPATH("filename", arg1, arg2).
RUN filename(arg1, arg2).
```

Consult the Run Command page for full details.

#### LOG TEXT TO PATH

Logs selected text to a file.

**Arguments:**
- argument 1: Value to log
- argument 2: Path to the destination file

Examples:
```
LOG "Hello" to mylog.txt.
LOG 4+1 to "mylog".
LOG "4 times 8 is: " + (4*8) to mylog.
```

#### COMPILE PROGRAM (TO COMPILEDPROGRAM)

*(experimental)*

Pre-compiles a script into a Kerboscript ML Executable image.

**Arguments:**
- argument 1: Path to source file
- argument 2: Path to destination file (optional; defaults to source path with .ksm extension)

The RUN, RUNPATH, or RUNONCEPATH commands work with both *.ks and *.ksm files.

#### EDIT PATH

Opens the built-in editor for the file at PATH. Creates a new file if it doesn't exist.

**Arguments:**
- argument 1: Path of the file for editing

Examples:
```
EDIT filename.
EDIT filename.ks.
EDIT "filename.ks".
EDIT "filename".
EDIT "filename.txt".
```

Note: When creating new files, include the .ks extension explicitly if desired.
