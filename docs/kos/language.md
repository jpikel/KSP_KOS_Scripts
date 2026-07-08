> Source: https://ksp-kos.github.io/KOS/language.html (mirrored offline copy for local reference)

# The KerboScript Language — kOS 1.4.0.0 Documentation

## Navigation

- [Home](index.html)
- [Table of Contents](contents.html)
- [Downloads and Links](downloads_links.html)
- [Tutorials](tutorials.html)
- [Community Example Library](library.html)
- [General](general.html)
- [Language](#)
  - [General Features](language/features.html)
  - [Language Syntax](language/syntax.html)
  - [Flow Control](language/flow.html)
  - [Variables](language/variables.html)
  - [User Functions](language/user_functions.html)
  - [Anonymous User Functions](language/anonymous.html)
  - [Delegates (function references)](language/delegates.html)
  - [Advanced topics](language/delegates.html#advanced-topics)
  - [Kinds of Delegate (no suffixes)](language/delegates.html#kinds-of-delegate-no-suffixes)
- [Mathematics](math.html)
- [Commands](commands.html)
- [Structures](structures.html)
- [Addons](addons.html)
- [Contribute](contribute.html)
- [Getting Help](getting_help.html)
- [Changes](changes.html)
- [About](about.html)

## The KerboScript Language

### General Features
- [Case Insensitivity](language/features.html#case-insensitivity)
- [Expressions](language/features.html#expressions)
- [Short-circuiting booleans](language/features.html#short-circuiting-booleans)
- [Late Typing](language/features.html#late-typing)
- [Lazy Globals (variable declarations optional)](language/features.html#lazy-globals-variable-declarations-optional)
- [User Functions](language/features.html#user-functions)
- [Structures](language/features.html#language-structures)
- [Triggers](language/features.html#triggers)

### Language Syntax
- [General Rules](language/syntax.html#general-rules)
- [Suffixes](language/syntax.html#suffixes)
- [Numbers (scalars)](language/syntax.html#numbers-scalars)
- [Braces (statement blocks)](language/syntax.html#braces-statement-blocks)
- [Functions (built-in)](language/syntax.html#functions-built-in)
- [Suffixes as Functions (Methods)](language/syntax.html#suffixes-as-functions-methods)
- [Suffixes as Lexicon keys](language/syntax.html#suffixes-as-lexicon-keys)
- [User Functions](language/syntax.html#user-functions)
- [Built-In Special Variable Names](language/syntax.html#built-in-special-variable-names)
- [What does not exist (yet?)](language/syntax.html#what-does-not-exist-yet)

### Flow Control
- [`BREAK`](language/flow.html#break)
- [`IF` / `ELSE`](language/flow.html#if-else)
- [CHOOSE (Ternary operator)](language/flow.html#choose-ternary-operator)
- [`LOCK`](language/flow.html#lock)
- [`UNLOCK`](language/flow.html#unlock)
- [`UNTIL` loop](language/flow.html#until-loop)
- [`FOR` loop](language/flow.html#for-loop)
- [`FROM` loop](language/flow.html#from-loop)
- [`WAIT`](language/flow.html#wait)
- [Boolean Operators](language/flow.html#boolean-operators)
- [`DECLARE FUNCTION`](language/flow.html#declare-function)
- [`RETURN`](language/flow.html#return)
- [`WHEN` / `THEN` statements, and `ON` statements](language/flow.html#when-then-statements-and-on-statements)
- [`PRESERVE`](language/flow.html#preserve)

### Variables
- [`DECLARE .. TO/IS`](language/variables.html#declare-to-is)
- [`DECLARE PARAMETER`](language/variables.html#declare-parameter)
- [`SET`](language/variables.html#set)
- [`UNSET`](language/variables.html#unset)
- [`DEFINED`](language/variables.html#defined)
- [`LOCK`](language/variables.html#lock)
- [`TOGGLE`](language/variables.html#toggle)
- [`ON`](language/variables.html#on)
- [`OFF`](language/variables.html#off)
- [Clobbering Built-in names](language/variables.html#clobbering-built-in-names)
- [Scoping terms](language/variables.html#scoping-terms)
- [Scoping syntax](language/variables.html#scoping-syntax)

### User Functions
- [Help for the new user - What is a Function?](language/user_functions.html#help-for-the-new-user-what-is-a-function)
- [DECLARE FUNCTION](language/user_functions.html#declare-function)
- [Using RUN ONCE or RUNONCEPATH](language/user_functions.html#using-run-once-or-runoncepath)
- [DECLARE PARAMETER](language/user_functions.html#declare-parameter)
- [Calling a function](language/user_functions.html#calling-a-function)
- [Optional Parameters (parameter defaults)](language/user_functions.html#optional-parameters-parameter-defaults)
- [LOCAL .. TO](language/user_functions.html#local-to)
- [RETURN](language/user_functions.html#return)
- [Passing by value](language/user_functions.html#passing-by-value)
- [Nesting functions inside functions](language/user_functions.html#nesting-functions-inside-functions)
- [Recursion](language/user_functions.html#recursion)
- [Anonymous functions](language/user_functions.html#anonymous-functions)
- [User Function Gotchas](language/user_functions.html#user-function-gotchas)

### Anonymous User Functions
- [Overview](language/anonymous.html#overview)
- [Syntax](language/anonymous.html#syntax)
- [Passing in to other functions](language/anonymous.html#passing-in-to-other-functions)
- [Lexicon of functions](language/anonymous.html#lexicon-of-functions)

### Delegates (function references)
- [Overview](language/delegates.html#overview)
- [Why?](language/delegates.html#why)
- [Anonymous functions](language/delegates.html#anonymous-functions)
- [lib_enum in KSLib](language/delegates.html#lib-enum-in-kslib)

### Advanced topics
- [Can't call dead delegates](language/delegates.html#can-t-call-dead-delegates)
- [Pre-binding arguments with :bind](language/delegates.html#pre-binding-arguments-with-bind)
- [Closures](language/delegates.html#closures)

### Kinds of Delegate (no suffixes)

---

© Copyright 2013-2021, Developed and maintained by kOS Team, Originally By Nivekk.

Built with [Sphinx](https://www.sphinx-doc.org/) using a [theme](https://github.com/readthedocs/sphinx_rtd_theme) provided by [Read the Docs](https://readthedocs.org).
