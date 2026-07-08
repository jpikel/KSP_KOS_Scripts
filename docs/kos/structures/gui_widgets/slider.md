> Source: https://ksp-kos.github.io/KOS/structures/gui_widgets/slider.html (mirrored offline copy for local reference)

# Slider

## Structure: SLIDER

The `Slider` widget can be created using `BOX:ADDHSLIDER` or `BOX:ADDVSLIDER` methods. It enables users to adjust a scalar value by moving a sliding marker along a line. This widget works best for real-number values rather than integers.

## Attributes

| Suffix | Type | Description |
|--------|------|-------------|
| Every suffix of `WIDGET` | — | Inherited from parent widget structure |
| `VALUE` | `Scalar` | The current slider value, initially set to `MIN` |
| `ONCHANGE` | `KOSDelegate` (`Scalar`) | Callback function invoked when `VALUE` changes |
| `MIN` | `Scalar` | Minimum value (leftmost on horizontal, top on vertical) |
| `MAX` | `Scalar` | Maximum value (rightmost on horizontal, bottom on vertical) |

## Slider:VALUE

**Type:** `Scalar`  
**Access:** Get/Set

Represents the slider's current value.

## Slider:ONCHANGE

**Type:** `KOSDelegate`  
**Access:** Get/Set

This delegate accepts one parameter (the new value) and returns nothing. It triggers multiple times as the user moves the slider, providing intermediate values. Usage follows the callback interaction pattern:

```
set mySlider:ONCHANGE to whenMySliderChanges@.

function whenMySliderChanges {
  parameter newValue.

  print "Value is " +
         round(100*(newValue-mySlider:min)/(mySlider:max-mySlider:min)) +
         "percent of the way between min and max.".
}
```

## Slider:MIN

**Type:** `Scalar`  
**Access:** Get/Set

Sets the "left" or "top" endpoint. MIN need not be smaller than MAX—reversing them inverts the slider's direction.

## Slider:MAX

**Type:** `Scalar`  
**Access:** Get/Set

Sets the "right" or "bottom" endpoint. When MAX is smaller than MIN, the slider direction reverses.
