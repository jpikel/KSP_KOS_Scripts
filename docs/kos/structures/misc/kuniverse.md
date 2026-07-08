> Source: https://ksp-kos.github.io/KOS/structures/misc/kuniverse.html (mirrored offline copy for local reference)

# KUniverse 4th Wall Methods — kOS 1.4.0.0 Documentation

## Structure: KUniverse

The `KUniverse` structure provides access to functions that break the "4th wall," allowing Kerboscript programs to interact directly with the KSP game itself rather than just the in-game world (vessels, planets, orbits, etc.).

## Attributes and Methods

| Suffix | Type | Get/Set | Description |
|--------|------|---------|-------------|
| `CANREVERT` | Boolean | Get | Is any revert possible? |
| `CANREVERTTOLAUNCH` | Boolean | Get | Is revert to launch possible? |
| `CANREVERTTOEDITOR` | Boolean | Get | Is revert to editor possible? |
| `REVERTTOLAUNCH` | None | Method | Invoke revert to launch |
| `REVERTTOEDITOR` | None | Method | Invoke revert to editor |
| `REVERTTO(name)` | String | Method | Invoke revert to the named editor |
| `ORIGINEDITOR` | String | Get | Returns "SPH" or "VAB" |
| `PAUSE` | None | Method | Pauses KSP, bringing up the Escape Menu |
| `CANQUICKSAVE` | Boolean | Get | Returns true if quicksave is enabled |
| `QUICKSAVE()` | None | Method | Invoke KSP's quicksave |
| `QUICKLOAD()` | None | Method | Invoke KSP's quickload |
| `QUICKSAVETO(name)` | String | Method | Quicksave to named save file |
| `QUICKLOADFROM(name)` | None | Method | Quickload from named save file |
| `QUICKSAVELIST` | List of String | Get | List of all quicksave files |
| `HOURSPERDAY` | Scalar | Get | Number of hours per day (6 or 24) |
| `DEBUGLOG(message)` | None | Method | Append string to Unity debug log |
| `DEFAULTLOADDISTANCE` | LoadDistance | Get | Default load and pack distances |
| `TIMEWARP` | TimeWarp | Get | Manipulate time warp features |
| `ACTIVEVESSEL` | Vessel | Get/Set | Returns or sets the active vessel |
| `FORCESETACTIVEVESSEL(vessel)` | None | Method | Force switch active vessels |
| `FORCEACTIVE(vessel)` | None | Method | Same as FORCESETACTIVEVESSEL |
| `GETCRAFT(name, editor)` | CraftTemplate | Method | Get craft file by name and editor |
| `LAUNCHCRAFT(template)` | None | Method | Launch craft at default site |
| `LAUNCHCRAFTFROM(template, site)` | None | Method | Launch craft at specified site |
| `LAUNCHCRAFTWITHCREWFROM(template, crewlist, site)` | None | Method | Launch craft with crew manifest |
| `CRAFTLIST()` | List of CraftTemplate | Method | List all craft templates |
| `REALTIME` | Scalar | Get only | Real world timestamp in seconds since 1970 |

## Detailed Attribute and Method Descriptions

### KUniverse:CANREVERT

**Access:** Get  
**Type:** Boolean

Returns true if either revert to launch or revert to editor is available. Note that either option may still be unavailable; use specific methods below to check exact options.

### KUniverse:CANREVERTTOLAUNCH

**Access:** Get  
**Type:** Boolean

Returns true if revert to launch is available.

### KUniverse:CANREVERTTOEDITOR

**Access:** Get  
**Type:** Boolean

Returns true if revert to editor is available. This tends to be false after reloading from a saved game where the vessel already existed in the saved file when loaded.

### KUniverse:REVERTTOLAUNCH()

**Access:** Method  
**Return type:** None

Initiates KSP's revert to launch function. All progress is lost, and the vessel returns to the launch pad or runway at initial launch time.

### KUniverse:REVERTTOEDITOR()

**Access:** Method  
**Return type:** None

Initiates KSP's revert to editor function. The game reverts to the editor based on vessel type.

### KUniverse:REVERTTO(editor)

**Parameters:**
- **editor** – The editor identifier

**Returns:** None

Reverts to the provided editor. Valid inputs are "VAB" and "SPH".

### KUniverse:ORIGINEDITOR

**Access:** Get  
**Type:** String

Returns the name of the originating editor based on vessel type:
- "SPH" for space plane hangar
- "VAB" for vehicle assembly building
- "" (empty string) when the vehicle cannot remember its editor (when CANREVERTTOEDITOR is false)

### KUniverse:PAUSE()

**Access:** Method  
**Return type:** None

Pauses Kerbal Space Program, bringing up the same pause menu that appears when pressing the Escape key.

**Warning:** No lines of Kerboscript code can run while the game is paused. If you call this, your script stops until a human being clicks "resume" on the pause menu.

kOS is designed to thematically act like a computer inside the game universe, so it stops when the game clock stops. Until a human resumes the game, your script remains stuck. This makes it impossible to have the program run code that decides when to un-pause. Once the Resume button is clicked, the program continues where it left off.

Note: Using Control-C in the terminal to kill the program will work while the game is paused. If your script keeps re-pausing repeatedly, Control-C can break out of this problem.

### KUniverse:CANQUICKSAVE

**Access:** Get  
**Type:** Boolean

Returns true if KSP's quicksave feature is enabled and available.

### KUniverse:QUICKSAVE()

**Access:** Method  
**Return type:** None

Initiates KSP's quicksave function. The game saves the current state to the default quicksave file.

### KUniverse:QUICKLOAD()

**Access:** Method  
**Return type:** None

Initiates KSP's quickload function. The game loads from the default quickload file.

### KUniverse:QUICKSAVETO(name)

**Parameters:**
- **name** – The name of the save file

**Returns:** None

Initiates KSP's quicksave function. The game saves the current state to a quicksave file matching the name parameter.

### KUniverse:QUICKLOADFROM(name)

**Parameters:**
- **name** – The name of the save file

**Returns:** None

Initiates KSP's quickload function. The game loads from the quicksave file matching the name parameter.

### KUniverse:QUICKSAVELIST

**Access:** Get  
**Type:** List of String

Returns a list of names of all quicksave files in the KSP game.

### KUniverse:DEFAULTLOADDISTANCE

**Access:** Get  
**Type:** LoadDistance

Gets or sets the default loading distances for vessels loaded in the future. Note: This setting does not affect vessels currently in the universe for the current flight session. It takes effect the next time you enter a flight scene from the editor or tracking station, even on vessels that already existed beforehand. Loading a new scene causes all vessels to inherit these new default values.

(To affect values on a vessel already existing in the current scene, use the LOADDISTANCE suffix of the Vessel structure.)

### KUniverse:TIMEWARP

**Access:** Get  
**Type:** TimeWarp

Returns the TimeWarp structure that you can use to manipulate Kerbal Space Program's time warping features. See the TimeWarp documentation for more details.

Example: `set kuniverse:timewarp:rate to 50.`

### KUniverse:ACTIVEVESSEL

**Access:** Get/Set  
**Type:** Vessel

Returns the active vessel object and allows you to set the active vessel. Note: KSP will not allow you to change vessels by default when the current active vessel is in the atmosphere or under acceleration. Use `FORCEACTIVE` under those circumstances.

### KUniverse:FORCESETACTIVEVESSEL(vessel)

**Parameters:**
- **vessel** – Vessel to switch to

**Returns:** None

Forces KSP to change the active vessel to the one specified. Note: Switching the active vessel under conditions that KSP normally disallows may cause unexpected results on the initial vessel. It is possible that the vessel will be treated as if it is re-entering the atmosphere and deleted.

### KUniverse:FORCEACTIVE(vessel)

**Parameters:**
- **vessel** – Vessel to switch to

**Returns:** None

Same as `FORCESETACTIVEVESSEL`.

### KUniverse:HOURSPERDAY

**Access:** Get  
**Type:** Scalar (integer)

Has the value of either 6 or 24, depending on the setting you used on Kerbal Space Program's main settings screen for whether to think in terms of Kerbal days (6 hours) or Kerbin days (24 hours). This only affects how the clock format looks and doesn't change the actual time in game, which is stored purely as seconds since epoch.

(For example, if 25 hours pass in the game, it merely tracks that 39000 seconds have passed. It doesn't care how that translates into minutes, hours, days, and years until showing it on screen.)

This setting also affects how values from TimeSpan and TimeStamp calculate the `:hours`, `:days`, and `:years` suffixes.

Note: This setting is not settable. This decision was made because the main stock KSP game only changes the setting on the main settings menu, which isn't accessible during play. It's possible for kOS to support changing the value mid-game, but it was deliberately avoided because other mods may read the setting once up front and assume it never changes.

### KUniverse:GETCRAFT(name, editor)

**Parameters:**
- **name** – String craft name
- **facility** – String editor name

**Returns:** CraftTemplate

Returns the CraftTemplate matching the given craft name saved from the given editor. Valid values for editor include `"VAB"` and `"SPH"`.

### KUniverse:LAUNCHCRAFT(template)

**Parameters:**
- **template** – CraftTemplate craft template object

**Returns:** None

Launches a new instance of the given CraftTemplate from the template's default launch site.

**NOTE:** The craft is launched with the KSP default crew assignment, as if you had clicked launch from the editor without manually adjusting the crew.

**NOTE:** Due to how KSP handles launching a new craft, this ends the current program even if the currently active vessel is located within physics range of the launch site.

### KUniverse:LAUNCHCRAFTFROM(template, site)

**Parameters:**
- **template** – CraftTemplate craft template object
- **site** – String launch site name

**Returns:** None

Launches a new instance of the given CraftTemplate from the given launch site. Valid values for site include `"RUNWAY"` and `"LAUNCHPAD"`.

**NOTE:** The craft is launched with the KSP default crew assignment, as if you had clicked launch from the editor without manually adjusting the crew. To pick which crew are on the craft, use `LAUNCHCRAFTWITHCREWFROM()` instead.

**NOTE:** Due to how KSP handles launching a new craft, this ends the current program even if the currently active vessel is located within physics range of the launch site.

### KUniverse:LAUNCHCRAFTWITHCREWFROM(template, crewlist, site)

**Parameters:**
- **template** – CraftTemplate craft template object
- **crewlist** – List of String kerbal names
- **site** – String launch site name

**Returns:** None

Launches a new instance of the given CraftTemplate with the given crew manifest from the given launch site. Valid values for site include `"RUNWAY"` and `"LAUNCHPAD"`.

If any of the kerbal names used in the `crewlist` parameter don't exist in the game, there is no error. Instead, that name is ignored in the list.

**NOTE:** Due to how KSP handles launching a new craft, this ends the current program even if the currently active vessel is located within physics range of the launch site.

### KUniverse:CRAFTLIST()

**Returns:** List of CraftTemplate

Returns a list of all CraftTemplate templates stored in the VAB and SPH folders of the stock Ships folder and the save-specific Ships folder.

### KUniverse:DEBUGLOG(message)

**Parameters:**
- **message** – String message to append to the log

**Returns:** None

All Unity games (including Kerbal Space Program) have a standard "log" file where verbose messages help developers debug their games. Sometimes it may be useful to make your script log a message to that debug file, instead of using kOS's normal `Log` function.

This is useful when working with a kOS developer to trace the cause of a problem and you want your script to mark the moments when it hit different parts of the program, embedding those messages in the log interleaved with the game's own diagnostic messages.

Example:

```
kuniverse:debuglog("=== Now starting test ===").
kuniverse:debuglog("--- Locking steering to up----").
lock steering to up.
kuniverse:debuglog("--- Now forcing a physics tick ----").
wait 0.001.
kuniverse:debuglog("--- Now unlocking steering again ----").
unlock steering.
wait 0.001.
kuniverse:debuglog("=== Now done with test ===").
```

This causes the messages to appear in the debug log, interleaved with any error messages from kOS and other parts of Kerbal Space Program.

The location of this log varies depending on platform:

- Windows 32-bit: `[install_dir]\KSP_Data\output_log.txt`
- Windows 64-bit: `[install_dir]\KSP_x64_Data\output_log.txt` (not officially supported)
- Mac OS X: `~/Library/Logs/Unity/Player.log`
- Linux: `~/.config/unity3d/Squad/"Kerbal Space Program"/Player.log`

For example, this code:

```
kuniverse:debuglog("this is my message").
```

Results in this in the KSP output log:

```
kOS: (KUNIVERSE:DEBUGLOG) this is my message
```

### KUniverse:REALTIME

**Access:** Get Only  
**Type:** Scalar

Returns the current time in the real world (outside the game). It uses the "UNIX time" convention—the number of seconds since the start of 1970, right at midnight, 1st January.

### KUniverse:REALWORLDTIME

**Access:** Get Only  
**Type:** Scalar

An alias for `KUniverse:REALTIME`.

## Examples

### Switch to an active vessel called "vessel 2":

```
SET KUNIVERSE:ACTIVEVESSEL TO VESSEL("vessel 2").
```

### Revert to VAB, but only if allowed:

```
PRINT "ATTEMPTING TO REVERT TO THE Vehicle Assembly Building."
IF KUNIVERSE:CANREVERTTOEDITOR {
  IF KUNIVERSE:ORIGINEDITOR = "VAB" {
    PRINT "REVERTING TO VAB.".
    KUNIVERSE:REVERTTOEDITOR().
  } ELSE {
    PRINT "COULD REVERT, But only to space plane hanger, so I won't.".
  }
} ELSE {
  PRINT "Cannot revert to any editor.".
}
```
</content>
