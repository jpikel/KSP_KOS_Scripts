> Source: https://ksp-kos.github.io/KOS/structures/vessels/element.html (mirrored offline copy for local reference)

# Element

An element represents "a _docked component_ of a [`Vessel`](vessel.html#structure:VESSEL "VESSEL structure")." When multiple vessels dock together, you can access the individual original vessel components—called elements—that comprise the larger docked structure.

## Retrieving Elements

To obtain a list of elements from a vessel:

```
list elements in eList.
// now eList is a list of elements from the vessel.
```

## Important Note

"Element boundries are not formed between two docking ports that were launched coupled. a craft with such an arrangement will appear as one element until you uncoupled the nodes and redocked"

## Structure: Element

| Suffix | Type | Description |
|--------|------|-------------|
| `NAME` | String | The name of the docked craft |
| `UID` | String | Unique Identifier |
| `PARTS` | List | all Parts |
| `DOCKINGPORTS` | List | all DockingPorts |
| `VESSEL` | Vessel | the parent Vessel |
| `RESOURCES` | List | all AggregateResources |

### Element:UID
- **Type:** String
- **Access:** Get only
- A unique id

### Element:NAME
- **Type:** String
- **Access:** Get/Set
- The name of the Element, derived from the original vessel before docking. Cannot be set to an empty String.

### Element:PARTS
- **Type:** List of Part objects
- **Access:** Get only
- A List of all the parts on the Element. `SET FOO TO SHIP:PARTS.` has the same effect as `LIST PARTS IN FOO.`

### Element:DOCKINGPORTS
- **Type:** List of DockingPort objects
- **Access:** Get only
- A List of all the docking ports on the Element.

### Element:VESSEL
- **Type:** Vessel
- **Access:** Get only
- The parent vessel containing the element.

### Element:RESOURCES
- **Type:** List of AggregateResource objects
- **Access:** Get only
- A List of all the AggregateResources on the element.
