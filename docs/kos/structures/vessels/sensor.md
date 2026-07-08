> Source: https://ksp-kos.github.io/KOS/structures/vessels/sensor.html (mirrored offline copy for local reference)

# Sensor

The Sensor structure represents sensor components in kOS, accessible through the `LIST SENSORS` command. These are based on KSP's `ModuleEnviroSensor` but lack comprehensive documentation.

## Structure: Sensor

Sensors inherit all suffixes from the Part structure. The following attributes are specific to sensors:

| Suffix | Type | Description |
|--------|------|-------------|
| ACTIVE | Boolean | Check if this sensor is active |
| TYPE | String | The sensor type identifier |
| DISPLAY | String | Value of the readout |
| POWERCONSUMPTION | Scalar | Rate of required electric charge |
| TOGGLE() | Method | Call to activate/deactivate |

## Sensor:ACTIVE

**Access:** Get only (can SET to activate or deactivate)

**Type:** Boolean

Returns true if the sensor is enabled.

## Sensor:TYPE

**Access:** Get only

**Type:** String

Identifies the sensor type.

## Sensor:DISPLAY

**Access:** Get only

**Type:** String

"The value of the sensor's readout, usually including the units."

## Sensor:POWERCONSUMPTION

**Access:** Get only

**Type:** Scalar

"The rate at which this sensor drains ElectricCharge."

## Sensor:TOGGLE()

Switches the sensor between active and deactivated states.

## Example Usage

```
PRINT "Full Sensor Dump:".
LIST SENSORS IN SENSELIST.

// TURN EVERY SINGLE SENSOR ON
FOR S IN SENSELIST {
  PRINT "SENSOR: " + S:TYPE.
  PRINT "VALUE:  " + S:DISPLAY.
  IF S:ACTIVE {
    PRINT "     SENSOR IS ALREADY ON.".
  } ELSE {
    PRINT "     SENSOR WAS OFF.  TURNING IT ON.".
    S:TOGGLE().
  }
}
```
