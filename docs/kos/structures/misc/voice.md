> Source: https://ksp-kos.github.io/KOS/structures/misc/voice.html (mirrored offline copy for local reference)

# Voice Structure Documentation

## Overview

The Voice structure represents a single voice in kOS's built-in SKID sound chip. For complete context, refer to the SKID chip documentation.

## Functions

### GETVOICE(num)
**Returns:** Voice

Accesses one of the SKID chip's voices using a zero-indexed number.

### STOPALLVOICES()
**Returns:** None

Halts all voices immediately, preventing queued notes from playing and stopping any currently playing notes.

## Structure Members

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| ATTACK | Scalar | Get/Set | Attack setting of ADSR Envelope (seconds) |
| DECAY | Scalar | Get/Set | Decay setting of ADSR Envelope (seconds) |
| SUSTAIN | Scalar | Get/Set | Sustain coefficient [0..1] for ADSR Envelope |
| RELEASE | Scalar | Get/Set | Release setting of ADSR Envelope (seconds) |
| VOLUME | Scalar | Get/Set | Peak volume for notes on this voice |
| WAVE | String | Get/Set | Waveform type (e.g., "triangle", "square", "sine") |
| PLAY(note_or_list) | — | Call | Plays a Note or List of Notes |
| STOP() | — | Call | Stops the currently playing notes |
| LOOP | Boolean | Get/Set | Whether to repeat the queued song |
| ISPLAYING | Boolean | Get/Set | Current playback status |
| TEMPO | Scalar | Get/Set | Duration scaling factor for notes |

## Detailed Attribute Descriptions

### Voice:ATTACK
**Type:** Scalar (seconds)

Determines the time for notes to reach peak volume in the envelope.

### Voice:DECAY
**Type:** Scalar (seconds)

Time for notes to drop from peak to sustain level.

### Voice:SUSTAIN
**Type:** Scalar [0..1]

Volume coefficient during the sustain phase (unlike other ADSR values, this is not time-based).

### Voice:RELEASE
**Type:** Scalar (seconds)

Time for notes to fade to silence after KeyDownLength expires. Requires notes with KeyDownLength shorter than Duration to take effect.

### Voice:VOLUME
**Type:** Scalar

Peak volume level. Values can exceed 1.0 depending on KSP UI volume settings. Setting to 0 silences the voice.

### Voice:WAVE
**Type:** String

Selects the waveform generator. Valid options include "triangle", "noise", "square", and others. Invalid strings are ignored.

### Voice:PLAY(note_or_list)
**Parameters:** Note or List of Notes
**Returns:** None

Queues audio for playback. Executes asynchronously, allowing the program to continue. Playing a single Note:

```
SET V0 to GetVoice(0).
V0:PLAY(NOTE(440,0.5)).
```

Playing a list of Notes:

```
SET V0 to GetVoice(0).
V0:PLAY(
    LIST(
        NOTE(440, 0.5),
        NOTE(400, 0.2),
        SLIDENOTE(410, 350, 0.3)
        )
    ).
```

**Key behaviors:**
- Returns immediately before the first note plays
- Calling PLAY() again on the same voice cancels previous playback
- Calling PLAY() on different voices does not interfere

### Voice:STOP()
**Returns:** None

Halts playback on this voice and discards queued notes.

### Voice:LOOP
**Type:** Boolean

When true, the voice continuously replays the queued song. A single Note counts as a one-note song for looping purposes.

### Voice:ISPLAYING
**Type:** Boolean

**Get:** Returns true if the voice is currently playing. With LOOP enabled, remains true until manually set to false.

**Set:** Setting to FALSE stops playback. Setting to TRUE has no effect.

### Voice:TEMPO
**Type:** Scalar

Scaling factor for note durations. Default is 1.0. Values less than 1.0 speed up playback; values greater than 1.0 slow it down. Changes take effect at the next note without requiring PLAY() to be called again.

**Important:** Tempo only affects Note KEYDOWNLENGTH and DURATION, not ADSR Envelope timings. Very fast tempos may cut off envelope effects.

## Example Song

```
brakes on.
set song to list().
song:add(note("b4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("g4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.5 , 0.45)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("a4", 0.5 , 0.45)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.5 , 0.45)).

song:add(note("b4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("g4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("b4", 0.25, 0.20)).
song:add(note("a4", 0.25, 0.20)).
song:add(note("g4", 1   , 0.95)).

set v0 to getvoice(0).

set v0:attack to 0.0333.
set v0:decay to 0.02.
set v0:sustain to 0.80.
set v0:release to 0.05.

for wavename in LIST("square", "triangle", "sawtooth", "sine") {
  set v0:wave to wavename.
  v0:play(song).
  print "Playing song in waveform : " + wavename.
  wait until not v0:isplaying.
  wait 1.
}
```
</content>
