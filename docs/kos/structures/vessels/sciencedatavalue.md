> Source: https://ksp-kos.github.io/KOS/structures/vessels/sciencedatavalue.html (mirrored offline copy for local reference)

# ScienceData

## Overview

The ScienceData structure represents the results of a science experiment in kOS. It provides access to information about experiment data that has been collected.

## Structure Definition

**ScienceData**

| Suffix | Type | Description |
|--------|------|-------------|
| TITLE | String | Experiment title |
| SCIENCEVALUE | Scalar | Science points gained by returning data to KSC |
| TRANSMITVALUE | Scalar | Science points gained by transmitting data to KSC |
| DATAAMOUNT | Scalar | Amount of data collected |

## Attributes

### ScienceData:TITLE
- **Access:** Get only
- **Type:** String
- **Description:** The name or title of the science experiment

### ScienceData:SCIENCEVALUE
- **Access:** Get only
- **Type:** Scalar
- **Description:** The quantity of science that would be obtained by physically returning the experiment data to the Kerbal Space Center

### ScienceData:TRANSMITVALUE
- **Access:** Get only
- **Type:** Scalar
- **Description:** The quantity of science that would be obtained by transmitting the experiment data to the Kerbal Space Center

### ScienceData:DATAAMOUNT
- **Access:** Get only
- **Type:** Scalar
- **Description:** The size or quantity of collected experimental data
