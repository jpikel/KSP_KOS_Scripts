> Source: https://ksp-kos.github.io/KOS/structures/collections/stack.html (mirrored offline copy for local reference)

# Stack

A Stack is a collection type in kOS that operates on a "Last-In First-Out" principle. The documentation references Wikipedia's explanations of both LIFO accounting and stack data structures for additional context.

## Using a Stack

```
SET S TO STACK().
S:PUSH("alice").
S:PUSH("bob").

PRINT S:POP. // will print 'bob'
PRINT S:POP. // will print 'alice'
```

## Structure

**Stack** objects are a type of Enumerable collection.

### Members

| Suffix | Type | Description |
|--------|------|-------------|
| All suffixes of Enumerable | — | Stack objects inherit Enumerable functionality |
| `PUSH(item)` | None | Add item to the top of the stack |
| `POP()` | any type | Return and remove the top item |
| `PEEK()` | any type | Return the top item without removing it |
| `CLEAR()` | None | Remove all elements |
| `COPY` | Stack | A new copy of this stack |

**Note:** This type is serializable.

### Method Details

**Stack:PUSH(item)**
- Parameter: `item` (any type) – item to be added
- Adds the item to the top of the stack.

**Stack:POP()**
- Returns the item on top of the stack and removes it.

**Stack:PEEK()**
- Returns the item on top of the stack without removing it.

**Stack:CLEAR()**
- Removes all elements from the stack.

**Stack:COPY**
- Type: Stack
- Access: Get only
- Returns a new stack containing the same elements as the original.
