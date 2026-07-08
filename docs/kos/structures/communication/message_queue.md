> Source: https://ksp-kos.github.io/KOS/structures/communication/message_queue.html (mirrored offline copy for local reference)

# MessageQueue

Just like ordinary queues, message queues operate on a "First-In first-out" principle. Additional information about queues is available on Wikipedia.

When you send a message to a CPU or vessel, it gets added to the end of that recipient's message queue. The recipient can then read those messages from the queue.

## Accessing message queues

You can access the current processor's message queue using `CORE:MESSAGES`:

```
SET QUEUE TO CORE:MESSAGES.
PRINT "Number of messages on the queue: " + QUEUE:LENGTH.
```

The current vessel's message queue can be accessed using `Vessel:MESSAGES`:

```
SET QUEUE TO SHIP:MESSAGES.
```

## Structure

### MessageQueue

| Suffix | Type | Description |
|--------|------|-------------|
| `EMPTY` | Boolean | true if there are no messages in the queue |
| `LENGTH` | Scalar | number of messages in the queue |
| `POP()` | Message | returns the oldest element in the queue and removes it |
| `PEEK()` | Message | returns the oldest element in the queue without removing it |
| `CLEAR()` | None | remove all messages |
| `PUSH(message)` | None | explicitly append a message |

### MessageQueue:EMPTY

**Type:** Boolean

True if there are no messages in this queue.

### MessageQueue:LENGTH

**Type:** Scalar

Number of messages in this queue.

### MessageQueue:POP()

Returns the first (oldest) message in the queue and removes it. Messages in the queue are always ordered by their arrival date.

### MessageQueue:PEEK()

**Returns:** Message

Returns the oldest message in the queue without removing it from the queue.

### MessageQueue:CLEAR()

Removes all messages from the queue.

### MessageQueue:PUSH(message)

**Parameters:**
- **message** – Message to be added

You can use this method to explicitly add a message to this queue. This will insert this exact message to the queue; all attributes that are normally added automatically by kOS (`Message:SENTAT`, `Message:RECEIVEDAT` and `Message:SENDER`) will not be changed.
