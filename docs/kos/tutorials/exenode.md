> Source: https://ksp-kos.github.io/KOS/tutorials/exenode.html (mirrored offline copy for local reference)

# Execute Node Script

## Overview

This tutorial demonstrates automation of maneuver node execution in kOS, a common orbital maneuvering task. The guide walks through writing a script for precise node execution.

## Getting the Next Node

The first step retrieves the available maneuver node:

```
set nd to nextnode.
```

## Calculating Burn Parameters

The script outputs the node's basic information and calculates maximum acceleration:

```
print "Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag).

set max_acc to ship:maxthrust/ship:mass.
```

**Important Note on Calculation:** The tutorial acknowledges that "the real calculation needs to take into account the fact that the mass will decrease as you lose fuel during the burn." For production scripts, consulting the Tsiolkovsky rocket equation is recommended.

The estimated burn duration is:

```
set burn_duration to nd:deltav:mag/max_acc.
print "Crude Estimated burn duration: " + round(burn_duration) + "s".
```

## Waiting and Orientation

The script waits until approaching the burn window, allowing time for ship orientation:

```
wait until nd:eta <= (burn_duration/2 + 60).
```

Then it orients the vessel toward the burn vector:

```
set np to nd:deltav.
lock steering to np.

wait until vang(np, ship:facing:vector) < 0.25.

wait until nd:eta <= (burn_duration/2).
```

## Executing the Burn

The main burn loop adjusts throttle and monitors the burn until completion:

```
set tset to 0.
lock throttle to tset.

set done to False.
set dv0 to nd:deltav.
until done
{
    set max_acc to ship:maxthrust/ship:mass.

    set tset to min(nd:deltav:mag/max_acc, 1).

    if vdot(dv0, nd:deltav) < 0
    {
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        lock throttle to 0.
        break.
    }

    if nd:deltav:mag < 0.1
    {
        print "Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        wait until vdot(dv0, nd:deltav) < 0.5.

        lock throttle to 0.
        print "End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1).
        set done to True.
    }
}
unlock steering.
unlock throttle.
wait 1.
```

## Cleanup

The script concludes by removing the node and ensuring throttle is off:

```
remove nd.

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
```

The resulting script achieves 0.1 m/s precision or better on maneuver node execution.
