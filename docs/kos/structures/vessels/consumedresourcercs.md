> Source: https://ksp-kos.github.io/KOS/structures/vessels/consumedresourcercs.html (mirrored offline copy for local reference)

# ConsumedResourceRCS

A single resource value an RCS thruster consumes (i.e. monopropellant, etc). This is the type returned by the `RCS:CONSUMEDRESOURCES` suffix.

## Structure: ConsumedResourceRCS

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Resource name |
| `AMOUNT` | Scalar | Total amount remaining (only valid while engine is running) |
| `CAPACITY` | Scalar | Total amount when full (only valid while engine is running) |
| `DENSITY` | Scalar | Density of this resource |
| `RATIO` | Scalar | Volumetric flow ratio of this resource |

### ConsumedResourceRCS:NAME

**Access:** Get only  
**Type:** String

The name of the resource, i.e. "LIQUIDFUEL", "ELECTRICCHARGE", "MONOPROP".

### ConsumedResourceRCS:AMOUNT

**Access:** Get only  
**Type:** Scalar

The value of how much resource is left and accessible to this thruster. Only valid while the thruster is running.

### ConsumedResourceRCS:CAPACITY

**Access:** Get only  
**Type:** Scalar

What AMOUNT would be if the resource was filled to the top. Only valid while the thruster is running.

### ConsumedResourceRCS:DENSITY

**Access:** Get only  
**Type:** Scalar

The density value of this resource, expressed in Megagrams of mass per Unit of resource. (i.e. a value of 0.005 would mean that each unit of this resource is 5 kilograms. Megagrams [metric tonnes] is the usual unit that most mass in the game is represented in.)

### ConsumedResourceRCS:RATIO

**Access:** Get only  
**Type:** Scalar

What is the volumetric ratio of this fuel as a proportion of the overall fuel mixture, e.g. if this is 0.5 then this fuel is half the required fuel for the thruster.
