> Source: https://ksp-kos.github.io/KOS/commands/parts.html (mirrored offline copy for local reference)

# Querying a vessel's parts

This documentation covers methods for accessing and filtering vessel components in kOS 1.4.0.0. The page provides practical examples of part query syntax.

## Getting All Parts

Two equivalent approaches retrieve the complete parts list:

```
LIST PARTS IN MyPartList.
SET MyPartlist TO SHIP:PARTS.
```

## Filtering by Name Variations

To locate parts matching a given identifier across multiple naming systems:

```
SET MyPartList to SHIP:PARTSDUBBED("something").
```

More specific queries target particular nomenclature standards:

```
SET MyPartList to SHIP:PARTSTAGGED("something").
SET MyPartList to SHIP:PARTSTITLED("something").
SET MyPartList to SHIP:PARTSNAMED("something").
```

## Module and Action Group Queries

Retrieve all PartModules sharing a module identifier:

```
SET MyModList to SHIP:MODULESNAMED("something").
```

Get components assigned to specific action groups:

```
SET MyPartList to SHIP:PARTSINGROUP( AG1 ).
SET MyModList to SHIP:MODULESINGROUP( AG1 ).
```

## Part Tree Navigation

Access the primary root component:

```
SET firstPart to SHIP:ROOTPART.
```

Iterate through directly attached children:

```
SET firstPart to SHIP:ROOTPART.
FOR P IN firstPart:CHILDREN {
  print "The root part as an immediately attached part called " + P:NAME.
}.
```

Traverse upward using parent references:

```
IF thisPart:HASPARENT {
  print "This part's parent part is "+ thisPart:PARENT:NAME.
}.
```
