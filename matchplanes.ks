//Filename: matchplanes.ks
//Description: match orbital planes with the current target (vessel OR body),
//or with a plane given as inclination + LAN off a satellite contract.
//Offers BOTH nodal crossings (ascending/descending, each with time and cost
//estimate), CREATES A MANEUVER NODE at your pick (sign and magnitude tuned
//against the game's own post-node elements - exact spherical math, no vector
//reconstruction), and offers to execute it via node.ks with all its guards.
//
// Usage:
//   run matchplanes.               target mode (or prompts if no target)
//   run matchplanes(60, 45).       contract mode: inclination 60, LAN 45

@LAZYGLOBAL OFF.

parameter c_inc is -1.  //pass inclination + LAN to skip target mode
parameter c_lan is 0.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").

clearscreen.

declare function shipnormal {
    return vcrs(-body:position, ship:velocity:orbit):normalized.
}

//hemisphere-safe: contract mode builds the goal normal only to find the line
//of nodes; the SCORING below uses pure element math and needs no vectors
local cal_s0 to 1.
local cal_s1 to 1.
local cal_s2 to 1.
declare function normal_for {
    parameter inc.
    parameter lan.
    parameter s0.
    parameter s1.
    parameter s2.
    local an_dir to angleaxis(s1 * lan, v(0, 1, 0)) * solarprimevector.
    return ((angleaxis(s2 * inc, an_dir) * v(0, 1, 0)) * s0):normalized.
}
declare function calibrate_signs {
    local best to 999.
    for s0 in list(1, -1) {
        for s1 in list(1, -1) {
            for s2 in list(1, -1) {
                local e to vang(normal_for(ship:orbit:inclination, ship:orbit:lan, s0, s1, s2),
                                shipnormal()).
                if e < best {
                    set best to e.
                    set cal_s0 to s0.
                    set cal_s1 to s1.
                    set cal_s2 to s2.
                }
            }
        }
    }
    return best.
}

local use_fixed to false.
local fixed_norm to v(0, 1, 0).
declare function tgtnormal {
    if use_fixed {
        return fixed_norm.
    }
    return vcrs(target:position - body:position, target:velocity:orbit):normalized.
}

//----- pick the goal plane -----
local ready to false.
local title to "".

if c_inc >= 0 {
    set use_fixed to true.
    set ready to true.
    set title to "inc " + round(c_inc, 1) + " / LAN " + round(c_lan, 1).
} else if hastarget {
    if target:orbit:body <> ship:body {
        print "Target does not orbit " + ship:body:name + ".".
    } else {
        set ready to true.
        set title to target:name.
    }
} else {
    local c to read_menu("No target set. Match what?", list(
        "a contract plane (enter inclination + LAN)",
        "cancel"), 1).
    if c = 0 {
        set c_inc to read_number("Inclination (deg)", 0, 6).
        set c_lan to read_number("LAN (deg)", 0, 7).
        set use_fixed to true.
        set ready to true.
        set title to "inc " + round(c_inc, 1) + " / LAN " + round(c_lan, 1).
        clearscreen.
    }
}

if use_fixed and ready {
    local resid to calibrate_signs().
    set fixed_norm to normal_for(c_inc, c_lan, cal_s0, cal_s1, cal_s2).
    if resid > 2 {
        print "WARNING: normal construction self-check off by "
              + round(resid, 1) + " deg.".
    }
}

if ready {
    ui_header("MATCH PLANES: " + title).
    local ri to vang(shipnormal(), tgtnormal()).
    ui_kv("rel inc", round(ri, 2) + " deg", 4).
    if ri < 0.1 {
        ui_kv("status", "already aligned - nothing to do", 6).
    } else {
        //goal plane as ELEMENTS, for exact post-node scoring
        local tinc to c_inc.
        local tlan to c_lan.
        if not use_fixed {
            set tinc to target:orbit:inclination.
            set tlan to target:orbit:lan.
        }
        //relative inclination between two planes from inc/LAN alone:
        //cos(rel) = cos i1 cos i2 + sin i1 sin i2 cos(LAN1 - LAN2)
        declare function relinc {
            parameter o.
            return arccos(min(1, max(-1,
                cos(o:inclination) * cos(tinc)
                + sin(o:inclination) * sin(tinc) * cos(o:lan - tlan)))).
        }

        //find both crossings of the line of nodes
        local lon to vcrs(shipnormal(), tgtnormal()):normalized.
        declare function crossing_time {
            parameter dir.
            local period to ship:orbit:period.
            local best_t to time:seconds + 120.
            local best_a to 999.
            from { local i is 0. } until i > 240 step { set i to i + 1. } do {
                local t to time:seconds + 120 + period * i / 240.
                local a to vang(relpos_at(ship, t):normalized, dir).
                if a < best_a {
                    set best_a to a.
                    set best_t to t.
                }
            }
            local lo to best_t - period / 240.
            local hi to best_t + period / 240.
            from { local i is 0. } until i = 18 step { set i to i + 1. } do {
                if vang(relpos_at(ship, lo):normalized, dir)
                   < vang(relpos_at(ship, hi):normalized, dir) {
                    set hi to (lo + hi) / 2.
                } else {
                    set lo to (lo + hi) / 2.
                }
            }
            return (lo + hi) / 2.
        }
        local ta to crossing_time(lon).
        local tb to crossing_time(-lon).

        //label per KSP's map convention: ASCENDING = crossing toward the
        //north side of the target plane
        local tn to tgtnormal().
        if vdot(tn, v(0, 1, 0)) < 0 {
            set tn to -tn.
        }
        declare function xlabel {
            parameter t.
            if vdot(relpos_at(ship, t + 15) - relpos_at(ship, t - 15), tn) > 0 {
                return "ASCENDING".
            }
            return "DESCENDING".
        }
        declare function dv_est {
            parameter t.
            local r to relpos_at(ship, t):mag.
            local v to sqrt(body:mu * (2 / r - 1 / ship:orbit:semimajoraxis)).
            return 2 * v * sin(ri / 2).
        }

        local c to read_menu("Burn at which crossing?", list(
            xlabel(ta) + " in " + ui_time(ta - time:seconds)
                + "  (~" + round(dv_est(ta)) + " m/s)",
            xlabel(tb) + " in " + ui_time(tb - time:seconds)
                + "  (~" + round(dv_est(tb)) + " m/s)",
            "cancel"), 6).
        if c < 2 {
            local t_burn to choose ta if c = 0 else tb.
            local dvm to dv_est(t_burn).

            //create the node; normal SIGN chosen by trying both against the
            //game's post-node elements, then the magnitude polished the same way
            add node(t_burn, 0, dvm, 0).
            wait 0.05.
            local nd to nextnode.
            local plus_score to relinc(nd:orbit).
            set nd:normal to -dvm.
            wait 0.05.
            if relinc(nd:orbit) > plus_score {
                set nd:normal to dvm.
                wait 0.05.
            }
            local best to relinc(nd:orbit).
            local step to dvm / 4.
            from { local i is 0. } until i = 16 or best < 0.05 step { set i to i + 1. } do {
                set nd:normal to nd:normal + step.
                wait 0.02.
                if relinc(nd:orbit) < best {
                    set best to relinc(nd:orbit).
                } else {
                    set nd:normal to nd:normal - 2 * step.
                    wait 0.02.
                    if relinc(nd:orbit) < best {
                        set best to relinc(nd:orbit).
                    } else {
                        set nd:normal to nd:normal + step.
                        set step to step / 2.
                    }
                }
            }

            clearscreen.
            ui_header("PLANE-MATCH NODE: " + title).
            ui_kv("burn", round(nd:deltav:mag, 1) + " m/s normal, in "
                  + ui_time(nd:eta), 4).
            ui_kv("predicted", round(best, 3) + " deg rel inc after the burn", 5).
            local e to read_menu("Execute now with node.ks?", list(
                "yes - burn it",
                "no - leave the node for later"), 7).
            if e = 0 {
                runpath("0:/node").
            }
        }
    }
}
