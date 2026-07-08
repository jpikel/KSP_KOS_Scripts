> Source: https://ksp-kos.github.io/KOS/structures/misc/terminalinput.html (mirrored offline copy for local reference)

# Terminal Input — kOS 1.4.0.0 Documentation

## Overview

The Terminal Input structure enables reading keyboard input from users in kOS programs. Access it via `Terminal:INPUT`.

## Key Characteristics

### Input is Buffered

User keystrokes are stored in a buffer if typed faster than processed. The buffer persists throughout program execution, so use `TerminalInput:CLEAR` to empty it when needed for prompt responses.

### Input is Blocking

Reading a character when none are available pauses execution until the user types. Use `HASCHAR` to check availability before reading to implement non-blocking input.

### Detecting Special Keys

KOS maps special keys (arrows, Page Up, etc.) to custom Unicode codes. Compare read characters against provided suffixes like `UPCURSORONE` or `DOWNCURSORONE`.

Example:
```
set ch to terminal:input:getchar().
if ch = terminal:input:DOWNCURSORONE {
  print "You typed the down-arrow key.".
}
```

### Limitations

- Control-C cannot be read (breaks program execution)
- Shift and Alt keys alone cannot be detected (only when combined with other keys)

## Structure Reference

### Methods and Attributes

| Suffix | Type | Access | Description |
|--------|------|--------|-------------|
| `GETCHAR` | String | Get | Blocking read of next input character (returns 1-char string) |
| `HASCHAR` | Boolean | Get | Returns true if input waiting; false means `GETCHAR` would block |
| `CLEAR` | None | Method | Flushes all waiting input characters |
| `BACKSPACE` | String | Get | Test string for backspace key |
| `DELETERIGHT` | String | Get | Test string for delete-right key |
| `RETURN` / `ENTER` | String | Get | Test string for return/enter key |
| `UPCURSORONE` | String | Get | Test string for up-arrow key |
| `DOWNCURSORONE` | String | Get | Test string for down-arrow key |
| `LEFTCURSORONE` | String | Get | Test string for left-arrow key |
| `RIGHTCURSORONE` | String | Get | Test string for right-arrow key |
| `HOMECURSOR` | String | Get | Test string for HOME key |
| `ENDCURSOR` | String | Get | Test string for END key |
| `PAGEUPCURSOR` | String | Get | Test string for PageUp key |
| `PAGEDOWNCURSOR` | String | Get | Test string for PageDown key |

### Non-Blocking Input Example

```
if terminal:input:haschar {
  process_one_char(terminal:input:getchar()).
}
```
</content>
