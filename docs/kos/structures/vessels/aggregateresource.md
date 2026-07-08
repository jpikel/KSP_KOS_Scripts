> Source: https://ksp-kos.github.io/KOS/structures/vessels/aggregateresource.html (mirrored offline copy for local reference)

# AggregateResource

## Overview

The `AggregateResource` structure represents a summation of resources across multiple ship parts. It's returned when using the `LIST RESOURCES` command or accessing `STAGE:RESOURCES`.

## Structure Definition

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | Resource name |
| `AMOUNT` | Scalar | Total amount remaining |
| `CAPACITY` | Scalar | Total amount when full |
| `DENSITY` | Scalar | Density of this resource |
| `PARTS` | List | Parts containing this resource |

## Attributes

**NAME** (Get only, String)
- The resource identifier, such as "LIQUIDFUEL", "ELECTRICCHARGE", or "MONOPROP"

**AMOUNT** (Get only, Scalar)
- Current quantity of the resource available

**CAPACITY** (Get only, Scalar)
- Maximum possible amount if the resource were completely full

**DENSITY** (Get only, Scalar)
- Mass per unit measured in Megagrams per resource unit. For example, 0.005 indicates 5 kilograms per unit.

**PARTS** (Get only, List)
- Collection of all parts that contain or could contain this resource

## Example Usage

```
PRINT "THESE ARE ALL THE RESOURCES ON THE SHIP:".
LIST RESOURCES IN RESLIST.
FOR RES IN RESLIST {
    PRINT "Resource " + RES:NAME.
    PRINT "    value = " + RES:AMOUNT.
    PRINT "    which is "
          + ROUND(100*RES:AMOUNT/RES:CAPACITY)
          + "% full.".
}.
```

```
PRINT "THESE ARE ALL THE RESOURCES active in this stage:".
SET RESLIST TO STAGE:RESOURCES.
FOR RES IN RESLIST {
    PRINT "Resource " + RES:NAME.
    PRINT "    value = " + RES:AMOUNT.
    PRINT "    which is "
          + ROUND(100*RES:AMOUNT/RES:CAPACITY)
          + "% full.".
}.
```
