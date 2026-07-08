> Source: https://ksp-kos.github.io/KOS/language/variables.html (mirrored offline copy for local reference)

# Variables & Statements — kOS 1.4.0.0 Documentation

## DECLARE .. TO/IS

### What it does:

Declares a variable, explicitly or implicitly defining what scope it has, and gives it an initial value.

### Allowed Syntax:

#### Local variable declarations (all equivalent):

- `DECLARE` _identifier_ `TO` _expression_ `.`
- `DECLARE` _identifier_ `IS` _expression_ `.`
- `DECLARE LOCAL` _identifier_ `TO` _expression_ `.`
- `DECLARE LOCAL` _identifier_ `IS` _expression_ `.`
- `LOCAL` _identifier_ `TO` _expression_ `.`
- `LOCAL` _identifier_ `IS` _expression_ `.`

#### Global variable declarations (all equivalent):

- `DECLARE GLOBAL` _identifier_ `TO` _expression_ `.`
- `DECLARE GLOBAL` _identifier_ `IS` _expression_ `.`
- `GLOBAL` _identifier_ `TO` _expression_ `.`
- `GLOBAL` _identifier_ `IS` _expression_ `.`

### Detailed Description of the syntax:

The statement must begin with either `DECLARE`, `LOCAL`, or `GLOBAL`. If it begins with `DECLARE`, it may optionally also contain `LOCAL` or `GLOBAL`. If neither `GLOBAL` nor `LOCAL` is used, `LOCAL` behavior is assumed implicitly.

After the scope keyword, provide an identifier, then either `TO` or `IS` (which mean the same thing), followed by an expression for the initial value, and conclude with a period.

```
// These all do the exact same thing - make a local variable:
DECLARE X TO 1.         // assumes local when unspecified.
LOCAL X IS 1.
DECLARE LOCAL X IS 1.

// These do the exact same thing - make a global variable:
GLOBAL X IS 1.
DECLARE GLOBAL X IS 1.
```

#### Multiple variable declaration:

It is possible to declare multiple variables in a single statement, separated by commas:

```
// These all do the exact same thing - make local variables:
DECLARE A IS 5, B TO 1, C TO "O".
LOCAL A IS 5, B TO 1, C TO "O".
DECLARE LOCAL A IS 5, B TO 1, C TO "O".

// These do the exact same thing - make global variables:
GLOBAL A IS 5, B TO 1, C TO "O".
DECLARE GLOBAL A IS 5, B TO 1, C TO "O".
```

### Scoping:

If you don't know what the terms "global" or "local" mean, read the [scoping section below](#scoping-terms).

**Note:** The outermost scope of a program file is also a local scope. Global variables are shared between functions of your script and can be seen by other programs you run. Local variables you make at the outermost scope of a file won't be visible to other programs.

Alternatively, a variable can be implicitly declared by any `SET` or `LOCK` statement, however this causes the variable to always have global scope. The only way to make a variable be local instead of global is to declare it explicitly with a `DECLARE` statement.

### Initializer required in DECLARE

**Note (New in version 0.17):** The syntax without an initializer is no longer legal. Kerboscript requires the initializer clause (the `TO` keyword) after the identifier name to ensure no uninitialized variables exist in a script.

---

## DECLARE PARAMETER

This statement declares variables to be used as parameters that can be passed in using the `RUN` command (when placed at the main level) or passed to a function when calling it (when placed inside a function body).

The keyword `declare` need not be used; `PARAMETER` alone is legal syntax.

```
// Program 1:
DECLARE PARAMETER X.
PARAMETER Y.              // omitting the word "DECLARE"
PRINT "X times Y is " + X*Y.

// Program 2 (calls Program 1):
SET A TO 7.
RUN PROGRAM1( A, A+1 ).
```

Output: `X times Y is 56.`

#### Multiple parameters in one statement:

```
DECLARE PARAMETER X, Y, CheckFlag.

// Or you could leave "DECLARE" off like so:
PARAMETER X, Y, CheckFlag.
```

**Note:** Unlike normal variables, parameter variables are always local to the program. When program A calls program B and passes parameters to it, program B can alter their values without affecting program A's variables (unless the values are complex structures like Vectors or Lists, which behave as pass-by-reference).

**Restriction:** It is illegal to say `DECLARE GLOBAL PARAMETER` because parameters are always local.

Parameter declarations can appear anywhere in a program as long as they appear before the parameter is used. The order of `DECLARE PARAMETER` statements determines the order arguments must be passed by the caller.

### Optional Parameters (defaulted parameters)

You may make some parameters optional by defaulting them with the `IS` keyword:

```
// Imagine this is a file called MYPROG
DECLARE PARAMETER P1, P2, P3 is 0, P4 is "cheese".
print P1 + ", " + P2 + ", " + P3 + ", " + P4.

// Imagine this is a different file that runs it:
run MYPROG(1,2).                    // prints "1, 2, 0, cheese".
run MYPROG(1,2,3).                  // prints "1, 2, 3, cheese".
run MYPROG(1,2,3,"hi").             // prints "1, 2, 3, hi".
runpath(MYPROG,1,2,3,"hi").         // also prints "1, 2, 3, hi".
```

Whenever arguments are missing, the system makes up the difference by using defaults for the lastmost parameters. It is illegal to put mandatory parameters after defaulted ones.

#### Default parameters follow short-circuit logic

If you have an optional parameter with an initializer expression, the expression will not execute if the calling function had an argument present in that position. The expression only executes if the system needed to pad a missing argument.

#### Pass By Value

Only pass-by-value parameters are supported. However, if you pass a complex aggregate structure (Vector, List, etc.), the parameters will behave like pass-by-reference because you're passing a handle to the object rather than the object itself. This is familiar behavior to anyone who has written Java or C#.

---

## SET

Sets the value of a variable. Implicitly creates a global variable if it doesn't already exist, unless the `@lazyglobal off` directive has been given:

```
SET X TO 1.
SET X TO y*2 - 1.
```

This follows the [scoping rules explained below](#scoping-syntax). If the variable exists in the current local scope or any scope higher up, it won't be created and the existing one will be used instead.

#### Multiple variables in one statement:

```
SET X TO 1, Y TO 5, S TO "abc".
```

---

## UNSET

Removes a user-defined variable if one exists with the given name:

```
UNSET X.
UNSET myvariable.
```

If two variables with the same name exist (one "more local" and one "more global"), the "more local" one will be removed according to [scoping rules](#scoping-syntax).

After execution, the variable becomes undefined.

**Restriction:** `UNSET` cannot be used on kOS built-in bound variable names such as TARGET, GEAR, THROTTLE, STEERING, etc. It only works on variables your script created.

If `UNSET` does not find a variable to remove, or if it fails because the name is built-in, it does NOT generate an error and quietly moves on.

---

## DEFINED

```
DEFINED identifier
```

Returns a boolean true or false according to whether an identifier is defined in such a way that you can use it from the current part of the program (i.e., is it declared, in scope, and visible):

```
// This part prints 'doesn't exist":
if defined var1 {
  print "var1 exists".
} else {
  print "var1 doesn't exist."
}

local var1 is 0.

// But now it prints that it does exist:
if defined var1 {
  print "var1 exists".
} else {
  print "var1 doesn't exist."
}
```

The `DEFINED` operator pays attention to all normal [scoping rules](#scoping-syntax). If an identifier exists but is not usable from the current scope, it returns false.

**Limitation:** `DEFINED` does not work well on things that are not pure identifiers. For example, `print defined var1:suffix1.` will print "False" because it's looking for pure identifiers, not complex suffix chains.

### Difference between SET and DECLARE LOCAL and DECLARE GLOBAL

These three examples look similar but differ:

```
SET X TO 1.
DECLARE LOCAL X TO 1.
DECLARE GLOBAL X TO 1.
```

**SET X TO 1.** performs:
1. Attempt to find an existing local X. If found, set it to 1.
2. Try again for each scoping level outside the current one.
3. If it reaches global scope and still hasn't found X, create a new X with value 1 at global scope. This is called making a "lazy global."

**DECLARE LOCAL X TO 1.** performs:
1. Immediately make a new X at the local-most scope and set it to 1.

**DECLARE GLOBAL X TO 1.** performs:
1. Ignore whether any existing X exists in a local scope.
2. Go to global scope and make a new X there, set it to 1.

### When to use GLOBAL

Use `DECLARE GLOBAL` only sparingly. It exists mostly so a function can store values in the caller for the caller to retrieve. It's generally a "sloppy" design pattern; it's much better to keep everything local and pass back values to the caller as return values.

---

## LOCK

Declares that the identifier will refer to an expression that is always re-evaluated on the fly every time it is used:

```
SET Y TO 1.
LOCK X TO Y + 1.
PRINT X.    // prints "2"
SET Y TO 2.
PRINT X.    // prints "3"
```

Because `LOCK` expressions are implemented as mini functions, they cannot have local scope. A `LOCK` always has global scope by default. This is necessary for backward compatibility with older scripts that use `LOCK STEERING` from inside triggers or loops and expect it to affect the global steering value.

### Calling a LOCK that was created in another file

If you try to call a lock declared in another program file you run, it doesn't work. You can make it work by inserting empty parentheses after the lock name to help the compiler understand you expected a function call:

Change this line:
```
print "x's locked value is " + x.
```

To this instead:
```
print "x's locked value is " + x().
```

### Local lock

You can explicitly make a `LOCK` statement be LOCAL with the `LOCAL` keyword:

```
LOCAL LOCK identifier TO expression.
```

Be aware that doing so with a cooked steering control such as THROTTLE or STEERING will not actually affect your ship. The automated cooked steering control only reads the GLOBAL locks for these settings.

The purpose of making a LOCAL lock is if you only need the value temporarily for the duration of a function call, loop, or if-statement body, and then don't care about it afterward.

#### Why do I care about a local lock?

To make a `LOCK` work even after the variables it uses in its expression go out of scope (necessary for `LOCK STEERING` or `LOCK THROTTLE` to work if done from inside a user function call or trigger body), locks must preserve a "closure." When they do this, none of the local variables used in the function body they were declared in truly "go away" from memory. They live on, taking up space until the lock disappears. Making the lock be local tells the computer it can make the lock disappear when it goes out of scope, and thus doesn't need to hold that "closure" around forever.

**tl;dr:** It's more efficient for memory. If you know for sure your lock isn't getting used after your current section of code is over, make it a local lock.

---

## TOGGLE

Toggles a variable between `TRUE` or `FALSE`. If the variable starts out as a number, it will be converted to a boolean and then toggled. This is useful for setting action groups, which are activated whenever their values are inverted:

```
TOGGLE AG1.    // Fires action group 1.
TOGGLE SAS.    // Toggles SAS on or off.
```

This follows the same rules as [SET](#set), in that if the variable doesn't already exist, it will end up creating it as a global variable.

---

## ON

Sets a variable to `TRUE`. This is useful for the `RCS` and `SAS` bindings:

```
RCS ON.  // Turns on the RCS
```

This follows the same rules as [SET](#set), in that if the variable doesn't already exist, it will end up creating it as a global variable.

---

## OFF

Sets a variable to `FALSE`. This is useful for the `RCS` and `SAS` bindings:

```
RCS OFF.  // Turns off the RCS
```

This follows the same rules as [SET](#set), in that if the variable doesn't already exist, it will end up creating it as a global variable.

---

## Clobbering Built-in names:

kOS has several built-in identifiers that should never be used by programs for their own variable names and function names. Doing so can make built-in things in kOS impossible to use afterward. Even if scoping would normally differentiate them (making a local variable that temporarily masks a built-in name), that can still cause problems in kOS.

kOS now enforces a rule where it complains with an error message if you try to clobber a built-in name with your own name.

**Warning (New in version 1.4.0.0):** kOS only started enforcing this rule in 1.4.0.0 and up, so old scripts from the internet might generate errors. See [`Config:CLOBBERBUILTINS`](#clobberbuiltins-directive) or [`@CLOBBERBUILTINS`](#clobberbuiltins-directive) if you wish to disable this check and get the old behavior back.

For example, because kOS has the built-in function `V(x,y,z)` which makes a vector, you shouldn't make a user-defined function or variable called V. Because kOS has the built-in variable `alt`, you should never make your own variable called `alt`, etc.

Example error message:

```
set altitude to 10.
                ^
Not allowed to SET a name that will clobber or hide the variable called 'ALTITUDE'.
See kOS documentation for CLOBBERBUILTINS for more information.
```

If you get these errors, edit the script to change the name to something else.

If you can't do that and have to use scripts containing names that clobber built-ins, you can re-enable clobbering built-ins using [the @CLOBBERBUILTINS directive](#clobberbuiltins-directive) or the [`Config:CLOBBERBUILTINS`](#clobberbuiltins-directive) configuration setting.

### @CLOBBERBUILTINS directive

If you wish to turn off the enforcement that prevents clobbering built-in names and allow scripts to mask a built-in name with a variable of the same name, you can do so on a per-file basis by putting this line at the top of your program files:

```
@CLOBBERBUILTINS on.
```

This is a compiler directive that MUST occur at the top of the file. The only other things that are allowed to precede it are comments, blanks, and other compiler directives such as [`@LAZYGLOBAL`](#lazyglobal-directive).

This tells kOS to restore the same behavior it had prior to kOS 1.4.0.0. The intended use is to make kOS still work with older scripts that may have been written before this enforcement existed.

### Changing @CLOBBERBUILTINS globally in CONFIG

If you don't want to put a `@CLOBBERBUILTINS on.` directive at the top of every program file, you can globally change the behavior for all of kOS by using the config option [`Config:CLOBBERBUILTINS`](#clobberbuiltins-directive), adjustable on KSP's "Difficulty Options" settings menu under kOS settings, or by directly changing it in a script command.

---

## Scoping terms

### What is Scope?

The term _Scope_ refers to asking "where in the code can this variable be used, and how long does it last before it goes away?" The scope of a variable is the section of the program's code that it "works" within. Any section of the program's code from which the variable cannot be seen is said to be "out of that variable's scope".

### Global scope

Global scope means "this variable can be used from anywhere in the program". If you never use the `DECLARE` statement, your variables in Kerboscript will all be in global scope. For simple easy scripts used by beginners, this is often enough and you don't need to read further until advancing to more intermediate scripts.

### Local Scope

Kerboscript uses block scoping to keep track of local variable scope. You can have variables that are not only local to a function, but are actually local to JUST the current curly-brace block of statements, even if that block is the body of an IF check or the body of an UNTIL loop. A program file also has its own local scope.

### Why limit scope?

You might wonder why it's useful to limit a variable's scope. Wouldn't it be easier just to make all variables global? The answer is twofold:

1. Once a program becomes large enough, trying to remember every variable in the program and coming up with new names becomes unmanageable, especially with programs written by more than one person collaborating.
2. A programming technique known as recursion actually NEEDS local variable scope for the technique to work at all.

If you need variables with local scope, either to keep code more manageable or because you need local scope for recursive function calls, use the `DECLARE LOCAL` statement (or just `LOCAL` for short).

---

## Scoping syntax

### Presumed defaults

The `DECLARE` keyword and the `LOCK` keyword have default presumed scoping behaviors:

**DECLARE** is assumed to always be LOCAL when used with a variable if the words `local` or `global` have been left off. When used with something that is not a variable, the presumed default varies depending on what the declared thing is:

**FUNCTION (not in curly braces):** Functions declared at the outermost file scope (outside any curly braces) that don't mention `global` or `local` behave as if they have the `global` keyword. They can be called from any other program after this program has been run.

**FUNCTION (in curly braces):** Functions declared anywhere inside curly braces that don't mention `global` or `local` behave as if they have the `local` keyword. They can only be called from the local scope of those curly braces or deeper.

**PARAMETER:** Cannot be anything but LOCAL to the location it's mentioned. It is an error to attempt to declare a parameter with the GLOBAL keyword.

**LOCK:** Is assumed to always be GLOBAL when not otherwise specified. This is necessary to preserve backward compatibility with how cooked controls such as `LOCK STEERING` and `LOCK THROTTLE` work.

### Explicit scoping keywords

The `DECLARE`, `FUNCTION`, and `LOCK` commands can be given explicit `GLOBAL` or `LOCAL` keywords to define their intended scoping level (however in the case of functions, `GLOBAL` will be ignored):

```
// These are all synonymous with each other:
DECLARE X IS 1.
DECLARE X TO 1.
DECLARE LOCAL X IS 1.
DECLARE LOCAL X TO 1.
LOCAL X IS 1.    // 'declare' is implied and optional when scoping words are used
LOCAL X TO 1.    // 'declare' is implied and optional when scoping words are used

// These are all synonymous with each other:
DECLARE GLOBAL X TO 1.
GLOBAL X TO 1.   // 'declare' is implied and optional when scoping words are used
GLOBAL X IS 1.   // 'declare' is implied and optional when scoping words are used
```

Even when the word 'DECLARE' is left off, the statement can still be referred to as a "declare statement". The word "declare" is implied by the use of LOCAL or GLOBAL and you are allowed to leave it off merely to reduce verbosity.

### Explicit Scoping required for @lazyglobal off

When operating under the `@LAZYGLOBAL OFF` directive, the keywords LOCAL and GLOBAL are no longer optional for **declare identifier** statements; they are in fact required. You are not allowed to rely on presumed defaults when you've turned off LAZYGLOBAL. (This only applies to trying to make a variable with **declare identifier to value**, and not to `declare parameter` or `declare function`.)

#### Program files also have an outer local scope

Note that even though program files don't need an outermost set of curly braces, they still have a local scope. If you put a `DECLARE LOCAL` statement at the outermost scope of the program, outside any braces, that variable will only be usable from inside that program file and that program file's functions.

Examples:

```
GLOBAL x IS 10.    // X is now a global variable with value 10,
SET y TO 20.       // Y is now a global variable (implicitly) with value 20.
LOCAL z IS 0.      // Z is now local to this file's outer scope. This is
                   // not quite global because it means other program files
                   // can't see it.

SET sum to -1.     // sum is now an implicitly made global variable, containing -1.

// This function is declared at the file's outer scope.
// It can be seen and called by other programs after this program is done.
FUNCTION calcAverage {
  PARAMETER inputList.

  LOCAL sum IS 0.  // sum is now local to this function's body.
  FOR val IN inputList {
    SET sum TO sum + val.
  }.
  print "Inside calcAverage, sum is " + sum.
  RETURN sum / inputList:LENGTH.
}.

SET testList TO LIST(5,10,15);
print "average is " + calcAverage(testList).
print "but out here where it's global, sum is still " + sum.
```

The above example will print:

```
Inside calcAverage, sum is 30
average is 10
but out here where it's global, sum is still -1
```

Thus proving that the variable called SUM inside the function is NOT the same variable as the one called SUM out in the global main code.

#### Nesting

The scoping rules are nested as well. If you attempt to use a variable that doesn't exist in the local scope, the next scope "outside" it will be used, and if it doesn't exist there, the next scope "outside" that will be used and so on, all the way up to the global scope. Only if the variable isn't found at the global scope either will it be implicitly created.

### Scoping and Triggers:

Triggers such as:

- `WHEN <boolean expression> THEN { <statements> }.`
- `ON <any expression> { <statements> }.`

Can use local variables in their trigger expressions in their headers or in the statements of their bodies. The local scope they were declared inside of stays present as part of their "closure".

Example:

```
FUNCTION future_trigger {
  parameter delay.
  print "I will fire the trigger after " + delay + " seconds.".

  local trigger_time is time:seconds + delay.

  // Note that the variable trigger_time is local here,
  // yet this trigger still works after the function
  // has completed and returned:
  when time:seconds > trigger_time then {
    print "I am now firing the trigger off.".
  }
}
print "Before calling future_trigger(3).".
future_trigger(3).
print "After calling future_trigger(3), now waiting 5 seconds.".
print "You should see the trigger message during this wait.".
wait 5.
print "Done waiting.  Program over.".
```

**Note (New in version 1.1.0):** In the past, triggers such as WHEN and ON were not able to use local variables in their check conditions. They had to use only global variables to be trigger-able after the local scope went away. Now these triggers preserve their "closure scope" so they can use any local variables.

---

## @LAZYGLOBAL directive

Often the fact that you can get an implicit global variable declared without intending to can lead to code maintenance headaches down the road. If you make a typo in a variable name, you end up creating a new variable instead of generating an error. Or you may just forget to mark the variable as local when you intended to.

If you wish to instruct Kerboscript to alter its behavior and disable its normal implicit globals and instead demand that all variables MUST be explicitly declared and may not use implied lazy scoping, the `@LAZYGLOBAL` compiler directive allows you to do that.

If you place the words:

```
@LAZYGLOBAL OFF.
```

At the start of your program, you will turn off the compiler's lazy global feature and it will require you to explicitly mention all variables you use in a declaration somewhere (with the exception of the built-in variables such as THROTTLE, STEERING, SHIP, and so on).

**Note:** The `@LAZYGLOBAL` directive does not affect LOCK statements. LOCKS are a special case that define new pseudo-functions when encountered and don't quite work the same way as SET statements do. Thus even with `@LAZYGLOBAL OFF`, it's still possible to make a LOCK statement with a typo in the identifier name and it will still create the new typo'ed lock that way.

### @LAZYGLOBAL Can only exist at the top of your code.

The `@LAZYGLOBAL` compile directive is only allowed as the first non-comment thing in the program file. This is because it instructs the compiler to change its default behavior for the duration of the entire file's compile.

### @LAZYGLOBAL Makes LOCAL and GLOBAL mandatory

Normally the keywords `local` and `global` can be left off as optional in declare **identifier** statements. But when you turn LAZYGLOBAL off, the compiler starts requiring them to be explicitly stated for **declare identifier** statements, to force yourself to be clear and explicit about the difference.

For example, this program, which is valid:

```
function foo {print "foo ". }
declare x is 1.

print foo() + x.
```

Starts giving errors when you add `@LAZYGLOBAL OFF` to the top:

```
@LAZYGLOBAL OFF.
function foo {print "foo ". }
declare x is 1.

print foo() + x.
```

Which you fix by explicitly stating the local keyword, as follows:

```
@LAZYGLOBAL OFF.
function foo {print "foo ". }  // This does not need the 'local' keyword added
declare local x is 1.          // But this does because it is a declare *identifier* statement.
                               // you could have also just said:
                               //     local x is 1.
                               // without the 'declare' keyword.

print foo() + x.
```

If you get in the habit of just writing your **declare identifier** statements like `local x is 1.` or `global x is 1.`, which is probably nicer to read anyway, the issue won't come up.

### Longer Example of use

Example:

```
@LAZYGLOBAL off.
global num TO 1.
IF TRUE {
  LOCAL Y IS 2.
  SET num TO num + Y. // This is fine.  num exists already as a global and
                      // you're adding the local Y to it.
  SET nim TO 20. // This typo generates an error.  There is
                 // no such variable "nim" and @LAZYGLOBAL OFF
                 // says not to implicitly make it.
}.
```

### Why LAZYGLOBAL OFF?

The rationale behind `@LAZYGLOBAL OFF.` is to primarily be used in cases where you're writing a library of function calls you intend to use elsewhere, and want to be careful not to accidentally make them dependent on globals outside the function itself.

The `@LAZYGLOBAL OFF.` directive is meant to mimic Perl's `use strict;` directive.

---

## History

Kerboscript began its life as a language in which you never have to declare a variable if you don't want to. You can just create any variable implicitly by just using it in a SET statement.

There are a variety of programming languages that work like this, such as Perl, JavaScript, and Lua. However, they all share one thing in common: once you want to allow the possibility of having local variables, you have to figure out how this should work with the implicit variable declaration feature.

All those languages went with the same solution, which Kerboscript now follows as well. Because implicit undeclared variables are intended to be a nice easy way for new users to ease into programming, they should always default to being global so that people who wish to keep programming that way don't need to understand or deal with scope.
