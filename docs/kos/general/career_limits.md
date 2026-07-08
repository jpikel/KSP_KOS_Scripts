> Source: https://ksp-kos.github.io/KOS/general/career_limits.html (mirrored offline copy for local reference)

# Career Limits — kOS 1.4.0.0 Documentation

## Overview

According to the documentation, "The theme of KSP's 'career mode' is that some features of your space program don't work until after you've made some upgrades." kOS enforces these career mode restrictions.

## Rules Being Enforced

### Stock KSP Rules
- Tracking center upgrades limit visibility of future orbit patches
- Mission control and tracking center upgrades gate maneuver node creation

### kOS-Specific Rules
- VAB or SPH upgrades to custom action group level required for PartModule:DOACTION method
- Editor building upgrades (VAB/SPH) needed to add nametags to parts in editor

## Career Structure

You can query career limitations via the `Career()` global object:

```
print Career():PATCHLIMIT.
print Career():CANDOACTIONS.
```

### Career Members Table

| Suffix | Type | Get | Set |
|--------|------|-----|-----|
| CANTRACKOBJECTS | Boolean | yes | no |
| PATCHLIMIT | scalar | yes | no |
| CANMAKENODES | Boolean | yes | no |
| CANDOACTIONS | Boolean | yes | no |

### Detailed Attributes

**CANTRACKOBJECTS**: Returns true if your tracking center permits tracking unnamed objects (asteroids, etc.).

**PATCHLIMIT**: Returns a number greater than zero if patched conics predictions are available. The value indicates how many patches beyond the current one you can view.

**CANMAKENODES**: Returns true if both tracking center and mission control buildings are upgraded sufficiently to allow maneuver node creation.

**CANDOACTIONS**: Returns true if VAB or SPH upgrades permit custom action groups, enabling the PartModule:DOACTION method.
