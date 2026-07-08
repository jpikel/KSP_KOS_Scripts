> Source: https://ksp-kos.github.io/KOS/general/skid.html (mirrored offline copy for local reference)

# Using the Sound/Kerbal Interface Device (SKID)

## Overview

The SKID (Sound/Kerbal Interface Device) is an integrated chip included in all kOS CPUs that enables audio playback through terminal speakers. This feature allows programs to generate and play sounds while continuing execution.

## Quick Example

```
SET V0 TO GETVOICE(0).
V0:PLAY( NOTE(400, 2.5) ).
PRINT "The note is still playing".
PRINT "when this prints out.".
```

## Hardware Capabilities

### Voices

The SKID chip provides 10 simultaneous voices (numbered 0-9), each functioning as an independent sound channel with customizable instrument properties.

### Frequency Range

The chip produces sounds from 1 Hz to 14,000 Hz, covering the full range of an 88-key piano with some additional range.

### Amplitude Control

Volume levels range from 0.0 to 1.0, with optional amplification beyond 1.0 for signal boosting.

### Waveforms

Five waveform types are available:

- **SQUARE**: Electronic, "beep"-like sound (default)
- **TRIANGLE**: Balanced between electronic and mellow
- **SAWTOOTH**: Rasping, wasp-like quality
- **SINE**: Mellow, smooth tone
- **NOISE**: Random static effect

### ADSR Envelope

The SKID chip implements Attack, Decay, Sustain, Release (ADSR) envelope control to simulate natural instrument characteristics:

- **Attack**: Time to reach full volume (seconds)
- **Decay**: Time to drop from peak to sustain level (seconds)
- **Sustain**: Volume multiplier during sustained note (0.0-1.0)
- **Release**: Time to fade to silence (seconds)

Default settings:
- Attack = 0.0s
- Decay = 0.0s
- Sustain = 1.0
- Release = 0.1s

### Letter Frequency Notation

Notes can be specified using musical notation:

Format: `[Note][Accidental][Octave]`

- Note letter: C, D, E, F, G, A, B, or R (rest)
- Accidental: # (sharp) or b (flat), optional
- Octave: 0-7 (4 = middle octave)

Examples: "C4" (middle C), "C#4" (C-sharp), "Db4" (D-flat, equivalent to C#4)

### Note Format

Notes contain these parameters:

**Frequency**: Initial pitch in Hz or letter notation (0 = rest)

**EndFrequency**: Optional target frequency for slide notes

**Duration**: Total note length in seconds (affected by tempo)

**KeyDownLength**: "Key held down" time within Duration (Attack + Decay + Sustain phases)

**Volume**: Multiplier between 0.0 and 1.0+

### Tempo

A multiplier coefficient adjusts all duration values. Setting tempo to 0.5 plays notes twice as fast; 2.0 plays them twice as slow.

### Songs

Multiple notes can be provided as a list for sequential playback without further CPU intervention. The chip plays notes in order, waiting for each to complete before starting the next.

### Looping

A flag enables continuous playback, repeating the song indefinitely.

### Chords

To play simultaneous notes (chords), dedicate multiple voices to the same song, with rests in positions where individual notes should play, and coordinated notes where chords occur.

## Kerboscript Interface

### GetVoice()

Returns a handle to a specific voice (0-9):

```
SET V0 to GetVoice(0).
```

### Voice Object

Configure voice properties via suffixes:

```
SET V0:VOLUME TO 0.9.
SET V0:WAVE to "sawtooth".
SET V0:ATTACK to 0.1.
SET V0:DECAY to 0.2.
SET V0:SUSTAIN to 0.7.
SET V0:RELEASE to 0.5.
```

### Note()

Create a single note:

```
SET N1 to NOTE("A4", 0.8, 1).
```

Or use `SLIDENOTE()` for frequency transitions:

```
SET N2 to SLIDENOTE("A4", "A5", 0.25, 0.3).
```

### Voice:Play()

Execute note playback with a single note or list:

```
SET V0 TO GetVoice(0).
V0:PLAY( NOTE( 440, 1) ).

V0:PLAY(
    LIST(
        NOTE("A#4", 0.2,  0.25),
        NOTE("A4",  0.2,  0.25),
        NOTE("R",   0.2,  0.25),
        SLIDENOTE("C5", "F5", 0.45, 0.5),
        NOTE("R",   0.2,  0.25)
    )
).
```
