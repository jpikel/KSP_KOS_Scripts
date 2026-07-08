> Source: https://ksp-kos.github.io/KOS/structures/misc/versioninfo.html (mirrored offline copy for local reference)

# VersionInfo Structure Documentation

## Overview

A `VersionInfo` structure decomposes the kOS version string into individual numeric components rather than keeping it as text. Access this structure via `CORE:VERSION`.

## Structure Definition

**VersionInfo**

### Members Table

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `MAJOR` | Scalar | Get only | First number in version string (vNN.xx.xx.xx) |
| `MINOR` | Scalar | Get only | Second number in version string (vxx.NN.xx.xx) |
| `PATCH` | Scalar | Get only | Third number in version string (vxx.xx.NN.xx) |
| `BUILD` | Scalar | Get only | Fourth number in version string (vxx.xx.xx.NN) |

## Attribute Details

### VersionInfo:MAJOR
- **Access:** Get only
- **Type:** Scalar
- Represents the "NN" in version format `vNN.xx.xx.xx`

### VersionInfo:MINOR
- **Access:** Get only
- **Type:** Scalar
- Represents the "NN" in version format `vxx.NN.xx.xx`

### VersionInfo:PATCH
- **Access:** Get only
- **Type:** Scalar
- Represents the "NN" in version format `vxx.xx.NN.xx`

### VersionInfo:BUILD
- **Access:** Get only
- **Type:** Scalar
- Represents the "NN" in version format `vxx.xx.xx.NN`
</content>
