> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/filecontent.html (mirrored offline copy for local reference)

# FileContent

Represents the contents of a file. You can obtain an instance of this class using `VolumeFile:READALL`.

Internally this class stores raw data (a byte array). It can be passed around as is, for example this will copy a file:

```
SET CONTENTS TO OPEN("filename"):READALL.
SET NEWFILE TO CREATE("newfile").
NEWFILE:WRITE(CONTENTS).
```

You can parse the contents to read them as a string:

```
SET CONTENTS_AS_STRING TO OPEN("filename"):READALL:STRING.
// do something with a string:
PRINT CONTENTS_AS_STRING:CONTAINS("test").
```

Instances of this class can be iterated over. In each iteration step a single line of the file will be read.

## structure FileContent

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| `LENGTH` | Scalar | File length (in bytes) |
| `EMPTY` | Boolean | True if the file is empty |
| `TYPE` | String | Type of the content |
| `STRING` | String | Contents of the file decoded using UTF-8 encoding |
| `BINARY` | List | Contents of the file as a list of bytes |
| `ITERATOR` | Iterator | Iterates over the lines of a file |

**Note:** This type is serializable.

## FileContent:LENGTH

**Type:** Scalar

**Access:** Get only

Length of the file.

## FileContent:EMPTY

**Type:** Boolean

**Access:** Get only

True if the file is empty

## FileContent:TYPE

**Type:** String

**Access:** Get only

Type of the content as a string. Can be one of the following:

- **TOOSHORT** – Content too short to establish a type
- **ASCII** – A file containing ASCII text, like the result of a LOG command.
- **KSM** – A type of file containing KerboMachineLanguage compiled code, created from the COMPILE command.
- **BINARY** – Any other type of file.

## FileContent:STRING

**Type:** String

**Access:** Get only

Contents of the file decoded using UTF-8 encoding

## FileContent:BINARY

**Type:** List

**Access:** Get only

Contents of the file as a list of bytes. Each item in the list is a number between 0 and 255 representing a single byte from the file.

## FileContent:ITERATOR

**Type:** Iterator

**Access:** Get only

Iterates over the lines of a file
