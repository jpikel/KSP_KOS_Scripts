> Source: https://ksp-kos.github.io/KOS/structures/vessels/consumedresource.html (mirrored offline copy for local reference)

# ConsumedResource — kOS 1.4.0.0 Documentation

## ConsumedResource

A single resource value an engine consumes (such as fuel or oxidizer). This structure type is returned by the `Engine:CONSUMEDRESOURCES` suffix.

### Structure Definition

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Resource name |
| `AMOUNT` | Scalar | Total amount remaining (only valid while engine is running) |
| `CAPACITY` | Scalar | Total amount when full (only valid while engine is running) |
| `DENSITY` | Scalar | Density of this resource |
| `FUELFLOW` | Scalar | Current volumetric flow rate of fuel |
| `MAXFUELFLOW` | Scalar | Untweaked maximum volumetric flow rate of fuel |
| `REQUIREDFLOW` | Scalar | Required volumetric flow rate of fuel for current throttle |
| `MASSFLOW` | Scalar | Current mass flow rate of fuel |
| `MAXMASSFLOW` | Scalar | Untweaked maximum mass flow rate of fuel |
| `RATIO` | Scalar | Volumetric flow ratio of this resource |

### Suffix Details

**NAME**
- Access: Get only
- Type: String
- The identifier of the resource, such as "LIQUIDFUEL", "ELECTRICCHARGE", or "MONOPROP".

**AMOUNT**
- Access: Get only
- Type: Scalar
- Indicates how much resource remains and is accessible to the engine. Only valid while the engine is running.

**CAPACITY**
- Access: Get only
- Type: Scalar
- What AMOUNT would equal if the resource were completely full. Only valid while the engine is running.

**DENSITY**
- Access: Get only
- Type: Scalar
- The density value of this resource, measured in Megagrams of mass per unit of resource (for example, 0.005 represents 5 kilograms per unit).

**FUELFLOW**
- Access: Get only
- Type: Scalar
- The current volumetric consumption rate of this fuel by the engine.

**MAXFUELFLOW**
- Access: Get only
- Type: Scalar
- The volumetric consumption at standard conditions with throttle at maximum (1.0) and thrust limiter at 100%.

**REQUIREDFLOW**
- Access: Get only
- Type: Scalar
- The volumetric requirement at the current moment based on throttle setting. May exceed FUELFLOW for resources like INTAKEAIR.

**MASSFLOW**
- Access: Get only
- Type: Scalar
- The current mass-based consumption rate of this fuel.

**MAXMASSFLOW**
- Access: Get only
- Type: Scalar
- The mass-based consumption at standard conditions with throttle at maximum and thrust limiter at 100%.

**RATIO**
- Access: Get only
- Type: Scalar
- The volumetric proportion of this fuel relative to the total fuel mixture (for example, 0.5 means this fuel comprises half the required mixture).
