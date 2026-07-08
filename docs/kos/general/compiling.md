> Source: https://ksp-kos.github.io/KOS/general/compiling.html (mirrored offline copy for local reference)

# KerboScript Machine Code — kOS 1.4.0.0 Documentation

## Overview

KerboScript programs are compiled into machine language opcodes during execution. The `COMPILE` command allows you to explicitly save this compiled form as a KSM (KerboScript Machine code) file for later use.

## Compiling to a KSM File

### Background

When scripts run, kOS transforms them into "machine language" opcodes—tiny instructions that execute efficiently. This transformation process is called "compiling." The `RUN` and `RUNPATH` commands perform this silently, while the `COMPILE` command does so explicitly and saves the result.

**Important Note:** Compiling pauses execution similar to a wait command. Mainline compilation pauses mainline code but allows triggers to continue; trigger compilation pauses everything. The universe continues updating during compilation, so physical properties like mass, position, and velocity may change.

### The COMPILE Keyword

```
COMPILE sourcePath [TO destinationPath]
```

**Parameters:**
- `sourcePath` — Path to source script file (String or bare word)
- `destinationPath` — Optional path to compiled output file (String or bare word)

This command transforms a script from text into encoded, compressed machine language opcodes and saves them to a file.

## Why Use KSM Files?

Compiled machine code files are often smaller than source scripts because they exclude comments and whitespace—only readable to humans, not required for execution. This saves storage space on remote probes.

## How to Use KSM Files

Example workflow: compile three programs, copy them to a probe, and run them:

```
SWITCH TO ARCHIVE.

COMPILE "myprog1.ks" to "myprog1.ksm".
COPYPATH( "0:/myprog1.ksm", "1:/" ).

COMPILE "myprog2".
COPYPATH( "0:/myprog2.ksm", "1:/" ).

COMPILE "myprog3".
COPYPATH( "0:/myprog3.ksm", "1:/" ).

SWITCH TO 1.
RUNPATH("myprog1", 1, 2, "hello").
```

When omitting the destination, the system assumes conversion from `.ks` to `.ksm`.

## Default File Naming Conventions

You can explicitly specify file types:
```
RUNPATH("myprog1.ks").
RUNPATH("myprog1.ksm").
```

Or omit the extension:
```
RUNPATH("myprog1").
```

When no extension is specified, `RUN` first attempts to execute the `.ksm` file, then falls back to the `.ks` file. This allows existing scripts to work unchanged.

## Downsides to Using KSM Files

1. **Error reporting limitations** — Error messages show line numbers but cannot display the actual code lines
2. **Editor incompatibility** — KSM files cannot be viewed in the in-game editor; viewing requires a hex editor
3. **Size considerations** — KSM files aren't always smaller; smaller scripts may result in larger compiled files due to overhead

## Additional Resources

For technical details on the KSM file format, see the internal documentation at the kOS GitHub repository (CompiledObject-doc.md).
