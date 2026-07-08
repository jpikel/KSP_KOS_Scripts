> Source: https://ksp-kos.github.io/KOS/structures/misc/terminal.html (mirrored offline copy for local reference)

# Terminal — kOS 1.4.0.0 Documentation

## Terminal

The TERMINAL identifier provides access to special structure information about your screen.

## Structure

**structure** Terminal

### Members

| Suffix | Type | Get/Set | Description |
|--------|------|---------|-------------|
| `WIDTH` | Scalar | get and set | Terminal width in characters |
| `HEIGHT` | Scalar | get and set | Terminal height in characters |
| `REVERSE` | Boolean | get and set | Swap foreground/background colors |
| `VISUALBEEP` | Boolean | get and set | Convert beeps to silent visual flashes |
| `BRIGHTNESS` | Scalar | get and set | Brightness adjustment (0.0 to 1.0) |
| `CHARWIDTH` | Scalar | get | Character cell width in pixels (read-only) |
| `CHARHEIGHT` | Scalar | get and set | Character cell height in pixels |
| `INPUT` | TerminalInput | get | User input structure |

## Attribute Details

### Terminal:WIDTH

Returns the terminal width in character cells. Setting this value resizes the terminal. When multiple telnet clients connect to the same CPU, kOS attempts to keep all terminals synchronized. This setting varies per CPU part.

### Terminal:HEIGHT

Returns the terminal height in character cells. Setting this value resizes the terminal. Multiple telnet clients connected to the same CPU are kept synchronized when possible. This setting varies per CPU part.

### Terminal:REVERSE

Boolean property controlling color inversion. When true, foreground and background colors swap across the entire screen. This applies to both telnet and in-game GUI terminals and can be toggled via the GUI radio-button. Per-CPU-part setting.

### Terminal:VISUALBEEP

Boolean property converting beep characters into silent visual flashes (brief color inversion). Primarily affects the in-game GUI terminal, not telnet clients. Telnet terminals use local settings for visual feedback. This setting is per-CPU-part.

### Terminal:BRIGHTNESS

Ranges from 0.0 (minimum) to 1.0 (maximum). At zero, letters become completely hidden. Equivalent to the terminal GUI brightness slider.

### Terminal:CHARWIDTH

Read-only pixel width of character cells. This value changes only as a side-effect of adjusting `CHARHEIGHT`, since the font determines the aspect ratio.

### Terminal:CHARHEIGHT

Pixel height of character cells. Values are constrained to the range [4..24] and must be divisible by 2. Invalid values snap to the nearest allowed increment.

### Terminal:INPUT

Provides a TerminalInput structure for reading user input into the kOS terminal.
</content>
