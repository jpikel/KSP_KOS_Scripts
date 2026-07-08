> Source: https://ksp-kos.github.io/KOS/general/boot.html (mirrored offline copy for local reference)

# Boot Files Documentation Summary

## Overview
The kOS boot system allows automatic loading and execution of kerboscript files when a computer boots. The documentation explains setup procedures, file locations, and timing considerations.

## Key Setup Steps

1. **File Placement**: Store `.ks` files in `[KSP Folder]/Ships/Script/boot/`
2. **Selection in VAB/SPH**: Right-click the kOS computer part and use the slider to select your boot file
3. **Launch**: When the vessel launches, the boot file copies to local storage and executes

## Example Boot Script
```
wait until ship:unpacked.
clearscreen.
print "Hello. I am the boot file.".
print "If you see this, that proves the boot file ran.".
```

## Boot File Selection Methods

**VAB/SPH Method**: Files appear in a dropdown menu when right-clicking a kOS part. Files must be present before entering the editor—newly added files require re-entering the editor to appear.

**Script Method**: Use `set core:bootfilename to "filename"` to change the boot file. The file must already exist on the local drive (not archive) and cannot use drive indicators like "0:" or "1:".

## When Boot Files Execute

Boot files run when:
- The computer powers on after shutdown
- Electric charge is restored
- The scene reloads
- The vessel first launches to launchpad/runway
- The `REBOOT` command executes

## Critical Consideration: ship:unpacked

The vessel loads before fully "unpacking," meaning throttle, staging, and steering commands may not work immediately. It's recommended to start boot scripts with:

```
wait until ship:unpacked.
```

This prevents commands from executing without effect during the packed state.

## Launch Sequence Details

When spawning from VAB/SPH, kOS:
1. Creates a `boot/` folder on local volume
2. Copies the boot file from archive to local storage
3. Saves the game (enabling "revert to launch")
4. Executes the boot file

Importantly, reverting to launch doesn't re-copy edited boot files—you must re-launch from the editor or manually update the file.
