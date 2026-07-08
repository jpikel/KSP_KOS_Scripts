> Source: https://ksp-kos.github.io/KOS/addons/Trajectories.html (mirrored offline copy for local reference)

# Trajectories

## Overview

The Trajectories addon integrates with the KSP Trajectories mod, which displays trajectory predictions accounting for atmospheric drag, lift, and other factors. The kOS implementation accesses this mod through C# reflection.

**Key Links:**
- Download: https://github.com/neuoy/KSPTrajectories/releases
- Forum: https://forum.kerbalspaceprogram.com/index.php?/topic/162324-131-110/

## Important Notes

- Trajectories only predicts trajectories for the active vessel (camera-focused)
- Several suffixes will throw exceptions if called from inactive vessels or when no impact position is calculated
- Always check `HASIMPACT` before accessing impact-related suffixes
- Predictions are based on current vessel orientation; orientation changes alter predictions
- Accuracy is not guaranteed

### Example Usage

```
if ADDONS:TR:AVAILABLE {
    if ADDONS:TR:HASIMPACT {
        PRINT ADDONS:TR:IMPACTPOS.
    } else {
        PRINT "Impact position is not available".
    }
} else {
    PRINT "Trajectories is not available.".
}
```

## Version Compatibility

The kOS Trajectories addon supports both Trajectories 1.x and 2.x versions for backward compatibility. Version-specific suffixes are noted in the reference table below.

---

## TRAddon Structure

Access via `ADDONS:TR`

### Attributes and Methods Reference

| Suffix | Type | Description |
|--------|------|-------------|
| `AVAILABLE` | Boolean (readonly) | True if compatible Trajectories version installed |
| `GETVERSION` | String (readonly) | Trajectories version string |
| `GETVERSIONMAJOR` | Scalar (readonly) | Major version number |
| `GETVERSIONMINOR` | Scalar (readonly) | Minor version number |
| `GETVERSIONPATCH` | Scalar (readonly) | Patch version number |
| `ISVERTWO` | Boolean (readonly) | True if version ≥ 2.0.0 |
| `ISVERTWOTWO` | Boolean (readonly) | True if version ≥ 2.2.0 |
| `ISVERTWOFOUR` | Boolean (readonly) | True if version ≥ 2.4.0 |
| `HASIMPACT` | Boolean (readonly) | True if impact position calculated |
| `IMPACTPOS` | GeoCoordinates (readonly) | Predicted impact position |
| `TIMETILLIMPACT` | Scalar (readonly) | Seconds until impact (TR 2.2.0+) |
| `RESETDESCENTPROFILE(AoA)` | None | Reset descent profile nodes (TR 2.4.0+) |
| `DESCENTANGLES` | List (get/set) | Descent profile AoA values in degrees (TR 2.4.0+) |
| `DESCENTGRADES` | List (get/set) | Descent profile grades: True=Retrograde, False=Prograde (TR 2.4.0+) |
| `DESCENTMODES` | List (get/set) | Descent profile modes: True=AoA, False=Horizon (TR 2.4.0+) |
| `PROGRADE` | Boolean (get/set) | All descent profile nodes in prograde mode (TR 2.2.0+) |
| `RETROGRADE` | Boolean (get/set) | All descent profile nodes in retrograde mode (TR 2.2.0+) |
| `PLANNEDVEC` | Vector (readonly) | Direction vessel should face for predicted trajectory |
| `PLANNEDVECTOR` | Vector (readonly) | Alias for `PLANNEDVEC` |
| `SETTARGET(position)` | None | Set target landing position |
| `HASTARGET` | Boolean (readonly) | True if target position set (TR 2.0.0+) |
| `GETTARGET` | GeoCoordinates (readonly) | Get target position (TR 2.4.0+) |
| `CLEARTARGET()` | None | Clear target position (TR 2.4.0+) |
| `CORRECTEDVEC` | Vector (readonly) | Offset to correct trajectory for target impact |
| `CORRECTEDVECTOR` | Vector (readonly) | Alias for `CORRECTEDVEC` |

### Detailed Attribute Descriptions

**GETVERSION, GETVERSIONMAJOR, GETVERSIONMINOR, GETVERSIONPATCH**

Note: Version detection has limitations for pre-2.2.0 releases:
- Pre-2.0.0: Returns empty string, major=0, minor/patch=0
- 2.0.0-2.1.x: Returns "2.0.0", major=2, minor/patch=0
- 2.2.0+: Returns accurate version information

For version checking, use the boolean suffixes (`ISVERTWO`, `ISVERTWOTWO`, `ISVERTWOFOUR`) instead.

**PLANNEDVEC**

Provides a unit vector pointing the direction the vessel should face to follow the predicted trajectory, based on the angle of attack selected in the Trajectories descent profile.

**CORRECTEDVEC**

Applies an offset to `PLANNEDVEC` to correct the predicted trajectory toward the selected target. This is a simplistic representation without aerodynamic prediction, provided only as a unit vector with no magnitude information about target distance. It helps determine if pitching nose up or down is needed. Accuracy not guaranteed.

**RESETDESCENTPROFILE(AoA)**

Resets all descent profile nodes to the specified angle of attack (in degrees). Automatically sets Retrograde if AoA > 90°, otherwise sets Prograde.

**DESCENTANGLES, DESCENTGRADES, DESCENTMODES**

These list-type suffixes manage descent profile configuration with four entries: atmospheric entry, high altitude, low altitude, and final approach.

---

**Example Repository:** A landing script using this addon is available at https://github.com/CalebJ2/kOS-landing-script
