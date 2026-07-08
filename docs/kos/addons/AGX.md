> Source: https://ksp-kos.github.io/KOS/addons/AGX.html (mirrored offline copy for local reference)

# Action Groups Extended

## Overview

"Increase the action groups available to kOS from 10 to 250. Also adds the ability to edit actions in flight as well as the ability to name action groups so you can describe what a group does."

**Download:** https://github.com/SirDiazo/AGExt/releases

**Forum thread:** http://forum.kerbalspaceprogram.com/threads/74195

## Usage

The mod extends kOS action groups from AG1-AG10 to AG11-AG250. These additional groups function identically to the stock groups.

## Script Trigger Action

Installing AGX adds a "Script Trigger" action to all kOS computer parts. This placeholder action enables:

- Naming action groups for code clarity
- Activating groups via mouse click
- Visual state feedback (Green=On, Red=Off, Yellow=Mixed state)

## Known Limitations

**For Action Groups 11-250 only:**

- On unfocused nearby vessels, unassigned action groups return False and cannot be set to True via commands. Assign the Script Trigger action as a workaround.
- RemoteTech integration is not officially supported (support pending internal mod changes).

## Action State Monitoring

State tracking occurs on a per-action basis rather than per-group:

- The Script Trigger action is recommended for kOS script interaction
- Part actions update automatically based on actual state
- Groups with mixed states (some actions on, some off) return False when queried
- Animations cause uncertain state until completion
- Visual feedback toggles group display color between gray, green, red, or yellow

## Example Code

```
AG15 on.
print AG15.

on AG15 {
  print "Action group 15 clicked!".
  preserve.
}
```

## Animation Delay Workaround

Add a cooldown timer to prevent multiple triggers during animations:

```
declare cooldownTimeAG15 to 0.
on AG15 {
  if cooldownTimeAG15 + 10 < time:seconds {
    print "Solar Panel Toggled!".
    set cooldownTimeAG15 to time.
  }
  preserve.
}
```

Set the cooldown value (10 seconds in this example) longer than your animation duration.
