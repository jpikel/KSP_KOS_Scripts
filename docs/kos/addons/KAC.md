> Source: https://ksp-kos.github.io/KOS/addons/KAC.html (mirrored offline copy for local reference)

# Kerbal Alarm Clock — kOS 1.4.0.0 Documentation

## Kerbal Alarm Clock

**Download:** https://github.com/TriggerAu/KerbalAlarmClock/releases

**Alternative download:** https://kerbalstuff.com/mod/231/Kerbal%20Alarm%20Clock

**Forum thread:** http://forum.kerbalspaceprogram.com/threads/24786

You can check if Kerbal Alarm Clock is available using `addons:available("KAC")`.

> "Note that due to changes in Kerbal Alarm Clock, kOS can no longer support versions of KAC that are older than 3.0.0.2."

The Kerbal Alarm Clock plugin enables creation of reminder alarms at future times to help manage flights and prevent warping past important events.

## Structure: KACAddon

Access via `ADDONS:KAC`.

| Suffix | Type | Description |
|--------|------|-------------|
| `AVAILABLE` | bool (readonly) | True if KAC is installed and integration enabled |
| `ALARMS()` | List | List all alarms |

### KACAddon:AVAILABLE

**Type:** bool  
**Access:** Get only

True if KAC is installed and integration enabled. Better to use `ADDONS:AVAILABLE("KAC")` first.

**Example:**
```
if ADDONS:KAC:AVAILABLE
{
    //some KAC dependent code
}
```

### KACAddon:ALARMS()

**Returns:** List of KACAlarm objects

Lists all alarms set up in Kerbal Alarm Clock.

**Example:**
```
for i in ADDONS:KAC:ALARMS
{
    print i:NAME + " - " + i:REMAINING + " - " + i:TYPE+ " - " + i:ACTION.
}
```

## Structure: KACAlarm

| Suffix | Type | Description |
|--------|------|-------------|
| `ID` | string (readonly) | Unique identifier |
| `NAME` | string | Name of the alarm |
| `ACTION` | string | What the alarm does when it fires |
| `TYPE` | string (readonly) | Type of alarm |
| `NOTES` | string | Long description (optional) |
| `REMAINING` | scalar (s) | Time remaining until alarm triggers |
| `REPEAT` | boolean | Should alarm repeat after firing |
| `REPEATPERIOD` | scalar (s) | Interval for repeated alarms |
| `ORIGINBODY` | string | Departing body name |
| `TARGETBODY` | string | Arrival body name |

### KACAlarm:ID

**Type:** string  
**Access:** Get only

Unique identifier of the alarm.

### KACAlarm:NAME

**Type:** string  
**Access:** Get/Set

Name of the alarm, displayed in main KAC window.

### KACAlarm:ACTION

**Type:** string  
**Access:** Get/Set

Should be one of:
- MessageOnly - Message Only (no warp affect)
- KillWarpOnly - Kill Warp Only (no message)
- KillWarp - Kill Warp and Message
- PauseGame - Pause Game and Message

Incorrect values log warnings and revert to previous or default value.

### KACAlarm:TYPE

**Type:** string  
**Access:** Get only

Can only be set at alarm creation. Possible values:
- Raw (default)
- Maneuver
- ManeuverAuto
- Apoapsis
- Periapsis
- AscendingNode
- DescendingNode
- LaunchRendevous
- Closest
- SOIChange
- SOIChangeAuto
- Transfer
- TransferModelled
- Distance
- Crew
- EarthTime

**Warning:** > "Unless you are 100% certain you know what you're doing, create only 'Raw' AlarmTypes to avoid unnecessary complications."

### KACAlarm:NOTES

**Type:** string  
**Access:** Get/Set

Long description of the alarm, visible when alarm pops or when double-clicked in UI.

**Warning:** > "This field may be reserved in the future version of KAC-KOS integration for automated script execution upon triggering of the alarm."

### KACAlarm:REMAINING

**Type:** scalar  
**Access:** Get only

Time remaining until alarm triggers.

### KACAlarm:REPEAT

**Type:** boolean  
**Access:** Get/Set

Should the alarm repeat once it fires.

### KACAlarm:REPEATPERIOD

**Type:** scalar  
**Access:** Get/Set

Duration after alarm fires before next alarm is set up.

### KACAlarm:ORIGINBODY

**Type:** string  
**Access:** Get/Set

Name of the body the vessel is departing from.

### KACAlarm:TARGETBODY

**Type:** string  
**Access:** Get/Set

Name of the body the vessel is arriving at.

## Available Functions

| Function | Description |
|----------|-------------|
| `ADDALARM(AlarmType, UT, Name, Notes)` | Create new alarm |
| `LISTALARMS(alarmType)` | List alarms with type |
| `DELETEALARM(alarmID)` | Delete alarm by ID |

### ADDALARM(AlarmType, UT, Name, Notes)

Creates alarm of specified type at UT with Name and Notes. Attaches alarm to current CPU Vessel. Returns KACAlarm object if successful, empty string otherwise.

**Example:**
```
set na to addAlarm("Raw",time:seconds+300, "Test", "Notes").
print na:NAME. //prints 'Test'
set na:NOTES to "New Description".
print na:NOTES. //prints 'New Description'
```

### LISTALARMS(alarmType)

If alarmType equals "All", returns list of all KACAlarm objects attached to current vessel or with no vessel attached. Otherwise returns list of KACAlarm objects with matching type attached to current vessel or with no vessel attached.

**Example:**
```
set al to listAlarms("All").
for i in al
{
    print i:ID + " - " + i:name.
}
```

### DELETEALARM(alarmID)

Deletes alarm with specified ID. Returns True if successful, false otherwise.

**Example:**
```
set na to addAlarm("Raw",time:seconds+300, "Test", "Notes").
if (DELETEALARM(na:ID))
{
    print "Alarm Deleted".
}
```
