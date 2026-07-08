//Filename: launchwindow.ks
//Description: times a launch so you reach apoapsis just as the target vessel
//passes overhead - the cheap way to start a rendezvous, from KSC or from a
//surface base next to a station's orbit. Predicts the target's future ground
//track (Kepler propagation + body rotation) and finds the launch time where
//target-overhead coincides with your arrival downrange at apoapsis.
//
// Usage (landed/prelaunch, target set to a vessel orbiting this body):
//   run launchwindow.
//
// The two tuning numbers describe YOUR rocket's ascent and improve with data
//from flightlog.csv: time from liftoff to reaching apoapsis, and how many
//degrees downrange the ascent carries you. Kerbin defaults suit the usual
//gravity turn; on airless moons try ~120 s and ~10 deg.

@LAZYGLOBAL OFF.

parameter t_asc is "ask".
parameter downrange is 20.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").

clearscreen.

declare function norm180 {
    parameter a.
    set a to mod(a, 360).
    if a > 180 { set a to a - 360. }
    if a < -180 { set a to a + 360. }
    return a.
}

//target's geographic longitude at future time t
declare function tgt_lng_at {
    parameter t.
    local g to body:geopositionof(relpos_at(target, t) + body:position).
    return norm180(g:lng - 360 * (t - time:seconds) / body:rotationperiod).
}

if not (ship:status = "LANDED" or ship:status = "PRELAUNCH") {
    print "Run this while landed / on the pad.".
} else if not hastarget or target:istype("Body") {
    print "Set the target vessel (the station to meet) first.".
} else if target:body <> ship:body {
    print "Target does not orbit " + body:name + ".".
} else {
    ui_header("LAUNCH WINDOW: meet " + target:name).
    if t_asc:istype("String") {
        set t_asc to read_number("Liftoff-to-apoapsis time (s)", 300, 4).
        set downrange to read_number("Ascent downrange (deg)", 20, 5).
    }
    if target:orbit:inclination > 2 {
        ui_kv("note", "target inclined " + round(target:orbit:inclination, 1)
              + " deg - plane may need matching after", 11).
    }

    //we arrive at site longitude + downrange, t_asc after liftoff; find the
    //launch time where the target is there too
    local desired to norm180(ship:geoposition:lng + downrange).
    local horizon to 3 * target:orbit:period.
    local best_t to time:seconds + 60.
    local best_e to 999.
    from { local i is 0. } until i > 720 step { set i to i + 1. } do {
        local t to time:seconds + 60 + horizon * i / 720.
        local e to abs(norm180(tgt_lng_at(t + t_asc) - desired)).
        if e < best_e {
            set best_e to e.
            set best_t to t.
        }
        if mod(i, 30) = 0 {
            ui_bar("scanning", i / 720, round(100 * i / 720) + "%", 6).
        }
    }
    //refine around the best coarse sample
    local step to horizon / 720.
    from { local i is 0. } until i = 20 step { set i to i + 1. } do {
        set step to step / 2.
        if abs(norm180(tgt_lng_at(best_t - step + t_asc) - desired))
           < abs(norm180(tgt_lng_at(best_t + t_asc) - desired)) {
            set best_t to best_t - step.
        } else if abs(norm180(tgt_lng_at(best_t + step + t_asc) - desired)) < best_e {
            set best_t to best_t + step.
        }
        set best_e to abs(norm180(tgt_lng_at(best_t + t_asc) - desired)).
    }

    local tgt_ap to target:orbit:semimajoraxis - body:radius.
    ui_kv("window in", ui_time(best_t - time:seconds), 6).
    ui_kv("phase error", round(best_e, 2) + " deg at arrival", 7).
    ui_kv("suggest Ap", round(tgt_ap / 1000, 1) + " km (target's altitude)", 8).

    local c to read_menu("At the window:", list(
        "warp + auto-launch (rlseq, defaults)",
        "warp there, then I take over",
        "cancel"), 13).
    if c < 2 {
        if best_t - 20 > time:seconds {
            warpto(best_t - 20).
            wait until warp = 0 and ship:unpacked.
        }
        local cd to 5.
        until cd = 0 {
            ui_kv("t-minus", cd + " s", 9).
            wait 1.
            set cd to cd - 1.
        }
        if c = 0 {
            runpath("0:/rlseq", round(tgt_ap), 90).
            print "in orbit - run rendezvous to close the gap" at (0, 15).
        } else {
            ui_kv("t-minus", "WINDOW OPEN - launch now!", 9).
        }
    }
}
