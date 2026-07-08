> Source: https://ksp-kos.github.io/KOS/structures/vessels/crafttemplate.html (mirrored offline copy for local reference)

# CraftTemplate

## Structure Definition

The `CraftTemplate` structure represents a spacecraft design template accessible through the `KUniverse` bound variable. These templates enable launching new vessels and retrieving initial craft data including descriptions and specifications.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Name of this craft template |
| `FILEPATH` | String | The path to the craft file |
| `DESCRIPTION` | String | The description as saved in the editor |
| `EDITOR` | String | The editor where this craft was saved |
| `LAUNCHSITE` | String | The default launch site for this craft |
| `MASS` | Scalar | The default mass of the craft |
| `COST` | Scalar | The default cost of the craft |
| `PARTCOUNT` | Scalar | The total number of parts in this craft |

## Detailed Attributes

### CraftTemplate:NAME

**Access:** Get only  
**Type:** String

Returns the name of the craft. It may differ from the file name.

### CraftTemplate:FILEPATH

**Access:** Get only  
**Type:** String

Returns the absolute file path to the craft file.

### CraftTemplate:DESCRIPTION

**Access:** Get only  
**Type:** String

Returns the description field of the craft, which may be edited from the drop down window below the craft name in the editor.

### CraftTemplate:EDITOR

**Access:** Get only  
**Type:** String

Name of the editor from which the craft file was saved. Valid values are `"VAB"` and `"SPH"`.

### CraftTemplate:LAUNCHSITE

**Access:** Get only  
**Type:** String

Returns the name of the default launch site of the craft. Valid values are `"LAUNCHPAD"` and `"RUNWAY"`.

### CraftTemplate:MASS

**Access:** Get only  
**Type:** Scalar

Returns the total default mass of the craft. This includes the dry mass and the mass of any resources loaded onto the craft by default.

### CraftTemplate:COST

**Access:** Get only  
**Type:** Scalar

Returns the total default cost of the craft. This includes the cost of the vessel itself as well as any resources loaded onto the craft by default.

### CraftTemplate:PARTCOUNT

**Access:** Get only  
**Type:** Scalar

Returns the total number of parts on the craft.
