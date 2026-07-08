> Source: https://ksp-kos.github.io/KOS/structures/misc/config.html (mirrored offline copy for local reference)

# Configuration of kOS - Markdown Reproduction

## Configuration of kOS

The `Config` structure is a special kOS component that enables kerboscript programs to access and modify the kOS plugin's configuration settings. Some values are stored globally in an external file, while save-game-specific values reside within the save file itself.

### Storage and Migration

Prior to version v1.0.2, all settings were stored in a single external configuration file. KSP 1.2.0 introduced save-file-based storage, and most settings were migrated to this system. If an old config file exists alongside a new save, users receive a dialog offering migration options.

The config file location is: `[KSP Directory]/GameData/kOS/Plugins/PluginData/kOS/`

### Configuration Members

All members listed below are gettable and settable:

| Suffix | Type | Default | Description |
|--------|------|---------|-------------|
| `IPU` | Scalar (integer) | 150 | Instructions per update |
| `UCP` | Boolean | False | Use compressed persistence |
| `STAT` | Boolean | False | Print statistics to screen |
| `ARCH` | Boolean | False | Start on archive (instead of volume 1) |
| `OBEYHIDEUI` | Boolean | True | Obey the KSP Hide user interface key (F2) |
| `SAFE` | Boolean | False | Enable safe mode |
| `CLOBBERBUILTINS` | Boolean | False | Allow masking built-in identifiers with user identifiers |
| `AUDIOERR` | Boolean | False | Enable sound effect on kOS error |
| `VERBOSE` | Boolean | False | Enable verbose exceptions |
| `SUPPRESSAUTOPILOT` | Boolean | False | If true, kOS controls do nothing |
| `TELNET` | Boolean | False | Activate the telnet server |
| `TPORT` | Scalar (integer) | 5410 | Port for telnet server |
| `IPADDRESS` | String | "127.0.0.1" | IP address for telnet server |
| `BRIGHTNESS` | Scalar | 0.7 (range [0.0 .. 1.0]) | Default terminal brightness |
| `DEFAULTFONTSIZE` | Scalar | 12 (range [6 .. 20]) | Default font size in pixels |
| `DEFAULTWIDTH` | Scalar | 50 (range [15 .. 255]) | Default terminal width in characters |
| `DEFAULTHEIGHT` | Scalar | 36 (range [3 .. 160]) | Default terminal height in characters |
| `DEBUGEACHOPCODE` | Boolean | False | Debug spam for kOS developers |

### Config:IPU

**Access:** Get/Set  
**Type:** Scalar integer, range [50, 2000]

Sets the `InstructionsPerUpdate` value, determining how many kRISC pseudo-machine-language instructions each CPU executes per physics update tick. The value is constrained to remain within [50..2000] and will reset if set outside this range.

### Config:UCP

**Access:** Get/Set  
**Type:** Boolean

Controls `useCompressedPersistence`. When enabled, kOS local volume files stored in the save file use compression, reducing space but making the data unreadable in plain text.

### Config:STAT

**Access:** Get/Set  
**Type:** Boolean

Controls `showStatistics`. When true, program execution logs speed statistics to the screen and enables the `ProfileResult()` function for deep program analysis.

### Config:ARCH

**Access:** Get/Set  
**Type:** Boolean

Controls `startOnArchive`. When true, vessels loaded on the launchpad or runway default to volume 0 (archive) instead of volume 1 (local drive).

### Config:OBEYHIDEUI

**Access:** Get/Set  
**Type:** Boolean

Controls `obeyHideUI`. When true, kOS terminals hide when KSP's Hide UI key (F2 by default) is toggled.

### Config:SAFE

**Access:** Get/Set  
**Type:** Boolean

Enables `enableSafeMode`. When true, the following errors trigger immediately:
- "Tried to push NaN into the stack"
- "Tried to push Infinity into the stack"

These errors occur when mathematical operations produce non-real numbers (division by zero, square root of negative numbers, etc.). When false, such operations are permitted, but unsafe results may freeze KSP if passed to KSP's API routines.

### Config:CLOBBERBUILTINS

**Access:** Get/Set  
**Type:** Boolean

Permits scripts to mask built-in identifier names. In kOS v1.4.0.0, the compiler enforces rules preventing user variables, locks, or functions from clashing with kOS built-ins. Setting this to TRUE re-enables older behavior for backward compatibility.

This can be overridden per-file using the `@CLOBBERBUILTINS` compiler directive. The recommended approach is editing scripts to rename conflicting identifiers rather than enabling this setting.

### Config:AUDIOERR

**Access:** Get/Set  
**Type:** Boolean

Controls `audibleExceptions`. When true, kOS errors generate a warning bleep sound effect, useful when flying hands-off to alert that an autopilot script has failed.

### Config:VERBOSE

**Access:** Get/Set  
**Type:** Boolean

Controls `verboseExceptions`. When true, error messages are lengthy and detailed, explaining every aspect of the problem.

### Config:SUPPRESSAUTOPILOT

**Access:** Get/Set  
**Type:** Boolean

When set to true, all kOS steering, throttle, and translation control overrides are suppressed, leaving manual control entirely intact. This enables emergency manual takeover without terminating the running program.

This setting can be bound to an action group as "Toggle Suppress," "Suppress On," or "Suppress Off" on kOS core parts. It does not suppress action groups or staging.

### Config:TELNET

**Access:** Get/Set  
**Type:** Boolean  
**GLOBAL SETTING**

Controls `EnableTelnet`. When true, activates the kOS telnet server allowing external terminal programs (Putty, Xterm) to connect. Changes take effect immediately.

To restart the server after changing related settings:

```
SET CONFIG:TELNET TO FALSE.
WAIT 0.5.
SET CONFIG:TELNET TO TRUE.
```

### Config:TPORT

**Access:** Get/Set  
**Type:** Scalar (integer)  
**GLOBAL SETTING**

Sets the `TelnetPort`. Changes the TCP/IP port the kOS telnet server listens on. Requires server restart to take effect (as described above).

### Config:IPADDRESS

**Access:** Get/Set  
**Type:** String  
**GLOBAL SETTING**

Sets the `TelnetIPAddrString`. Specifies the IP address the telnet server uses when enabled. Defaults to "127.0.0.1" (loopback). Must be set to the computer's actual IP address for remote connections. Requires server restart to take effect.

### Config:BRIGHTNESS

**Access:** Get/Set  
**Type:** Scalar, range [0, 1]

Sets the default starting brightness for new kOS in-game terminals. Individual terminals can override this by setting `Terminal:BRIGHTNESS` or adjusting the brightness slider. Values range from 0 (invisible) to 1 (maximum brightness).

### Config:DEFAULTFONTSIZE

**Access:** Get/Set  
**Type:** Scalar (integer-only), range [6, 20]

Sets the `TerminalFontDefaultSize` for newly created terminals (height in pixels). Individual terminals can override this via `Terminal:CHARHEIGHT` or font adjustment buttons. Values are rounded to the nearest integer.

### Config:DEFAULTWIDTH

**Access:** Get/Set  
**Type:** Scalar (integer-only), range [15, 255]

Sets the `TerminalDefaultWidth` in character cells for newly created terminals. Individual terminals can override this via `Terminal:WIDTH` or by dragging the resize corner.

### Config:DEFAULTHEIGHT

**Access:** Get/Set  
**Type:** Scalar (integer-only), range [3, 160]

Sets the `TerminalDefaultHeight` in character cells for newly created terminals. Individual terminals can override this via `Terminal:HEIGHT` or by dragging the resize corner.

### Config:DEBUGEACHOPCODE

**Access:** Get/Set  
**Type:** Boolean

Controls `debugEachOpcode`. **NOTE: This makes the game VERY slow; use with caution.**

When true, each CPU opcode execution generates an entry in the KSP log. This debugging tool is intended for kOS developers familiar with the system's internal workings. Changes take effect immediately.
</content>
