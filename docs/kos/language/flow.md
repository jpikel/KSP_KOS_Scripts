> Source: https://ksp-kos.github.io/KOS/language/flow.html (mirrored offline copy for local reference)

# Flow Control — kOS 1.4.0.0 Documentation

## Overview

Flow control statements in kOS determine how programs execute, branch, and loop. This page documents all major control structures available in KerboScript.

## BREAK

Exits a loop prematurely:

```kerboscript
SET X TO 1.
UNTIL 0 {
    SET X TO X + 1.
    IF X > 10 { BREAK. }
}
```

## IF / ELSE

Executes code conditionally based on boolean expressions. Can chain multiple conditions with ELSE IF:

```kerboscript
SET X TO 1.
IF X = 1 { PRINT "X equals one.". }
IF X > 10 { PRINT "X is greater than ten.". }

IF X > 10 { PRINT "X is large". } ELSE { PRINT "X is small". }

IF X = 0 {
    PRINT "zero".
} ELSE IF X < 0 {
    PRINT "negative".
} ELSE {
    PRINT "positive".
}
```

**Note:** Periods after closing braces are optional. However, when using ELSE, do not terminate the IF block with a period before the ELSE keyword, as this causes a syntax error.

## CHOOSE (Ternary Operator)

Returns one of two values based on a condition. This is an expression (not a statement), so it can be embedded in other expressions:

```
CHOOSE expression1 IF condition ELSE expression2
```

Examples:

```kerboscript
SET X TO CHOOSE expression1 IF condition ELSE expression2.
PRINT CHOOSE "High" IF altitude > 20000 ELSE "Low".
```

The true choice appears first, then the condition, then the false choice.

## LOCK

Binds a variable to an expression that recalculates each time the variable is accessed:

```kerboscript
SET X TO 1.
LOCK Y TO X + 2.
PRINT Y.         // Outputs 3
SET X TO 4.
PRINT Y.         // Outputs 6
```

LOCK follows scoping rules similar to SET. When used with flight controls like THROTTLE or STEERING, the lock becomes a trigger evaluated each physics tick.

## UNLOCK

Releases a lock on a variable:

```kerboscript
UNLOCK X.        // Releases lock on X
UNLOCK ALL.      // Releases all locks
```

## UNTIL Loop

Repeats code until a condition becomes true:

```kerboscript
SET X to 1.
UNTIL X > 10 {
    PRINT X.
    SET X to X + 1.
}
```

**Important:** When monitoring physical values that change each iteration, include a small WAIT at the loop bottom:

```kerboscript
SET PREV_TIME to TIME:SECONDS.
SET PREV_VEL to SHIP:VELOCITY.
SET ACCEL to V(9999,9999,9999).
PRINT "Waiting for accelerations to stop.".
UNTIL ACCEL:MAG < 0.5 {
    SET ACCEL TO (SHIP:VELOCITY - PREV_VEL) / (TIME:SECONDS - PREV_TIME).
    SET PREV_TIME to TIME:SECONDS.
    SET PREV_VEL to SHIP:VELOCITY.
    WAIT 0.001.
}
```

## FOR Loop

Iterates over list elements one at a time:

```
FOR variable1 IN variable2 { use variable1 here. }
```

Example:

```kerboscript
PRINT "Counting flamed out engines:".
SET numOUT to 0.
LIST ENGINES IN MyList.
FOR eng IN MyList {
    IF ENG:FLAMEOUT {
        set numOUT to numOUT + 1.
    }
}
PRINT "There are " + numOut + " flamed out engines.".
```

This is a foreach-style loop, not a traditional three-part for-loop. Use FROM loops for C-style iteration.

## FROM Loop

A three-part loop with explicit initialization, condition, and increment sections:

### Syntax

```
FROM { one or more statements } UNTIL Boolean_expression STEP { one or more statements } DO one statement or block
```

### Quick Example

```kerboscript
print "Countdown initiated:".
FROM {local x is 10.} UNTIL x = 0 STEP {set x to x-1.} DO {
  print "T -" + x.
}
```

### Parts Explained

- **FROM clause:** Initialization statements executed before the first iteration. Variables declared here are local to the loop. Braces are mandatory even for single statements.

- **UNTIL clause:** Boolean expression checked at the start of each iteration. Loop exits if true. No braces.

- **STEP clause:** Statements executed at the end of each iteration (typically incrementing/decrementing variables). Braces mandatory even for single statements.

- **DO clause:** The loop body. Braces optional for single statements but recommended.

### Formatting Examples

```kerboscript
// Compact form
FROM {local x is 1.} UNTIL x > 10 STEP {set x to x+1.} DO { print x.}

// Header on one line, body indented
FROM {local x is 1.} UNTIL x > 10 STEP {set x to x+1.} DO {
  print x.
}

// Each header part on its own line
FROM {local x is 1.}
UNTIL x > 10
STEP {set x to x+1.}
DO {
  print x.
}

// Fully expanded
FROM {
  local x is 1.
  local y is 10.
}
UNTIL x > 10 or y = 0
STEP {
  set x to x+1.
  set y to y-1.
}
DO {
  print "x is " + x + ", y is " + y.
}
```

### Equivalence to UNTIL

A FROM loop is equivalent to this UNTIL structure:

```kerboscript
{
    AAAA
    UNTIL BBBB {
        DDDD
        CCCC
    }
}
```

Where AAAA is the FROM clause, BBBB is the condition, DDDD is the body, and CCCC is the STEP clause.

## WAIT

Pauses execution for a specified duration or until a condition is met:

```kerboscript
WAIT 6.2.                     // Wait 6.2 seconds
WAIT UNTIL X > 40.            // Wait until condition is true
WAIT UNTIL APOAPSIS > 150000. // Practical example
```

All WAIT statements last at least one physics tick, regardless of specification.

### Wait in Mainline vs. Triggers

When called from mainline code, WAIT suspends execution but allows triggers to interrupt and fire. When used inside a trigger body (WHEN, ON, or steering control lock), WAIT blocks all non-higher-priority execution. Using WAIT inside triggers is generally discouraged.

## Boolean Operators

Order of operations:
1. `=` `<` `>` `<=` `>=` `<>`
2. `AND`
3. `OR`
4. `NOT`

Boolean constants `True` and `False` (case-insensitive) may be used. Numbers are interpreted as booleans (zero = false, non-zero = true):

```kerboscript
IF X = 1 AND Y > 4 { PRINT "Both conditions are true". }
IF X = 1 OR Y > 4 { PRINT "At least one condition is true". }
IF NOT (X = 1 or Y > 4) { PRINT "Neither condition is true". }
IF X <> 1 { PRINT "X is not 1". }
SET MYCHECK TO NOT (X = 1 or Y > 4).
IF MYCHECK { PRINT "mycheck is true." }
LOCK CONTINUOUSCHECK TO X < 0.
WHEN CONTINUOUSCHECK THEN { PRINT "X has just become negative.". }
IF True { PRINT "This statement happens unconditionally." }
IF False { PRINT "This statement never happens." }
IF 1 { PRINT "This statement happens unconditionally." }
IF 0 { PRINT "This statement never happens." }
IF count { PRINT "count isn't zero.". }
```

## DECLARE FUNCTION

Creates user-defined functions. See the user functions documentation for details.

## RETURN

Ends a user function or trigger, optionally providing a return value. See the user functions documentation for details.

## WHEN / THEN and ON Statements

Advanced features that create background triggers to check conditions repeatedly. Both are similar but have key differences.

### Syntax

| WHEN / THEN | ON |
|---|---|
| `WHEN boolean_expression THEN { statements }` | `ON any_expression { statements }` |
| `WHEN boolean_expression THEN single_statement.` | `ON any_expression single_statement.` |

The `THEN` keyword is required for WHEN but not for ON (for historical reasons).

### Differences

- **WHEN:** Executes statements when the boolean expression becomes true. Must be a boolean expression.
- **ON:** Executes statements when the expression's value changes from the last check. Can be any expression supporting equality testing.

### Examples

```kerboscript
// WHEN example
SET tenSecondsLater to TIME:SECONDS + 10.
WHEN TIME:SECONDS > tenSecondsLater THEN {
  PRINT "Ten seconds have passed.".
}
PRINT "now checking in the background to see if 10 seconds have passed yet.".
WAIT UNTIL FALSE.

// ON example
ON AG1 {
  PRINT "You pressed '1', causing action group 1 to toggle.".
  PRINT "Action group 1 is now " + AG1.
  PRINT "No longer paying attention.".
}
WAIT UNTIL FALSE.
```

### Key Behaviors

- Triggers interrupt normal program flow when they fire
- By default, triggers execute only once and then are deleted
- Triggers don't persist after the program ends
- Keep trigger bodies short and fast to avoid starving mainline code

### Warning

Lengthy trigger body execution blocks mainline code and other triggers. Avoid using WAIT inside triggers.

### Preserving Triggers with RETURN

By default, triggers fire once and are deleted. Return a boolean value to control this:

- `RETURN true.` keeps the trigger active for future checks
- `RETURN false.` deletes the trigger after this execution

```kerboscript
ON AG1 {
  PRINT "You pressed '1', causing action group 1 to toggle.".
  PRINT "Action group 1 is now " + AG1.
  RETURN true.
}
```

Complex example with conditional preservation:

```kerboscript
SET count TO 5.
ON AG1 {
  PRINT "You pressed '1', causing action group 1 to toggle.".
  PRINT "Action group 1 is now " + AG1.
  SET count TO count - 1.
  PRINT "I will only pay attention " + count + " more times.".
  if count > 0
    RETURN true.
  else
    RETURN false.
}
```

If no return value is specified, the default is `false` (trigger is deleted).

## PRESERVE

An older method for keeping triggers alive, still supported for backward compatibility. When executed anywhere in a trigger body, it signals kOS to keep the trigger active:

```kerboscript
ON AG1 {
  PRINT "You pressed '1', causing action group 1 to toggle.".
  PRINT "Action group 1 is now " + AG1.
  PRESERVE.
}
```

This is equivalent to using `RETURN true.` The `PRESERVE` statement doesn't cause early return; it just sets a flag. Placement within the body doesn't matter. If both `PRESERVE` and a contradicting `RETURN false.` are used, the `RETURN` statement takes precedence.

---

*Documentation for kOS version 1.4.0.0*
