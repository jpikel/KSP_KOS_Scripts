> Source: https://ksp-kos.github.io/KOS/structures/vessels/resource.html (mirrored offline copy for local reference)

# Resource

A single resource value a thing holds (i.e. fuel, electric charge, etc). This is the type returned by the `Part:RESOURCES` suffix

## Structure: Resource

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Resource name |
| `AMOUNT` | Scalar | Amount of this resource left |
| `DENSITY` | Scalar | Density of this resource |
| `CAPACITY` | Scalar | Maximum amount of this resource |
| `TOGGLEABLE` | Boolean | Can this tank be removed from the fuel flow |
| `ENABLED` | Boolean | Is this tank currently in the fuel flow |

### Resource:NAME

**Access:** Get only

**Type:** String

"The name of the resource, i.e. 'LIQUIDFUEL', 'ELECTRICCHARGE', 'MONOPROP'."

### Resource:AMOUNT

**Access:** Get only

**Type:** Scalar

The quantity indicating how much of this resource remains available.

### Resource:DENSITY

**Access:** Get only

**Type:** Scalar

The density value of this resource, expressed in Megagrams of mass per Unit of resource. (i.e. a value of 0.005 would mean that each unit of this resource is 5 kilograms. Megagrams [metric tonnes] is the usual unit that most mass in the game is represented in.)

### Resource:CAPACITY

**Access:** Get only

**Type:** Scalar

The maximum amount value if the resource were completely filled.

### Resource:TOGGLEABLE

**Access:** Get only

**Type:** Boolean

Many, but not all, resources can be turned on and off, this removes them from the fuel flow.

### Resource:ENABLED

**Access:** Get/Set

**Type:** Boolean

When the resource supports toggling, setting this to false prevents the resource from being consumed normally.
