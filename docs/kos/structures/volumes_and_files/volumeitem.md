> Source: https://ksp-kos.github.io/KOS/structures/volumes_and_files/volumeitem.html (mirrored offline copy for local reference)

# VolumeItem

Contains suffixes common to [files](volumefile.html#structure:VOLUMEFILE) and [directories](volumedirectory.html#structure:VOLUMEDIRECTORY).

## Structure: VolumeItem

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| [`NAME`](#name) | [`String`](../misc/string.html#structure:STRING) | Name of the item including extension |
| [`EXTENSION`](#extension) | [`String`](../misc/string.html#structure:STRING) | Item extension |
| [`SIZE`](#size) | [`Scalar`](../../math/scalar.html#structure:SCALAR) | Size of the file |
| [`ISFILE`](#isfile) | [`Boolean`](../misc/boolean.html#structure:BOOLEAN) | Size of the file |

## VolumeItem:NAME

**Access:** Get only

**Type:** [`String`](../misc/string.html#structure:STRING)

The name of the item, including the extension.

## VolumeItem:EXTENSION

**Access:** Get only

**Type:** [`String`](../misc/string.html#structure:STRING)

Item extension (part of the name after the last dot).

## VolumeItem:SIZE

**Access:** Get only

**Type:** [`Scalar`](../../math/scalar.html#structure:SCALAR)

Size of the item, in bytes.

## VolumeItem:ISFILE

**Access:** Get only

**Type:** [`Boolean`](../misc/boolean.html#structure:BOOLEAN)

True if this item is a file.
