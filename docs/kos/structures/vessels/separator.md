> Source: https://ksp-kos.github.io/KOS/structures/vessels/separator.html (mirrored offline copy for local reference)

# Separator

Some of the Parts returned by `LIST PARTS` will be of type `Separator`.

A separator part is one that detaches a vessel into at least two parts, in a permanent way (rather than a
docking port, which can be re-attached). Both decouplers and separators count.

## structure Separator

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of `Decoupler` | | A `Separator` is a kind of `Decoupler` (which is `Part`) |
| `EJECTIONFORCE` | `Scalar` | Force that applies when the decoupling event fires. |
| `ISDECOUPLED` | `Boolean` | True if this part already has had its decoupling event triggered. |
| `STAGED` | `Boolean` | True if this part is set up to decouple as part of the staging list. |

### Separator:EJECTIONFORCE

**Type:** `Scalar`

**Access:** Get only

Force of the push that happens when this decoupler is fired.

### Separator:ISDECOUPLED

**Type:** `Boolean`

**Access:** Get only

True if this part has already had its decoupling event triggered.

### Separator:STAGED

**Type:** `Boolean`

**Access:** Get only

True if this part's decoupling event is in the vessel's staging list.
