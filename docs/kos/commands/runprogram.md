> Source: https://ksp-kos.github.io/KOS/commands/runprogram.html (mirrored offline copy for local reference)

# Running Programs — kOS 1.4.0.0 Documentation

## Running Programs

KerboScript supports executing code saved in files on local or archive disks. Programs can run using Run Functions or the Run Keyword. Supported file types include:

- **Raw Text KerboScript files** (.ks extension traditional)
- **Compiled Machine Language Files** (.ksm extension traditional)

> "If you attempt to run the same program twice from within another script, the previously compiled version will be executed without attempting to recompile"

---

## Run Functions

### RUNPATH(path)
### RUNPATH(path, commaSeperatedArgs...)
### RUNONCEPATH(path)
### RUNONCEPATH(path, commaSeperatedArgs...)

**Parameters:**
- **path** (String or Path) – Path information pointing to the script file. May be absolute or relative.
- **commaSeperatedArgs...** (Optional) – Comma-separated arguments to pass to the program

**Examples:**

```
RUNPATH( "myfile.ks" ).
RUNPATH( "myfile" ).
RUNPATH( "myfile.ks", 1, 2 ).

SET file_base to "prog_num_".
SET file_num to 3.
SET file_ending to ".ks".
RUNPATH( file_base + file_num + file_ending, 1, 2 ).
```

---

## Run Keyword

> "You should prefer RUNPATH over RUN"

### RUN [ONCE] path [(commaSeperatedArgs...)]

**Parameters:**
- **once** – Optional keyword to apply run-once logic
- **path** (String or bare word literal) – Path to script file
- **commaSeperatedArgs...** (Optional) – Arguments in parentheses

**Examples:**

```
RUN "myfile.ks".
RUN myfile.ks.
RUN myfile(1,2,3).
RUN myfile.ks(1,2,3).
RUN "myfile.ks"(1,2,3).
```

---

## Details Of Running Programs

### Running a Program "ONCE"

Using `RUNONCEPATH` or the `ONCE` keyword prevents re-execution if already run in the current program context. This suits loading library files with initialization code.

> "The 'ONCE' component has no effect on how frequently a given program is compiled."

### Automatic Guessing of Full Filename

1. If no path information exists, assume current directory
2. If no extension provided, try .ksm first, then .ks

### Arguments

All three run techniques allow parameter passing:

```
RUN "AutoLaunch.ks"( 75000, true, "hello" ).
RUNPATH("AutoLaunch.ksm", 75000, true, "hello" ).
```

Inside the called program:

```
parameter final_alt, do_countdown, message.
```

The parameters receive values: `final_alt` = 75000, `do_countdown` = true, `message` = "hello"
