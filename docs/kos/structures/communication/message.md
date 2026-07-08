> Source: https://ksp-kos.github.io/KOS/structures/communication/message.html (mirrored offline copy for local reference)

# Message Structure Documentation

## Overview

The `Message` structure represents a single message stored in a CPU's or vessel's `MessageQueue`. It contains the sender's intended content along with metadata automatically added by kOS.

Messages are serializable and can be forwarded between processors:

```
SET CPU2 TO PROCESSOR("cpu2").
CPU2:CONNECTION:SENDMESSAGE(SHIP:MESSAGES:POP).
```

## Structure Definition

| Suffix | Type | Description |
|--------|------|-------------|
| `SENTAT` | `TimeStamp` | Date this message was sent at |
| `RECEIVEDAT` | `TimeStamp` | Date this message was received at |
| `SENDER` | `Vessel` or `Boolean` | Vessel which sent this message, or false if sender no longer exists |
| `HASSENDER` | `Boolean` | Tests whether the sender vessel still exists |
| `CONTENT` | `Structure` | Message content |

**Note:** This type is serializable.

## Attributes

### Message:SENTAT
**Type:** `TimeStamp`

The timestamp indicating when this message was sent.

### Message:RECEIVEDAT
**Type:** `TimeStamp`

The timestamp indicating when this message was received.

### Message:SENDER
**Type:** `Vessel` or `Boolean`

Returns the vessel that sent the message. However, if the sender vessel no longer exists (due to destruction, recovery, or docking), this returns `false` instead. Use `:ISTYPE` or `HASSENDER` to verify the actual type.

### Message:HASSENDER
**Type:** `Boolean`

Since delays can occur between sending and processing, the sender vessel might no longer exist. This suffix confirms whether the sender remains valid. When `false`, the `SENDER` suffix returns a `Boolean` false rather than a `Vessel` object.

### Message:CONTENT
**Type:** `Structure`

Contains the actual message payload sent by the originating processor.
