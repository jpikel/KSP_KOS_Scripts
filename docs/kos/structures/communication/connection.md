> Source: https://ksp-kos.github.io/KOS/structures/communication/connection.html (mirrored offline copy for local reference)

# Connection — kOS 1.4.0.0 Documentation

## Overview

Connections enable communication between processors within the same vessel or between different vessels. They determine whether communication is currently possible and facilitate message transmission.

## Obtaining a Connection

**Intra-vessel communication** (between processors on the same vessel):
```
SET MY_PROCESSOR TO PROCESSOR("second").
SET MY_CONNECTION TO MY_PROCESSOR:CONNECTION.
```

**Inter-vessel communication**:
```
SET MY_VESSEL TO VESSEL("dunarover").
SET MY_CONNECTION TO MY_VESSEL:CONNECTION.
```

## Structure: Connection

| Suffix | Type | Description |
|--------|------|-------------|
| `ISCONNECTED` | Boolean | True if connection is currently opened |
| `DELAY` | Scalar | Delay in seconds |
| `DESTINATION` | Vessel or kOSProcessor | Target of this connection |
| `SENDMESSAGE(message)` | Boolean | Sends a message via this connection |

### Connection:ISCONNECTED

**Type:** Boolean

Returns `true` if the connection is open and messages can be sent.

**For CPU connections:** True when destination CPU is on the same vessel; false otherwise.

**For vessel connections:**
- **PermitAll**: Always returns true
- **Stock CommNet**: Follows CommNet rules for connection paths
- **RemoteTech**: Follows RemoteTech rules for connection paths

> Note: Debris-type vessels never appear in the CommNet communications network, so `ISCONNECTED` will always be false for debris.

> Important: Connection status may return false for 1-2 seconds after scene load, even when correct. Boot scripts should include a brief wait at startup for accurate results.

### Connection:DELAY

**Type:** Scalar

Returns the number of seconds for messages to arrive, or -1 if connection is closed.

**For CPU connections:** Always 0 for same-vessel communication; -1 otherwise.

**For vessel connections:**
- **PermitAll**: Always 0 (instant delivery)
- **Stock CommNet**: Always 0 (no signal delay imposed)
- **RemoteTech**: Reports RemoteTech's signal delay based on radio transmission speed

### Connection:DESTINATION

**Type:** Vessel or kOSProcessor

Returns the destination of this connection (either a vessel or processor).

### Connection:SENDMESSAGE(message)

**Parameters:**
- `message` – Structure (any serializable structure, String, Scalar, or Boolean)

**Returns:** Boolean (true if message sent successfully)

Transmits a message through this connection. Returns false if the message fails to send. This method requires `Connection:ISCONNECTED` to be true.

> Note: The connection must be open only at the moment of sending. Loss of connection afterward does not affect message delivery.
