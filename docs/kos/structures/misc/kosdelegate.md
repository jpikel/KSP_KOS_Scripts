> Source: https://ksp-kos.github.io/KOS/structures/misc/kosdelegate.html (mirrored offline copy for local reference)

# KOSDelegate — kOS 1.4.0.0 Documentation

## KOSDelegate

The KOSDelegate structure is obtained when using the delegate at-sign syntax or anonymous functions. It represents a reference to a function that can be invoked later in code.

### Example Usage

```
function myfunc { print "hello, there". }
local print_a_thing is myfunc@.
// print_a_thing is now a KOSDelegate of myfunc.
```

```
set del1 to { print "hello, there". }.
// del1 is now a KOSDelegate.
```

A KOSDelegate cannot be called after the program ends and you return to the interactive prompt (see `ISDEAD`).

### Structure

**KOSDelegate**

| Suffix | Type | Description |
|--------|------|-------------|
| `CALL(varying arguments)` | same as the function | Calls the wrapped function |
| `BIND(varying arguments)` | another KOSDelegate | Creates a new delegate with predefined arguments |
| `ISDEAD` | Boolean | True if the delegate refers to a program no longer in memory |

### KOSDelegate:CALL(varying arguments)

Invokes the function this delegate wraps. Arguments passed are forwarded to the function, matching the expected count minus any arguments pre-set with `:BIND`. The explicit `:CALL` suffix can sometimes be omitted, using parentheses directly on the variable instead.

### KOSDelegate:BIND(varying arguments)

Creates a new KOSDelegate from the current one with some parameters pre-defined. The arguments bind to the leftmost function parameters. When calling this new delegate, provide only remaining unbound arguments.

### KOSDelegate:ISDEAD

**Type:** Boolean  
**Access:** Get only

A delegate becomes "dead" when it references code no longer in memory—typically after a program completes while the delegate persists as a global variable.

```
function some_function {
    print "hello".
}
set my_delegate to some_function@.
```

After program exit, calling `my_delegate()` from the interpreter will produce an error.

## DONOTHING (NODELEGATE)

**NoDelegate**

The keyword `DONOTHING` provides a special KOSDelegate subtype called NoDelegate. It has the same suffixes as KOSDelegate, returning `"NoDelegate"` from `:TYPENAME`.

DONOTHING disables callback hooks by assigning it where a KOSDelegate was previously set. It functions like `{return.}` when called, but allows kOS to recognize the intent to disable callbacks entirely.
</content>
