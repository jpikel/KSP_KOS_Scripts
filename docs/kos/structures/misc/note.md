> Source: https://ksp-kos.github.io/KOS/structures/misc/note.html (mirrored offline copy for local reference)

# Note - kOS 1.4.0.0 Documentation

## Overview

Notes are structures passed to the SKID chip to specify tone playback parameters. All Note suffixes are read-only and are set through constructor functions.

## Constructor Functions

### NOTE(frequency, duration, keyDownLength, volume)

Creates a note object with the specified parameters.

**Parameters:**
- `frequency` (Mandatory): Number (Hz) or string (letter notation)
- `duration` (Mandatory): Total time before next note, multiplied by voice TEMPO
- `keyDownLength` (Optional): Time before "synthesizer key" release (default: 90% of duration), multiplied by voice TEMPO
- `volume` (Optional): Relative volume multiplier (1.0 = voice default)

**Example:**
```
SET V1 TO GETVOICE(0).
V1:PLAY( NOTE(440, 0.2, 0.25, 1) ).
```

### SLIDENOTE(frequency, endFrequency, duration, keyDownLength, volume)

Creates a note that slides linearly from start to end frequency.

**Parameters:**
- `frequency` (Mandatory): Starting frequency (Hz or letter notation)
- `endFrequency` (Mandatory): Ending frequency (Hz or letter notation)
- `duration` (Mandatory): Total time (defaults to keyDownLength if omitted)
- `keyDownLength` (Optional): Key-down duration
- `volume` (Optional): Relative volume multiplier

**Example:**
```
SET V1 TO GETVOICE(0).
V1:PLAY( SLIDENOTE(300, 600, 0.2, 0.25, 1) ).
```

## Structure Members

| Suffix | Type | Description |
|--------|------|-------------|
| FREQUENCY | Scalar | Initial frequency in Hz |
| ENDFREQUENCY | Scalar | Final frequency in Hz |
| KEYDOWNLENGTH | Scalar | Time holding "synthesizer key" down |
| DURATION | Scalar | Total note duration |
| VOLUME | Scalar | Relative loudness multiplier |

## Attributes (Read-Only)

**Note:FREQUENCY**
- Initial frequency in hertz

**Note:ENDFREQUENCY**
- Final frequency (from SlideNote); identical to FREQUENCY otherwise

**Note:KEYDOWNLENGTH**
- Seconds the key is held (Attack + Decay + Sustain in ADSR Envelope)

**Note:DURATION**
- Total seconds including Release component

**Note:VOLUME**
- Loudness multiplier relative to other notes (values >1 may cause distortion)
</content>
