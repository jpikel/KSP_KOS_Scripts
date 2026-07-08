//Filename: hover.ks
//Description: altitude-hold hover with horizontal drift cancellation. Uses
//the same vector-thrust controller as landat/basedock: gravity feedforward
//plus a vertical-velocity command, with a slight tilt to null sideways drift.
//(The old version's PID fought a feedforward that was mass-squared wrong
//until the lib_physics fix, and its exit condition was unreachable - this
//one can actually land and stop.)
//
// Usage:
//   run hover.          interactive (target radar altitude prompt)
//   run hover(25).      scripted: hover at 25 m
//
// Keys: PGUP/PGDN +/-1 m, UP/DOWN +/-10 m,
//       HOME, DELETE or AG9 = descend, land, and exit.

@LAZYGLOBAL OFF.

parameter seekalt is "ask".

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("HOVER: " + ship:name).

local glocal to body:mu / body:position:mag^2.

if ship:availablethrust / (ship:mass * glocal) < 1.1 {
    print "Local TWR under 1.1 - cannot hover here.".
} else {
    if seekalt:istype("String") {
        set seekalt to read_number("Hover altitude (m radar)", 15, 4).
    }

    local landing to false.
    on ag9 { set landing to true. }

    sas off.
    local thr to 0.
    local steer_dir to up:vector.
    lock throttle to thr.
    lock steering to lookdirup(steer_dir, ship:facing:topvector).

    local tau to 2.
    until ship:status = "LANDED" or ship:status = "SPLASHED" {
        if terminal:input:haschar {
            local ch to terminal:input:getchar().
            if ch = terminal:input:PAGEUPCURSOR      { set seekalt to seekalt + 1. }
            if ch = terminal:input:PAGEDOWNCURSOR    { set seekalt to max(2, seekalt - 1). }
            if ch = terminal:input:UPCURSORONE       { set seekalt to seekalt + 10. }
            if ch = terminal:input:DOWNCURSORONE     { set seekalt to max(2, seekalt - 10). }
            if ch = terminal:input:HOMECURSOR or ch = terminal:input:DELETERIGHTCURSOR {
                set landing to true.
            }
        }

        local upv to up:vector.
        set glocal to body:mu / body:position:mag^2.

        local vtgt to 0.
        if landing {
            set vtgt to -min(6, max(0.6, alt:radar / 15)). //descend and settle
        } else {
            set vtgt to min(8, max(-8, (seekalt - alt:radar) / 4)).
        }

        //vector thrust command: hold vertical speed, tilt to kill drift
        local vh to vxcl(upv, ship:velocity:surface).
        local acc_cmd to upv * (glocal + (vtgt - ship:verticalspeed) / tau)
                        - vh / (tau * 2).
        local amax to max(0.1, ship:availablethrust / ship:mass).
        if acc_cmd:mag > 0.2 * glocal {
            set steer_dir to acc_cmd.
        } else {
            set steer_dir to upv.
        }
        set thr to min(1, max(0, acc_cmd:mag / amax)).
        if landing and alt:radar < 100 {
            gear on.
        }

        ui_kv("mode", choose "LANDING (settle + exit)" if landing
              else "HOVER (HOME/DEL/AG9 to land)", 4).
        ui_kv("altitude", round(alt:radar, 1) + " -> " + round(seekalt) + " m", 5).
        ui_kv("vspeed", round(ship:verticalspeed, 2) + " m/s", 6).
        ui_kv("drift", round(vh:mag, 2) + " m/s", 7).
        ui_kv("throttle", round(thr, 2), 8).
        wait 0.02.
    }

    set thr to 0.
    unlock throttle.
    unlock steering.
    set ship:control:pilotmainthrottle to 0.
    sas on.
    ui_kv("mode", "LANDED - throttle safe", 4).
}
