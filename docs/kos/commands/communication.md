> Source: https://ksp-kos.github.io/KOS/commands/communication.html (mirrored offline copy for local reference)

# Communication — kOS 1.4.0.0 Documentation

## Overview

kOS enables inter-processor communication (IPC) within the same vessel and inter-vessel communication across different spacecraft through a message-based system.

## Limitations

Messages can be sent to unloaded vessels, but the receiving vessel must be loaded to process and respond. Vessel loading depends on proximity to the active vessel and current situation. For replies from unloaded vessels, set the target as the active vessel or adjust load distance settings via the `LOADDISTANCE` structure.

## Messages

The fundamental communication unit is a [`Message`](../structures/communication/message.html#structure:MESSAGE "MESSAGE structure"). Messages support primitive data types and serializable objects.

kOS automatically appends three attributes to every message:
- `Message:SENTAT` – transmission timestamp
- `Message:RECEIVEDAT` – receipt timestamp
- `Message:SENDER` – sender identification

Access original data via `Message:CONTENT`.

## Message Queues

Received messages populate a [`MessageQueue`](../structures/communication/message_queue.html#structure:MESSAGEQUEUE "MESSAGEQUEUE structure"), storing them in received order.

**Key distinction:** Each CPU has its own queue, AND each vessel maintains a separate queue. A vessel with 2 processors has 3 total queues (one per CPU, one vessel-wide). This design prevents senders from needing processor name knowledge.

**Persistence difference:** Vessel queues persist across scene changes (saved to game files), while CPU queues do not. This enables long-distance inter-vessel communication despite scene reloading.

## Connections

A [`Connection`](../structures/communication/connection.html#structure:CONNECTION "CONNECTION structure") represents communicative capability with a processor or vessel. Obtain connections before sending messages.

## Inter-Vessel Communication

### Sending Messages

Obtain a vessel reference, then access its connection:

```
SET MESSAGE TO "HELLO".
SET C TO VESSEL("probe"):CONNECTION.
PRINT "Delay is " + C:DELAY + " seconds".
IF C:SENDMESSAGE(MESSAGE) {
  PRINT "Message sent!".
}
```

### Receiving Messages

Access the vessel's queue via `SHIP:MESSAGES`:

```
WHEN NOT SHIP:MESSAGES:EMPTY {
  SET RECEIVED TO SHIP:MESSAGES:POP.
  PRINT "Sent by " + RECEIVED:SENDER:NAME + " at " + RECEIVED:SENTAT.
  PRINT RECEIVED:CONTENT.
}
```

## Inter-Processor Communication

### Accessing Processors

**Function:** `PROCESSOR(volumeOrNameTag)`

**Parameters:**
- `volumeOrNameTag` – ([`Volume`](../structures/volumes_and_files/volume.html#structure:VOLUME "VOLUME structure") | String) – accepts a Volume instance or processor name tag string

Retrieve all processors:

```
LIST PROCESSORS IN ALL_PROCESSORS.
PRINT ALL_PROCESSORS[0]:NAME.
```

Access processors directly as parts/modules:

```
PRINT SHIP:MODULESNAMED("kOSProcessor")[0]:VOLUME:NAME.
```

### Sending and Receiving Messages

**Sender code:**

```
SET MESSAGE TO "undock".
SET P TO PROCESSOR("probe").
IF P:CONNECTION:SENDMESSAGE(MESSAGE) {
  PRINT "Message sent!".
}
```

**Receiver code:**

```
WAIT UNTIL NOT CORE:MESSAGES:EMPTY.
SET RECEIVED TO CORE:MESSAGES:POP.
IF RECEIVED:CONTENT = "undock" {
  PRINT "Undocking!!!".
  UNDOCK().
} ELSE {
  PRINT "Unexpected message: " + RECEIVED:CONTENT.
}
```

## Connectivity Managers

*Available since v1.0.2*

Select connectivity managers via KSP's Difficulty Settings. kOS supports multiple implementations based on installed mods.

### Available Managers

**PermitAllConnectivityManager**
Allows all connections unconditionally. Equivalent to disabling connectivity restrictions.

**CommNetConnectivityManager**
Uses KSP's stock CommNet system (requires CommNet enabled).

*Note:* CommNet has limitations updating non-active vessel connections. Include relay antennas on one or both vessels to ensure updates. Debris vessels loaded as "debris" cannot establish CommNet connections regardless of antennas.

**RemoteTechConnectivityManager**
Uses RemoteTech mod (requires installation). Access advanced features via the RemoteTech Addon.

### Global Connection Variables

**`HOMECONNECTION`**

Returns a [`Connection`](../structures/communication/connection.html#structure:CONNECTION "CONNECTION structure") to the network "home" node (KSC or other ground stations). Determines archive volume accessibility. Sending messages to this connection produces an error.

**`CONTROLCONNECTION`**

Returns a [`Connection`](../structures/communication/connection.html#structure:CONNECTION "CONNECTION structure") to the control source (crewed pod, control station, or home). Indicates terminal input availability and potential signal delay. Sending messages to this connection produces an error.

---

**Warning:** Running multiple connectivity systems simultaneously may cause unexpected behaviors. Enable only the corresponding system for your selected connectivity manager.
