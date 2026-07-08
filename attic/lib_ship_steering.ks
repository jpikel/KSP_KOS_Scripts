function compute_heading {
    PARAMETER vecT.
    LOCAL east IS VCRS(SHIP:UP:VECTOR, SHIP:NORTH:VECTOR).

    LOCAL trig_x IS VDOT(SHIP:NORTH:VECTOR, vecT).
    LOCAL trig_y IS VDOT(east, vecT).

    LOCAL result IS ARCTAN2(trig_y, trig_x).

    IF result < 0 {RETURN 360 + result.} ELSE {RETURN result.}
}