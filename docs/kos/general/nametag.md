> Source: https://ksp-kos.github.io/KOS/general/nametag.html (mirrored offline copy for local reference)

# The Name Tag System — kOS 1.4.0.0 Documentation

## The Name Tag System

![Name Tag System Image](../_images/nametag.png)

The Name Tag system enables you to assign custom names to vessel components, allowing you to retrieve them without depending on KSP's default naming conventions or the complex part tree structure. This feature lets you give any part an arbitrary name of your choosing.

### Giving a Part a Name

1. Right-click any part in either the editor (VAB/SPH) or during flight. While naming during craft design is recommended, you can also do it mid-flight for testing purposes.

2. Select the "change name tag" button. A text input popup will appear where you can enter a custom name (for example, "the big tank").

3. Subsequently, retrieve this part using either the `:PARTSDUBBED` or `:PARTSTAGGED` methods on the vessel, as documented in the Vessel Page.

### Cloning with Symmetry

When you name a part in the editor before removing and re-placing it with symmetry enabled, all symmetrical copies automatically inherit the same nametag. Multiple parts can share identical nametags—this is intentional behavior. The `:PARTSTAGGED` and `:PARTSDUBBED` methods will then return lists containing multiple parts.

To assign unique nametags to each symmetrical part, modify their names individually after placement.

### Where is it saved?

Nametags added during editor sessions (VAB or SPH) are saved within the craft file itself. Every new launch of that vessel design preserves the nametag configuration.

However, nametags applied after launch exist only on that specific vessel instance. The persistence file stores these names, but the editor's craft design file does not. Other instances of the same design lack these names.

### Examples of Using the Name

```
// Only if you expected to get
// exactly 1 such part, no more, no less.
SET myPart TO SHIP:PARTSDUBBED("my nametag here")[0].

// OR

// Only if you expected to get
// exactly 1 such part, no more, no less.
SET myPart TO SHIP:PARTSTAGGED("my nametag here")[0].

// Handling the case of more than
// one part with the same nametag,
// or the case of zero parts with
// the name:
SET allSuchParts TO SHIP:PARTSDUBBED("my nametag here").

// OR

SET allSuchParts TO SHIP:PARTSTAGGED("my nametag here").

// Followed by using the list returned:
FOR onePart IN allSuchParts {
  // do something with onePart here.
}
```

Additional details are available in the Parts and PartModules section.
