> Source: https://ksp-kos.github.io/KOS/structures/collections/queue.html (mirrored offline copy for local reference)

# Queue

A `Queue` is a collection type in kOS that operates on a **First-In, First-Out (FIFO)** principle. This contrasts with the `Stack` structure, which uses Last-In, First-Out. For more information, see the Wikipedia article on queue data structures.

## Using a Queue

```
SET Q TO QUEUE().
Q:PUSH("alice").
Q:PUSH("bob").

PRINT Q:POP. // will print 'alice'
PRINT Q:POP. // will print 'bob'
```

## Structure

### Queue

Queue objects inherit all suffixes from the `Enumerable` structure.

| Suffix | Type | Description |
|--------|------|-------------|
| `PUSH(item)` | None | Add item to the end of the queue |
| `POP()` | any type | Return and remove the first element |
| `PEEK()` | any type | Return the first element without removing it |
| `CLEAR()` | None | Remove all elements |
| `COPY` | Queue | Create a new copy of this queue |

**Note:** This type is serializable.

### Queue:PUSH(item)

**Parameters:**
- `item` (any type) – item to be added

Adds the specified item to the end of the queue.

### Queue:POP()

Returns the item at the front of the queue and removes it from the collection.

### Queue:PEEK()

Returns the item at the front of the queue without removing it.

### Queue:CLEAR()

Removes all elements from the queue.

### Queue:COPY

**Type:** Queue  
**Access:** Get only

Returns a new queue containing the same elements as the original.
