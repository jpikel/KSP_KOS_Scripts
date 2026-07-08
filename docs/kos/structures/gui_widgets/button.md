> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/button.html (mirrored offline copy for local reference)

# Button — kOS 1.4.0.0 Documentation

## Button

**structure** Button

A `Button` is a widget that can have script activity occur when the user presses it.

`Button` widgets are created inside Box objects via one of these three methods:

- `Box:ADDBUTTON` - for a button that pops back out again on its own after being clicked.
- `Box:ADDCHECKBOX` - for a toggle button that stays on when clicked and doesn't turn off until clicked again.
- `Box:ADDRADIOBUTTON` - A kind of checkbox that forms part of a set of checkboxes that only allow one of themselves to be on at a time.

The differences between how these types of button behave come from how they will have their default `TOGGLE` and `EXCLUSIVE` suffixes set when they are created.

Buttons are a special case of `Label`, and can use all the features of `Label` to define how their text looks.

### Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `LABEL` | | |
| `PRESSED` | Boolean | Is the button currently down? |
| `TAKEPRESS` | Boolean | Return the PRESSED value AND release the button if it's down. |
| `TOGGLE` | Boolean | Is this button into a toggle-style button? |
| `EXCLUSIVE` | Boolean | Does turning this button on cause other buttons to turn off? |
| `ONCLICK` | KOSDelegate (no args) | Your function called whenever the button gets clicked. |
| `ONTOGGLE` | KOSDelegate (Boolean) | Your function called whenever the button's PRESSED state changes. |

## Button:PRESSED

**Type:** Boolean

**Access:** Get/Set

You can read this value to see if the button is currently on (true) or off (false). You can set this value to cause the button to become on or off.

## Button:TAKEPRESS

**Type:** Boolean

**Access:** Get-only

You can read this value to see if the button is currently on (true) or off (false), however reading this value has a side-effect. When you read this value, if it said the button was on (pressed in), then reading it will cause the button to become off (popped out).

This is useful only for normal buttons (buttons that have `TOGGLE` set to false). It allows you to use the polling technique to repeatedly check to see if the button is on, and as soon as your script notices that it's on, it will pop it back out again so the user sees the proper visual feedback.

## Button:TOGGLE

**Type:** Boolean

**Access:** Get/Set

This suffix determines whether this button has toggle behavior or button behaviour (whether it stays pressed in until pressed a second time). By default, `BOX:ADDBUTTON` will create a button with `TOGGLE` set to false, while `BOX:ADDCHECKBOX` and `BOX:ADDRADIOBUTTON` will create buttons which have their `TOGGLE` suffixes set to true.

### Behaviour when TOGGLE is false (the default):

The conditions under which a button will automatically release itself when `TOGGLE` is set to False are:

- When the script calls the `TAKEPRESS` suffix method. When this is done, the button will become false even if it was previously true.
- If the script defines an `ONCLICK` user delegate. (Then when the `PRESSED` value becomes true, kOS will immediately set it back to false and instead call the `ONCLICK` callback delegate you gave it.)

### Behaviour when TOGGLE is true:

If TOGGLE is set to True, then the button will not automatically release after it is read by the script. Instead it will need to be clicked by the user a second time to make it pop back out. In this mode, the button's `PRESSED` value will never automatically reset to false on its own.

If the Button is created by `Button:ADDCHECKBOX`, or by `Button:ADDRADIOBUTTON`, it will have a different visual style (the style called "toggle") and it will start already in TOGGLE mode.

## Button:EXCLUSIVE

**Type:** Boolean

**Access:** Get/Set

If the Button is created by `Button:ADDRADIOBUTTON`, it will have its `EXCLUSIVE` suffix set to true by default.

If `EXCLUSIVE` is set to True, when the button is clicked (or changed programmatically), other buttons with the same parent `Box` will be set to False (regardless of if they are EXCLUSIVE).

## Button:ONCLICK

**Type:** KOSDelegate

**Access:** Get/Set

This is a `KOSDelegate` that takes no parameters and returns nothing.

`ONCLICK` is what is known as a "callback hook". This suffix allows you to use the callback technique of widget interaction.

You can assign `ONCLICK` to a `KOSDelegate` of one of your functions (named or anonymous) and from then on kOS will call that function whenever the button becomes clicked by the user.

The `ONCLICK` suffix is intended to be used for non-toggle buttons.

**Example:**

```
set mybutton:ONCLICK to { print "Do something here.". }.
```

`ONCLICK` is called with no parameters. To use it, your function must be written to expect no parameters.

## Button:ONTOGGLE

**Type:** KOSDelegate

**Access:** Get/Set

This is a `KOSDelegate` taking one parameter (new boolean state) and returning nothing.

`ONTOGGLE` is what is known as a "callback hook". This suffix allows you to use the callback technique of widget interaction.

The `ONTOGGLE` delegate you assign will get called whenever kOS notices that this button has changed from false to true or from true to false.

To use `ONTOGGLE`, your function must be written to expect a single boolean parameter, which is the new state the button has just been changed to.

**Example:**

```
set mybutton:ONTOGGLE to { parameter val. print "Button value just became " + val. }.
```

`ONTOGGLE` is really only useful with buttons where `TOGGLE` is true.

## Example

Here is a longer example of buttons using the button callback hooks:

```
LOCAL doneYet is FALSE.
LOCAL g IS GUI(200).

// b1 is a normal button that auto-releases itself:
// Note that the callback hook, myButtonDetector, is
// a named function found elsewhere in this same program:
LOCAL b1 IS g:ADDBUTTON("button 1").
SET b1:ONCLICK TO myButtonDetector@.

// b2 is also a normal button that auto-releases itself,
// but this time we'll use an anonymous callback hook for it:
LOCAL b2 IS g:ADDBUTTON("button 2").
SET b2:ONCLICK TO { print "Button Two got pressed". }

// b3 is a toggle button.
// We'll use it to demonstrate how ONTOGGLE callback hooks look:
LOCAL b3 IS g:ADDBUTTON("button 3 (toggles)").
set b3:style to g:skin:button.
SET b3:TOGGLE TO TRUE.
SET b3:ONTOGGLE TO myToggleDetector@.

// b4 is the exit button.  For this we'll use another
// anonymous function that just sets a boolean variable
// to signal the end of the program:
LOCAL b4 IS g:ADDBUTTON("EXIT DEMO").
SET b4:ONCLICK TO { set doneYet to true. }

g:show(). // Start showing the window.

wait until doneYet. // program will stay here until exit clicked.

g:hide(). // Finish the demo and close the window.

//END.

function myButtonDetector {
  print "Button One got clicked.".
}
function myToggleDetector {
  parameter newState.
  print "Button Three has just become " + newState.
}
```
