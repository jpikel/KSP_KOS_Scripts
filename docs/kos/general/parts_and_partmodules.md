> Source: https://ksp-kos.github.io/KOS/general/parts_and_partmodules.html (mirrored offline copy for local reference)

# Ship Parts and PartModules — kOS 1.4.0.0 Documentation

## Overview

kOS enables access to part functionality and right-click context menus. Understanding the structure of parts in a vessel is essential for effective use.

In Kerbal Space Program, a Vessel consists of Parts arranged in a tree structure. kOS provides two primary methods for accessing parts.

## Tutorial

The documentation notes that tutorials are planned but not yet included (marked as "TODO").

## Parts

### Quick Reference

The recommended technique to remember is the `Part:PARTSDUBBED` method, as it covers most use cases effectively.

### Accessing Parts by Various Naming Systems

Any vessel variable supports these suffixes for querying parts by different naming schemes:

**Part Tag**: Custom names assigned via the name tag system. Recommended for clarity and control.

**Part Title**: The name displayed in the GUI interface visible to users.

**Part Name**: The internal KSP identifier used in part configuration files and saved games (not visible in normal GUI).

#### Query Methods

Given a vessel reference:

```
SET somevessel TO SHIP.
// Or:
SET somevessel TO VESSEL("some vessel's name").
// Or:
SET somevessel TO TARGET.
```

Query methods:

```
// PARTSTAGGED - finds all parts matching a nametag
SET partlist TO somevessel:PARTSTAGGED(nametag_of_part)

// PARTSTITLED - finds all parts matching a title
SET partlist TO somevessel:PARTSTITLED(title_of_part)

// PARTSNAMED - finds all parts matching a name
SET partlist TO somevessel:PARTSNAMED(name_of_part)

// PARTSDUBBED - finds parts matching any naming scheme
SET partlist TO somevessel:PARTSDUBBED(any_of_the_above)
```

All checks are case-insensitive. Each method returns a List of Parts (potentially multiple matches). Access individual parts using list indexing:

```
SET onePart TO somevessel:PARTSDUBBED("my favorite engine")[0].
```

Check if results exist:

```
IF somevessel:PARTSDUBBED("my favorite engine"):LENGTH = 0 {
  PRINT "There is no part named 'my favorite engine'.".
}.
```

#### Example Usage

```
// Change the altitude at which all the drogue chutes will deploy:
FOR somechute IN somevessel:PARTSNAMED("parachuteDrogue") {
  somechute:GETMODULE("ModuleParachute"):SETFIELD("DEPLOYALTITUDE", 1500).
}.
```

### Pattern Matching

Advanced selection uses pattern variants: `PARTSTAGGEDPATTERN`, `PARTSTITLEDPATTERN`, `PARTSNAMEDPATTERN`, and `PARTSDUBBEDPATTERN`. These enable regular expression matching for ultimate selection power.

### Accessing Parts as a Tree

Starting from the root part (`Vessel:ROOTPART`, `SHIP:ROOTPART`, `TARGET:ROOTPART`), access children with `Part:CHILDREN` and parents with `Part:PARENT`. Use `Part:HASPARENT` to detect root parts.

### Accessing Parts as a List

Use the `:PARTS` suffix or `LIST PARTS IN` command to get a flattened list (depth-first search from root). List indices depend on attachment order in the VAB.

### Shortcuts to Smaller Parts Lists

```
SET ves TO SHIP.
SET PLIST TO ves:PARTSNAMED("someNameHere").

SET ves TO SHIP.
SET PLIST TO ves:PARTSINGROUP(AG1).
```

## PartModules and the Right-Click Menu

Each Part contains PartModules—collections of variables and executable hooks that provide behaviors and properties. Without PartModules, parts are purely structural. kOS allows manipulation of anything KSP programmers have added to right-click menus or action groups.

### PartModules: Stock vs Mods

PartModules exist in stock KSP installations and both stock and modded parts use them. The distinction between "Mod" (modification) and "Mod" (module) should be clear: PartModules are a stock feature.

### PartModules and ModuleManager-like Behavior

Some mods add PartModules to every part in the game. The Deadly Reentry mod, for example, adds modules to all parts to track fragility. ModuleManager allows users to add PartModules to any part. Therefore, which PartModules exist depends on installed mods.

## What a PartModule Means to a kOS Script

Three interfaces exist between kOS scripts and PartModules.

### KSPFields

A KSPField is a single variable that a PartModule attaches to a part. Some are displayed in the RMB context menu. kOS can only access KSPFields visible in the RMB menu, respecting mod and stock game developers' design choices.

Access methods:

```
:GETFIELD("name of field").
:SETFIELD("name of field", new_value_for_field).
```

These are PartModule suffixes, not Part suffixes, because multiple PartModules on the same part might share field names.

### KSPEvents

A KSPEvent is a button in the RMB context menu with no associated value. Clicking executes software in the PartModule. Examples include "undock node" buttons on docking ports.

**Distinguishing KSPEvent from Boolean KSPField**: Both appear as buttons in the context menu. Button behavior differs: boolean fields stay pressed until clicked again; events pop in and immediately pop out.

Access method:

```
:DOEVENT("name of event").
```

This executes the event once.

### KSPActions

KSPActions differ from KSPEvents and KSPFields. Like KSPEvents, they execute software, but they don't appear in the RMB menu. Instead, KSPActions are available in the VAB/SPH action group editor. kOS allows access without prior action group assignment.

Access method:

```
:DOACTION("name of action", new_boolean_value).
```

The action name appears in the action group editor; the boolean value is True or False. Unlike KSPEvents, KSPActions have two states. For example, toggling brakes switches between on/off. `:DOACTION` specifies behavior as if the action group was just toggled, without actually assigning to action groups.

## Exploring Available Field/Event/Action Names

Discovering PartModule, field, event, and action names:

### What PartModules Exist on a Part?

**Method A: Use the part.cfg file**

All parts include a part.cfg file containing MODULE sections:

```
// Example snippet from a Part.cfg file:
MODULE
{
    name = ModuleCommand
```

This identifies PartModules but doesn't show runtime additions from ModuleManager.

**Method B: Use the :MODULES suffix**

```
FOR P IN SHIP:PARTS {
  LOG ("MODULES FOR PART NAMED " + P:NAME) TO MODLIST.
  LOG P:MODULES TO MODLIST.
}.
```

This dumps all module names to a file. Access modules via `Part:GETMODULE("module name")`.

### What Are the Names of PartModule Capabilities?

These suffixes reveal available capabilities:

```
SET MOD TO P:GETMODULE("some name here").
LOG ("These are all the things that I can currently USE GETFIELD AND SETFIELD ON IN " + MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLFIELDS TO NAMELIST.
LOG ("These are all the things that I can currently USE DOEVENT ON IN " + MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLEVENTS TO NAMELIST.
LOG ("These are all the things that I can currently USE DOACTION ON IN " + MOD:NAME + ":") TO NAMELIST.
LOG MOD:ALLACTIONS TO NAMELIST.
```

### BE WARNED! Names Can Dynamically Change

Some PartModules change field and event names during gameplay. For example:

```
SomeModule:DOEVENT("Activate").
```

After execution, the event might become "Deactivate," causing previous calls to fail. Monitor context menu changes and re-check `:ALLFIELDS`, `:ALLEVENTS`, and `:ALLACTIONS` periodically, as PartModules may update available options dynamically.
