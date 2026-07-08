> Source: https://ksp-kos.github.io/KOS/general/volumes.html (mirrored offline copy for local reference)

# Files and Volumes — kOS 1.4.0.0 Documentation

## Files and Volumes

The kOS system uses commands like COPYPATH, SWITCH, DELETEPATH, and RENAMEPATH to manipulate archive and volume storage. Understanding how kOS manages these systems is essential for effective file management.

### Script Files

Programs in kOS are stored as individual files within volumes. The terms "file" and "program" are largely interchangeable. Multiple files can exist on a single volume if space permits, though files cannot span across volumes. This means a volume's storage capacity effectively limits program size.

### File Storage Behind the Scenes

**In the Archive:**
Files stored on the Archive volume (volume zero) are saved as actual `.ks` text files on your computer in the `Ships/Script` directory. These can be edited directly with any text editor, and changes appear immediately to kOS.

*Historical note: Versions 0.14 and earlier used `Plugins/PluginData/Archive`.*

**In Other Volumes:**
Files on volumes other than Archive are stored within the saved game's persistence file, in the data section for the kOS part on the vessel.

### What is a Volume?

A Volume represents a single hard drive with limited storage capacity, simulating 1960s-1970s technology. For example, the CX-4181 Scriptable Control System part defaults to 1000 bytes of storage.

Storage capacity is measured by character count in source code. Using shorter variable names saves space, as does compiling programs to KSM files where variable names are stored once.

Different kOS computer parts have different default storage capacities, with better parts higher in the tech tree offering more space.

### Increasing Storage Space

The vehicle assembly building features a disk space slider allowing capacity increases at a cost in money and mass. Three multiplier options are available:

- 1x default size
- 2x default size  
- 4x default size

Higher multipliers increase mass cost. Disk size is locked after launch and cannot be changed during flight.

### Multiple Volumes on One Vessel

Each kOS CX-4181 part contains one volume. Multiple parts on the same craft are networked together, with each having its own volume. They are numbered 1, 2, 3, etc. by default, though they can be renamed.

One CPU can access another's volume using the SWITCH command. For example, CPU 1 could issue `SWITCH TO 2` to run code from volume 2.

### Naming Volumes

Volume numbering differs per CPU. The same volume might be called "2" from one CPU but "1" from another. Each CPU considers its own volume as number "1".

Use the SET command for consistent naming across multiple CPUs:

```
SET VOLUME("0"):NAME TO "newname".
```

### Volume Name Inherits from Tag Name

When a kOS processor core has a nametag set, the volume initially adopts that name. Characters not allowed in volume names are deleted, with spaces converted to underscores.

### Archive

The Archive is a special globally-consistent volume with unique properties:

- **Global consistency:** Same across all save games and the entire solar system
- **Infinite storage:** No byte limit, unlike vessel volumes
- **Persistence:** Files are retained when reverting flights, as the Archive is stored outside normal game saves
- **Editability:** Files use `.ks` extensions and can be edited directly in `Ships/Script`
- **Location:** Stored in the `Ships/Script` directory on your computer

Changes to Archive files are immediately visible to kOS and persist across reverts.

### Special Handling of Files in the "boot" Directory

For enhanced automation, custom boot scripts can be placed in the `boot` directory on the Archive volume. When at least one file exists there, you can select a boot script for your kOS CPU.

**Important:** The first time kOS runs without a `boot` directory, automatic migration is offered.

**Backwards compatibility note (v1.0.0+):** Older versions used filenames starting with "boot." The system now uses a `boot` directory but checks the root archive first, then strips "boot" or "boot_" prefixes for compatibility. Vessels in flight continue working with existing structures if `CONFIG:ARCH` is false; setting it to true requires boot files in the archive root.

**Boot Script Behavior:**
When a vessel reaches the launchpad (PRELAUNCH status), the assigned script copies to the CPU's local disk with the same name. The script runs immediately when the CPU boots or enters physics range.

**Considerations:**
- Limited CPU disk space means avoiding complex boot scripts or increasing disk space via ModuleManager config
- Boot scripts run immediately on initialization; avoid part/module interactions until physics fully load
- Wait a few seconds or until certain triggers before interacting with systems

**Possible Uses:**
- Automatically activate background/sleeper scripts triggered by conditions
- Create station-keeping scripts for orbit adjustments
- Configure multi-CPU vessels with cores dedicated to specific tasks
- Implement custom automation solutions

---

*© Copyright 2013-2021, kOS Team. Built with Sphinx.*
