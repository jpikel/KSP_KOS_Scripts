//Filename: rendezvous.ks
//Description: full automatic rendezvous with another vessel orbiting the same
//body - for rescues, refueling runs, and docking approaches.
//  1. matches orbital planes (live burn at the nodal crossing, if needed)
//  2. runs hohmann for the phased intercept and node to execute it
//  3. brakes to zero relative velocity at closest approach
//  4. creeps in with proportional approach burns until inside the stop
//     distance, then kills relative velocity for good
//Ends station-keeping ~stop distance away: from there run dock (needs RCS),
//or EVA the rescuee over.
//
// Usage:
//   run rendezvous.           menu/prompts (stop distance default 1000 m)
//   run rendezvous(500).      scripted: stop 500 m away
//
// Requires: hohmann.ks, node.ks, lib_input, lib_ui, lib_orbit, lib_staging.

@LAZYGLOBAL OFF.

parameter stop_dist is "ask".

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").
runoncepath("lib_staging.ks").

clearscreen.

declare function relvel {
    return ship:velocity:orbit - target:velocity:orbit.
}

declare function shipnormal {
    return vcrs(-body:position, ship:velocity:orbit):normalized.
}

declare function tgtnormal {
    return vcrs(target:position - body:position, target:velocity:orbit):normalized.
}

//burn helper with the standard staging protections
declare function throttled_burn_tick {
    parameter dvmag.
    local acc to max(0.1, ship:availablethrust / ship:mass).
    lock throttle to min(1, max(0.05, dvmag / acc)).
    if stage_needed() {
        if safe_to_stage() {
            lock throttle to 0.
            stage.
            wait 0.5.
        } else {
            lock throttle to 0.
            ui_kv("status", "OUT OF FUEL - staging blocked", 10).
            return false.
        }
    }
    return true.
}

//time of closest approach within the next orbit, from analytic propagation
declare function closest_approach_time {
    local horizon to ship:orbit:period.
    local best_t to time:seconds + 30.
    local best_d to 1e30.
    from { local i is 0. } until i > 240 step { set i to i + 1. } do {
        local t to time:seconds + 30 + horizon * i / 240.
        local d to (relpos_at(ship, t) - relpos_at(target, t)):mag.
        if d < best_d {
            set best_d to d.
            set best_t to t.
        }
    }
    return best_t.
}

declare function kill_relvel {
    parameter tol.
    if relvel():mag < tol {
        return.
    }
    sas off.
    local dir to -relvel().
    lock steering to lookdirup(dir, ship:facing:topvector).
    ui_kv("status", "aligning to brake", 7).
    wait until vang(ship:facing:forevector, dir) < 3.
    until relvel():mag < tol {
        if relvel():mag > tol * 4 {
            set dir to -relvel(). //freeze direction near zero to avoid flip-flop
        }
        if not throttled_burn_tick(relvel():mag) {
            return.
        }
        ui_kv("rel vel", round(relvel():mag, 2) + " m/s", 6).
        wait 0.05.
    }
    lock throttle to 0.
    ui_kv("rel vel", round(relvel():mag, 2) + " m/s", 6).
}

declare function approach_burn {
    parameter spd.
    lock steering to lookdirup(target:position, ship:facing:topvector).
    ui_kv("status", "aligning to approach at " + round(spd, 1) + " m/s", 7).
    wait until vang(ship:facing:forevector, target:position) < 3.
    until relvel():mag >= spd {
        if not throttled_burn_tick(spd - relvel():mag + 1) {
            return.
        }
        wait 0.05.
    }
    lock throttle to 0.
}

//coast until the (nearly straight-line) closest approach of this leg
declare function coast_to_ca {
    local p to target:position.
    local v to relvel().
    local tca to vdot(p, v) / max(0.0001, v:mag ^ 2).
    ui_kv("status", "coasting " + ui_time(tca) + " to close approach", 7).
    if tca > 120 {
        warpto(time:seconds + tca - 45).
        wait until warp = 0 and ship:unpacked.
    }
    local lastd to target:position:mag + 1.
    until target:position:mag > lastd { //passes through minimum distance
        set lastd to target:position:mag.
        ui_kv("distance", round(lastd) + " m", 4).
        wait 0.5.
    }
}

//----- main -----
if not hastarget {
    local candidates to list().
    local tl to list().
    list targets in tl.
    for v in tl {
        if v:body = ship:body and v:status = "ORBITING" {
            candidates:add(v).
        }
    }
    if candidates:length = 0 {
        print "No vessels orbiting " + ship:body:name + " to rendezvous with.".
    } else {
        local names to list().
        for c in candidates {
            names:add(c:name).
        }
        set target to candidates[read_menu("Rendezvous with:", names, 0)].
        wait 0.5.
    }
}

if hastarget {
    if target:istype("Body") {
        print "Target is a body - use hohmann/interplanet for that.".
    } else if target:body <> ship:body {
        print "Target does not orbit " + ship:body:name + ".".
    } else {
        clearscreen.
        ui_header("RENDEZVOUS: " + target:name).
        if stop_dist:istype("String") {
            set stop_dist to read_number("Stop distance (m)", 1000, 12).
        }

        //1: planes - delegates to matchplanes, so you pick the crossing and
        //   inspect its node before anything burns
        local ri to vang(shipnormal(), tgtnormal()).
        local proceed to true.
        if ri > 0.3 {
            ui_kv("planes", round(ri, 2) + " deg off - running matchplanes", 5).
            wait 2.
            runpath("0:/matchplanes").
            clearscreen.
            ui_header("RENDEZVOUS: " + target:name).
            if hasnode {
                ui_kv("status", "plane node left unexecuted - burn it first", 7).
                set proceed to false.
            }
        }

        //2: phased intercept, aiming to pass a couple of stop-distances off.
        //   The node is created first and you INSPECT it before it burns.
        if proceed {
            ui_kv("status", "planning transfer (hohmann)", 7).
            runpath("0:/hohmann", max(2000, stop_dist * 2)).
            wait 1.
            if not hasnode {
                ui_kv("status", "hohmann made no node - see its message above", 7).
                set proceed to false.
            } else {
                clearscreen.
                ui_header("RENDEZVOUS: " + target:name).
                ui_kv("transfer", round(nextnode:deltav:mag, 1) + " m/s in "
                      + ui_time(nextnode:eta), 4).
                local g to read_menu("Node created - check it in map view first.", list(
                    "looks good - execute and continue",
                    "abort (node kept for your inspection)"), 6).
                if g = 1 {
                    set proceed to false.
                    ui_kv("status", "aborted - node kept; re-run when ready", 7).
                } else {
                    runpath("0:/node").
                    clearscreen.
                    ui_header("RENDEZVOUS: " + target:name).
                }
            }
        }

        if proceed {
            //3: coast to the real closest approach and brake there
            local tca to closest_approach_time().
            if tca - 90 > time:seconds {
                ui_kv("status", "warping to closest approach", 7).
                warpto(tca - 60).
                wait until warp = 0 and ship:unpacked.
            }

            //4: brake / creep-in loop
            local hops to 0.
            until target:position:mag < stop_dist * 1.3 or hops > 8 {
                kill_relvel(0.5).
                ui_kv("distance", round(target:position:mag) + " m", 4).
                if target:position:mag > stop_dist * 1.3 {
                    approach_burn(min(40, max(2, target:position:mag / 100))).
                    coast_to_ca().
                }
                set hops to hops + 1.
            }
            kill_relvel(0.2).

            unlock throttle.
            set ship:control:pilotmainthrottle to 0.
            unlock steering.
            sas on.

            ui_kv("distance", round(target:position:mag) + " m", 4).
            ui_kv("rel vel", round(relvel():mag, 2) + " m/s", 6).
            ui_kv("status", "station-keeping - rendezvous complete", 7).
            print "next: run dock to berth (needs RCS), or EVA over" at (0, 9).
        }
    }
}
