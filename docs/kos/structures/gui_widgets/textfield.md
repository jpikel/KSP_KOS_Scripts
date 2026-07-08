> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/textfield.html (mirrored offline copy for local reference)

# TextField — kOS 1.4.0.0 Documentation

## TextField

**Structure:** `TextField`

`TextField` objects are created via `BOX:ADDTEXTFIELD`. A `TextField` is a special kind of `Label` that can be edited by the user. Unlike a normal `Label`, a `TextField` can only be textual (it can't be used for image files).

A `TextField` has a default style that looks different from a passive `Label`. In the default style, a `TextField` shows the area the user can click on and type into, using a recessed background.

### Suffixes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `LABEL` | — | Note you read `Label:TEXT` to see the TextField's current value. |
| `CHANGED` | `Boolean` | Has the text been edited? |
| `ONCHANGE` | `KOSDelegate` (`String`) | Your function called whenever the `CHANGED` state changes. |
| `CONFIRMED` | `Boolean` | Has the user pressed Return in the field? |
| `ONCONFIRM` | `KOSDelegate` (`String`) | Your function called whenever the `CONFIRMED` state changes. |
| `TOOLTIP` | `String` | Hint Text to appear in the field when it's empty. |

### TextField:CHANGED

**Type:** `Boolean`  
**Access:** Get/Set

Tells you whether `Label:TEXT` has been edited since the last time you checked. Note that any edit counts. If a user is trying to type "123" into the `TextField` and has written "1" and just pressed "2", then this will be true. Every single edit to the text counts, even if the user has not finished using the textfield.

As soon as you read this suffix and it returns true, it will be reset to false again until the next edit happens.

This suffix is intended to be used with the polling technique of widget interaction.

### TextField:ONCHANGE

**Type:** `KOSDelegate`  
**Access:** Get/Set

This `KOSDelegate` expects one parameter, a `String`, and returns nothing.

This allows you to set a callback delegate to be called whenever the value of `Label:TEXT` changes in any way, whether that's inserting a character or deleting a character.

The `KOSDelegate` you use must be made to expect one parameter, the new string value, and return nothing.

**Example:**

```
set myTextField:ONCHANGE to {parameter str. print "Value is now: " + str.}.
```

This suffix is intended to be used with the callback technique of widget interaction.

### TextField:CONFIRMED

**Type:** `Boolean`  
**Access:** Get/Set

Tells you whether the user is finished editing `Label:TEXT` since the last time you checked. This does not become true merely because the user typed one character into the field or deleted one character (unlike `CHANGED`). This only becomes true when the user does one of the following things:

- Presses `Enter` or `Return` on the field.
- Leaves the field (clicks on another field, tabs out, etc).

As soon as you read this suffix and it returns true, it will be reset to false again until the next time the user commits a change to this field.

This suffix is intended to be used with the polling technique of widget interaction.

### TextField:ONCONFIRM

**Type:** `KOSDelegate`  
**Access:** Get/Set

This `KOSDelegate` expects one parameter, a `String`, and returns nothing.

This allows you to set a callback delegate to be called whenever the user has finished editing `Label:TEXT`. Unlike `CHANGED`, this does not get called every time the user types a key into the field. It only gets called when one of the following things happens:

- User presses `Enter` or `Return` on the field.
- User leaves the field (clicks on another field, tabs out, etc).

The `KOSDelegate` you use must be made to expect one parameter, the new string value, and return nothing.

**Example:**

```
set myTextField:ONCONFIRM to {parameter str. print "Value is now: " + str.}.
```

This suffix is intended to be used with the callback technique of widget interaction.

### TextField:TOOLTIP

**Type:** `String`  
**Access:** Get/Set

(Technically this is inherited from `Label`, but it behaves quite differently in `TEXTFIELD` "Labels" than it does for other more "normal" types of label.)

Unity3d's IMGUI system cannot quite work with proper mouse hover tooltips on typing text fields. kOS can't help this. It's a limit of the Unity3d tool under the hood. So instead, when you set a Tooltip for a `TEXTFIELD`, kOS uses that field differently than it does for other kinds of "label".

In the case of a `TEXTFIELD`, the TOOLTIP, instead of being a string that is set when you hover the mouse over the widget, is the string that will appear inside the field as a hint in a greyed-out way when the field is empty-string. If the user empties the value of the field, then kOS will show this TOOLTIP value inside the field as the hint about what they should type there. (The actual value of the field's `:TEXT` attribute will still be `""`, even when the TOOLTIP is showing in the widget.)

**Example:**

```
set myTextField:TOOLTIP to "Type a Planet Name Here".
```

**Note:** The values of `CHANGED` and `CONFIRMED` reset to False as soon as their value is accessed.
