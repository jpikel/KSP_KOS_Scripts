> Source: https://ksp-kos.github.io/KOS/structures/vessels/part.html (mirrored offline copy for local reference)

# Part Structure Documentation - kOS 1.4.0.0

## Overview

The Part structure represents generic properties available on every part in KOS. You can obtain a list of Part values using the LIST PARTS command.

## Members Reference Table

| Suffix | Type | Description |
|--------|------|-------------|
| NAME | String | Name of this part (internal identifier) |
| TITLE | String | Title as it appears in KSP GUI |
| MASS | Scalar | Current mass of part and its resources |
| DRYMASS | Scalar | Mass of part if all resources were empty |
| WETMASS | Scalar | Mass of part if all resources were full |
| TAG | String | Name-tag if assigned by the player |
| CONTROLFROM | None | Call to control-from to this part |
| STAGE | Scalar | The stage this is associated with |
| CID | String | Craft-Unique identifying number of this part |
| UID | String | Universe-Unique identifying number of this part |
| ROTATION | Direction | The rotation of this part's X-axis |
| POSITION | Vector | The location of this part in the universe |
| FACING | Direction | The direction that this part is facing |
| BOUNDS | Bounds | Bounding-box information about this part's shape |
| RESOURCES | List | List of Resource in this part |
| TARGETABLE | Boolean | True if this part can be selected as a target |
| SHIP | Vessel | The vessel that contains this part |
| GETMODULE(name) | PartModule | Get a PartModule by name |
| GETMODULEBYINDEX(index) | PartModule | Get a PartModule by index |
| MODULES | List | Names of all PartModules |
| ALLMODULES | List | Same as MODULES |
| HASMODULE(name) | Boolean | True if the part has the named module |
| PARENT | Part | Adjacent Part on this Vessel |
| HASPARENT | Boolean | Check if this part has a parent Part |
| DECOUPLER | Decoupler or String | The decoupler/separator for this part |
| SEPARATOR | Decoupler or String | Alias name for DECOUPLER |
| DECOUPLEDIN | Scalar | The stage number where this part will decouple (-1 if cannot) |
| SEPARATEDIN | Scalar | Alias name for DECOUPLEDIN |
| HASPHYSICS | Boolean | Does this part have mass or drag |
| CHILDREN | List | List of attached Parts |
| SYMMETRYCOUNT | Scalar | How many parts in this part's symmetry set |
| REMOVESYMMETRY | None | Like the "Remove From Symmetry" button |
| SYMMETRYPARTNER(index) | Part | Return one of the other parts symmetrical to this one |
| PARTSNAMED(name) | List of Part | Search the branch from here down based on name |
| PARTSNAMEDPATTERN(pattern) | List of Part | Regex search the branch from here down based on name |
| PARTSTITLED(name) | List of Part | Search the branch from here down for parts titled this |
| PARTSTITLEDPATTERN(pattern) | List of Part | Regex search the branch from here down for parts titled this |
| PARTSTAGGED(tag) | List of Part | Search the branch from here down for parts tagged this |
| PARTSTAGGEDPATTERN(pattern) | List of Part | Regex search the branch from here down for parts tagged this |
| PARTSDUBBED(name) | List of Part | Search the branch from here down for parts named, titled, or tagged this |
| PARTSDUBBEDPATTERN(name) | List of Part | Regex search for parts named, titled, or tagged this |
| MODULESNAMED(name) | List of PartModule | Search the branch from here down for modules named this |
| ALLTAGGEDPARTS | List of Part | Search the branch from here down for all parts with a non-blank tag name |

## Detailed Attribute Descriptions

### Part:NAME

**Access:** Get only  
**Type:** String

The internal name used behind the scenes in the game's API code. Never appears in normal GUI but is used in Part.cfg files, saved game persistence files, and ModuleManager mod.

### Part:TITLE

**Access:** Get only  
**Type:** String

The title of the part as it appears on-screen in the GUI interface.

### Part:TAG

**Access:** Get / Set  
**Type:** String

The custom name-tag value that may exist on this part if given via the name-tag system. This naming convention allows creating custom names for parts in scripts.

**WARNING:** Only settable for parts attached to the CPU Vessel.

### Part:CONTROLFROM()

**Access:** Callable function only  
**Return type:** None

Causes the game to perform the same action as right-clicking a part and selecting "control from here." This rotates the control orientation so fore/aft/left/right/up/down match the part's orientation. Only works for parts KSP allows this for (control cores and docking ports). Accepts no arguments and returns no value.

**Warning:** Only callable for parts attached to the CPU Vessel.

### Part:STAGE

**Access:** Get only  
**Type:** Scalar

The stage this part is associated with.

### Part:CID

**Access:** Get only  
**Type:** String

Craft ID. Unique per craft design. If you launch two copies of the same design without editing, the same part in both copies will have the same CID. This value is kept in the craft file.

### Part:UID

**Access:** Get only  
**Type:** String

Universal ID. All parts have a unique ID number that never changes, stored in persistent.sfs. Comparing parts directly is recommended when possible.

### Part:ROTATION

**Access:** Get only  
**Type:** Direction

The rotation of this part's X-axis, which points out of its side. The FACING suffix is usually preferred.

### Part:POSITION

**Access:** Get only  
**Type:** Vector

The location of this part in the universe, expressed in the same frame of reference as other positions in kOS.

### Part:FACING

**Access:** Get only  
**Type:** Direction

The direction this part is facing, which is also the rotation that would transform a vector from a coordinate space oriented to match the part, to one oriented to match world ship-raw coordinates.

### Part:BOUNDS

**Access:** Get only  
**Type:** Bounds

Constructs a bounding box structure indicating the extents of the part's shape (width, length, height).

Can be expensive in CPU time to keep calling repeatedly. If examining a part's bounds multiple times in a loop where the shape won't change, call this suffix once and store the result.

### Part:MASS

**Access:** Get only  
**Type:** Scalar

The current mass of the part and its resources. Always 0 for parts with no physics.

### Part:WETMASS

**Access:** Get only  
**Type:** Scalar

The mass of the part if all resources were full. Always 0 for parts with no physics.

### Part:DRYMASS

**Access:** Get only  
**Type:** Scalar

The mass of the part if all resources were empty. Always 0 for parts with no physics.

### Part:RESOURCES

**Access:** Get only  
**Type:** List

List of Resource objects in this part.

### Part:TARGETABLE

**Access:** Get only  
**Type:** Boolean

True if this part can be selected by KSP as a target.

**Example:**

```
LIST PARTS FROM TARGET IN tParts.

PRINT "The target vessel has a".
PRINT "partcount of " + tParts:LENGTH.

SET totTargetable to 0.
FOR part in tParts {
    IF part:TARGETABLE {
        SET totTargetable TO totTargetable + 1.
    }
}

PRINT "...and " + totTargetable.
PRINT " of them are targetable parts.".
```

### Part:SHIP

**Access:** Get only  
**Type:** Vessel

The vessel that contains this part.

### Part:GETMODULE(name)

**Parameters:**
- **name** (String): Name of the part module

**Returns:** PartModule

Get one of the PartModules attached to this part by module name. See Part:MODULES for available names.

### Part:GETMODULEBYINDEX(index)

**Parameters:**
- **index** (Scalar): Index number of the part module

**Returns:** PartModule

Get one of the PartModules attached to this part by index number. Indexes are not guaranteed to be in the same order. It is recommended to iterate with a loop and verify the module name:

```
local moduleNames is part:modules.
for idx in range(0, moduleNames:length) {
    if moduleNames[idx] = "test module" {
        local pm is part:getmodulebyindex(idx).
        DoSomething(pm).
    }
}
```

### Part:MODULES

**Access:** Get only  
**Type:** List of strings

List of the names of PartModules enabled for this part.

### Part:ALLMODULES

Same as Part:MODULES.

### Part:HASMODULE(name)

**Parameters:**
- **name** (String): The name of the module to check for

**Returns:** Boolean

Checks if this part contains the PartModule with the given name. Returns true if it exists, false otherwise. If HASMODULE returns false, GETMODULE would fail.

### Part:PARENT

**Access:** Get only  
**Type:** Part

When walking the tree of parts, this is the part that this part is attached to on the way "up" toward the root part.

### Part:HASPARENT

**Access:** Get only  
**Type:** Boolean

When walking the tree of parts, this is true if there is a parent part to this part, and false if this part has no parent (only the root part).

### Part:DECOUPLER

**Access:** Get only  
**Type:** Decoupler or String

The decoupler/separator that will decouple this part when activated. Returns None if no such part exists.

### Part:SEPARATOR

**Access:** Get only  
**Type:** Decoupler or String

Alias name for DECOUPLER.

### Part:DECOUPLEDIN

**Access:** Get only  
**Type:** Scalar

The stage number where this part will be decoupled. Returns -1 if the part cannot be decoupled.

### Part:SEPARATEDIN

**Access:** Get only  
**Type:** Scalar

Alias name for DECOUPLEDIN.

### Part:HASPHYSICS

**Access:** Get only  
**Type:** Boolean

Comes from a part's configuration and is an artifact of the KSP simulation. Indicates if the part has mass or drag.

### Part:CHILDREN

**Access:** Get only  
**Type:** List of Parts

When walking the tree of parts, this is all the parts attached as children of this part. Returns an empty list when this part is a "leaf" of the parts tree.

### Part:SYMMETRYCOUNT

**Access:** Get only  
**Type:** Scalar

Returns how many parts are in the same symmetry set as this part. All parts return a minimum of 1 (itself).

### Part:SYMMETRYTYPE

**Access:** Get only  
**Type:** Scalar

Tells you the type of symmetry this part has:
- 0 = Radial symmetry
- 1 = Mirror symmetry

Unclear what this means for 1x symmetry.

### Part:REMOVESYMMETRY()

**Access:** Method  
**Returns:** Nothing

Removes this part from its symmetry group, reverting it to a symmetry group of 1x (itself). Same as pressing the "Remove From Symmetry" button. Once removed, there is no way to restore the part to its symmetry group.

### Part:SYMMETRYPARTNER(index)

**Parameters:**
- **name** (Scalar): Index of which part in the symmetry group

**Returns:** Part

When a set of parts has been placed with symmetry in the Vehicle Assembly Building or Space Plane Hangar, this method finds all parts in the same symmetrical group.

The index is numbered from 0 to SYMMETRYCOUNT minus 1.

The zero-th symmetry partner is this part itself. Even parts placed without symmetry are in a symmetry group of 1 part.

The index wraps around in a cycle, so with 4 parts in symmetry, SYMMETRYPARTNER(0), SYMMETRYPARTNER(4), and SYMMETRYPARTNER(8) are the same part.

**Example:**

```
// Print the symmetry group a part is inside:
function print_sym {
  parameter a_part.

  print a_part + " is in a " + a_part:SYMMETRYCOUNT + "x symmetry set.".

  if a_part:SYMMETRYCOUNT = 1 {
    return. // no point in printing the list when its not in a group.
  }

  if a_part:SYMMETRYTYPE = 0 {
    print "  The symmetry is radial.".
  } else if a_part:SYMMETRYTYPE = 1 {
    print "  The symmetry is mirror.".
  } else {
    print "  The symmetry is some other weird kind that".
    print "  didn't exist back when this example was written.".
  }

  print "    The Symmetry Group is: ".
  for i in range (0, a_part:SYMMETRYCOUNT) {
    print "      [" + i + "] " + a_part:SYMMETRYPARTNER(i).
  }
}
```

### Part:PARTSNAMED(name)

**Parameters:**
- **name** (String): Name of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSNAMED(name) except searches only the branch of the vessel's part tree from the current part down through its children and their children.

### Part:PARTSNAMEDPATTERN(namePattern)

**Parameters:**
- **namePattern** (String): Pattern of the name of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSNAMEDPATTERN(namePattern) except searches only the branch from the current part down.

### Part:PARTSTITLED(title)

**Parameters:**
- **title** (String): Title of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSTITLED(title) except searches only the branch from the current part down.

### Part:PARTSTITLEDPATTERN(titlePattern)

**Parameters:**
- **titlePattern** (String): Pattern of the title of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSTITLEDPATTERN(titlePattern) except searches only the branch from the current part down.

### Part:PARTSTAGGED(tag)

**Parameters:**
- **tag** (String): Tag of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSTAGGED(tag) except searches only the branch from the current part down.

### Part:PARTSTAGGEDPATTERN(tagPattern)

**Parameters:**
- **tagPattern** (String): Pattern of the tag of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSTAGGEDPATTERN(tagPattern) except searches only the branch from the current part down.

### Part:PARTSDUBBED(name)

**Parameters:**
- **name** (String): Name, title, or tag of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSDUBBED(name) except searches only the branch from the current part down.

### Part:PARTSDUBBEDPATTERN(namePattern)

**Parameters:**
- **namePattern** (String): Pattern of the name, title, or tag of the parts

**Returns:** List of Part objects

Same as Vessel:PARTSDUBBEDPATTERN(namePattern) except searches only the branch from the current part down.

### Part:MODULESNAMED(name)

**Parameters:**
- **name** (String): Name of the part modules

**Returns:** List of PartModule objects

Same as Vessel:MODULESNAMED(name) except searches only the branch from the current part down.

### Part:ALLTAGGEDPARTS()

**Returns:** List of Part objects

Same as Vessel:ALLTAGGEDPARTS() except searches only the branch from the current part down for all parts with a non-blank tag name.
