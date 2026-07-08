//Filename: hohmann.ks
//Description: calculates a hohmann transfer to another body or vessel orbiting the
// same reference body and adds the maneuver node.
// Does not work for interplanetary transfers (use interplanet.ks).
//reference https://www.faa.gov/other_visit/aviation_industry/designees_delegations/designee_types/ame/media/Section%20III.4.1.5%20Maneuvering%20in%20Space.pdf
//
// Usage:
//   run hohmann.              interactive: menus ask for target and pass offset
//   run hohmann(12000).       scripted: arrive 12 km offset on the leading side
//   run hohmann(-12000).      scripted: 12 km offset on the trailing side
//
// sep_offset meaning (when passed as a number):
//   target is a BODY   -> flyby altitude above its surface in meters
//                         (0 aims at the body's center - an impact course!)
//   target is a VESSEL -> pass distance in meters, + leading / - trailing
//
// If no target is set, a menu of everything orbiting the current body is shown.
// The departure time is found numerically from predicted positions (positionat),
// so it stays accurate for eccentric targets, unlike a pure phase-angle formula.
// Execute the resulting node with node.ks, fine-tune moon flybys with node_tune.ks.

@LAZYGLOBAL OFF.

parameter sep_offset is "ask".  //pass a number to skip the interactive prompts

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").

clearscreen.

//offer everything orbiting the current body: moons/planets first, then vessels
declare function pick_target {
    local candidates to list().

    local bl to list().
    list bodies in bl.
    for b in bl {
        if b:hasbody and b:body = ship:body {
            candidates:add(b).
        }
    }
    local tl to list().
    list targets in tl.
    for v in tl {
        if v:body = ship:body and v:status = "ORBITING" {
            candidates:add(v).
        }
    }

    if candidates:length = 0 {
        print "Nothing is orbiting " + ship:body:name + " to transfer to.".
        return false.
    }

    local names to list().
    for c in candidates {
        names:add(c:name).
    }
    local choice to read_menu("No target set. Transfer to:", names, 0).
    set target to candidates[choice].
    wait 0.5. //give the target selection a tick to settle
    return true.
}

//interactive prompts for the pass offset when no parameter was given
declare function ask_offset {
    clearscreen.
    print "Target: " + target:name.
    if target:istype("Body") {
        local alt_m to read_number("Flyby altitude above surface (m)", 30000, 2).
        if alt_m = 0 {
            return 0.
        }
        local side to read_menu("Pass on which side?", list("leading", "trailing"), 4).
        if side = 0 {
            return abs(alt_m).
        }
        return -abs(alt_m).
    }
    return read_number("Pass distance m (+lead / -trail / 0 direct)", 0, 2).
}

//transfer geometry if we burned prograde at time t_b:
//signed angle (deg) between where the transfer ellipse arrives and where the
//target actually is at arrival, plus the burn dv and time of flight.
//target position relative to the central body: bodies via positionat (their
//body-vs-body prediction is trustworthy), vessels via analytic propagation
//(positionat(vessel, far-future) mixes frames - see lib_orbit.ks).
declare function tgt_relpos {
    parameter t.
    if target:istype("Body") {
        return positionat(target, t) - positionat(ship:body, t).
    }
    return relpos_at(target, t).
}

declare function transfer_geom {
    parameter t_b.
    local bod to ship:body.
    local spos to relpos_at(ship, t_b).
    local r1 to spos:mag.

    //arrival radius depends on TOF for eccentric targets; a few fixed-point
    //iterations converge it together with the transfer time
    local r2 to target:orbit:semimajoraxis.
    local tof to 0.
    from { local i is 0. } until i = 3 step { set i to i + 1. } do {
        local a_t to (r1 + r2) / 2.
        set tof to constant():pi * sqrt(a_t^3 / bod:mu).
        set r2 to tgt_relpos(t_b + tof):mag.
    }

    local a_t to (r1 + r2) / 2.
    //vis-viva both sides, from our own orbit elements (no velocityat)
    local dv to sqrt(bod:mu * (2/r1 - 1/a_t))
                - sqrt(bod:mu * (2/r1 - 1/ship:orbit:semimajoraxis)).

    //the transfer arrives 180 degrees from the burn point, in our orbit plane
    local h to vcrs(-bod:position, ship:velocity:orbit). //plane is constant
    local arr_dir to -spos:normalized.
    local tpos to tgt_relpos(t_b + tof).
    local ang to vang(arr_dir, tpos).
    if vdot(vcrs(arr_dir, tpos), h) < 0 {
        set ang to -ang.
    }
    return lexicon("err", ang, "tof", tof, "dv", dv, "r2", r2).
}

declare function run_hohmann {
    parameter offset.

    local mu to ship:body:mu.

    //desired angular miss at arrival, from the requested pass distance
    local want_sep to abs(offset).
    if target:istype("Body") {
        set want_sep to target:radius + abs(offset).
        if offset = 0 {
            print "WARNING: offset 0 on a body target = impact course!".
        }
    }
    local side to 1.
    if offset < 0 { set side to -1. }

    //scan one synodic period for the departure time where the arrival angle
    //error equals the desired offset angle, then bisect to converge it
    local n_ship to sqrt(mu / ship:orbit:semimajoraxis^3).
    local n_tgt to sqrt(mu / target:orbit:semimajoraxis^3).
    if abs(n_ship - n_tgt) < 1e-9 {
        print "Orbits have nearly identical periods - hohmann phasing won't converge.".
        print "Adjust your orbit up or down first, then re-run.".
        return.
    }
    local window to min(2 * constant():pi / abs(n_ship - n_tgt), 100 * ship:orbit:period).

    clearscreen.
    ui_header("HOHMANN TRANSFER: " + target:name).

    local t0 to time:seconds + 180. //leave time for node.ks to orient and start early for long burns
    local t_b to t0.

    if ship:orbit:eccentricity < 0.05 {
        //near-circular: the transfer model is exact everywhere, so scan the
        //whole window continuously and bisect the phase crossing
        local steps to 180.
        local dt to window / steps.
        local t_lo to 0.
        local t_hi to 0.
        local best_t to t0.
        local best_miss to 1e30.
        local prev_t to t0.
        local prev_f to 0.
        from { local i is 0. } until i > steps or t_hi > 0 step { set i to i + 1. } do {
            local t to t0 + i * dt.
            local g to transfer_geom(t).
            local setpoint to side * (want_sep / g["r2"]) * (180 / constant():pi).
            local f to g["err"] - setpoint.
            if abs(f) < best_miss {
                set best_miss to abs(f).
                set best_t to t.
            }
            //sign change without the +/-180 wrap = a genuine crossing
            if i > 0 and f * prev_f <= 0 and abs(f - prev_f) < 180 {
                set t_lo to prev_t.
                set t_hi to t.
            }
            set prev_t to t.
            set prev_f to f.
            ui_bar("scanning", i / steps, round(100 * i / steps) + "%", 4).
        }
        set t_b to best_t.
        if t_hi > 0 {
            from { local i is 0. } until i = 40 step { set i to i + 1. } do {
                local mid to (t_lo + t_hi) / 2.
                local g to transfer_geom(mid).
                local setpoint to side * (want_sep / g["r2"]) * (180 / constant():pi).
                local f to g["err"] - setpoint.
                local glo to transfer_geom(t_lo).
                local setlo to side * (want_sep / glo["r2"]) * (180 / constant():pi).
                if f * (glo["err"] - setlo) <= 0 {
                    set t_hi to mid.
                } else {
                    set t_lo to mid.
                }
            }
            set t_b to (t_lo + t_hi) / 2.
        } else {
            print "No exact crossing found in the window; using closest match.".
        }
    } else {
        //ELLIPTICAL departure: the transfer model (prograde burn -> transfer
        //ellipse with an apsis at the burn point) is only exact where the
        //velocity is perpendicular to the radius: PERIAPSIS and APOAPSIS.
        //So pick among upcoming Pe/Ap passages - each phases differently
        //against the target - and take the passage that phases best.
        ui_kv("note", "elliptical orbit - departing from a Pe/Ap passage", 13).
        local period to ship:orbit:period.
        local best_miss to 1e30.
        local k to 0.
        until k * period > window + period or k > 80 {
            for t in list(time:seconds + eta:periapsis + k * period,
                          time:seconds + eta:apoapsis + k * period) {
                if t > t0 {
                    local g to transfer_geom(t).
                    local setpoint to side * (want_sep / g["r2"]) * (180 / constant():pi).
                    local f to abs(g["err"] - setpoint).
                    if f < best_miss {
                        set best_miss to f.
                        set t_b to t.
                    }
                }
            }
            set k to k + 1.
            ui_bar("scanning", min(1, k * period / window), "apsis passages", 4).
        }
        ui_kv("note", "best apsis passage phases within "
              + round(best_miss, 2) + " deg", 13).
    }

    local sol to transfer_geom(t_b).
    add node(t_b, 0, 0, sol["dv"]).

    //plane mismatch makes the real closest approach worse than predicted
    local rel_inc to vang(vcrs(-body:position, ship:velocity:orbit),
                          vcrs(positionat(target, time:seconds) - body:position,
                               target:velocity:orbit - body:velocity:orbit)).

    clearscreen.
    ui_header("TRANSFER NODE ADDED: " + target:name).
    ui_kv("delta-v", round(sol["dv"], 1) + " m/s", 4).
    ui_kv("node in", ui_time(nextnode:eta), 5).
    ui_kv("flight time", ui_time(sol["tof"]), 6).
    ui_kv("arrival r", round(sol["r2"] / 1000) + " km", 7).
    if target:istype("Body") {
        ui_kv("aim pass", round(abs(offset) / 1000, 1) + " km above surface", 8).
        print "  (gravity pulls the real periapsis lower - check" at (0, 9).
        print "   map view, refine with node_tune before burning)" at (0, 10).
    } else {
        ui_kv("aim pass", round(offset) + " m " + (choose "leading" if side > 0 else "trailing"), 8).
    }
    if rel_inc > 0.5 and rel_inc < 179.5 {
        ui_kv("WARNING", round(rel_inc, 1) + " deg plane mismatch!", 11).
        print "  match planes first for an accurate intercept" at (0, 12).
    }
}

if not hastarget {
    if not pick_target() {
        print "Aborting.".
    }
}

if hastarget {
    if target:orbit:body <> ship:body {
        print "Target " + target:name + " does not orbit " + ship:body:name + ".".
        print "This script only handles transfers around the same body.".
    } else {
        if sep_offset:istype("String") {
            set sep_offset to ask_offset().
        }
        clearscreen.
        run_hohmann(sep_offset).
        print "next: run node to execute the burn" at (0, 14).
        if target:istype("Body") {
            print "then: run node_tune once the encounter shows" at (0, 15).
        }
    }
}
