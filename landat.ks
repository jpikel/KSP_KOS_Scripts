//Filename: landat.ks
//Description: precision landing next to a landed vessel (surface base) on an
//airless body. Strategy: wait until the orbit passes over the target, brake
//to a stop overhead, then fly a vector-guided descent that steers onto an
//aim point a safe standoff distance from the base. Safe over optimal: costs
//more dv than a shallow approach but lands accurately on rough terrain.
//NO autostaging - a lander is all payload.
//
// Usage (from a LOW, roughly CIRCULAR orbit of the same body):
//   run landat.            menu of landed vessels + standoff prompt
//   run landat(150).       scripted: aim 150 m from the target
//
// Requires local TWR > ~1.3. Test on Minmus first - gentlest teacher.

@LAZYGLOBAL OFF.

parameter standoff is "ask".

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").

clearscreen.

declare function latlng_vec {
    parameter la.
    parameter ln.
    return (body:geopositionlatlng(la, ln):position - body:position):normalized.
}

//----- target selection -----
if not hastarget {
    local candidates to list().
    local tl to list().
    list targets in tl.
    for v in tl {
        if v:body = ship:body and (v:status = "LANDED" or v:status = "SPLASHED" or v:status = "PRELAUNCH") {
            candidates:add(v).
        }
    }
    if candidates:length = 0 {
        print "No landed vessels on " + body:name + " to land at.".
    } else {
        local names to list().
        for c in candidates {
            names:add(c:name).
        }
        set target to candidates[read_menu("Land next to:", names, 0)].
        wait 0.5.
    }
}

if hastarget {
    local tgt to target.
    local tlat to tgt:geoposition:lat.
    local tlng to tgt:geoposition:lng.

    ui_header("LAND AT: " + tgt:name).
    if ship:status <> "ORBITING" {
        print "Start from a low circular orbit of " + body:name + ".".
    } else if abs(tlat) > ship:orbit:inclination + 1 {
        print "Orbit inclination " + round(ship:orbit:inclination, 1)
              + " deg never overflies target latitude " + round(tlat, 1) + " deg.".
        print "Adjust the plane first (a normal burn at the right node).".
    } else if ship:availablethrust / (ship:mass * body:mu / body:radius^2) < 1.3 {
        print "Local TWR under 1.3 - not enough thrust to land safely here.".
    } else {
        if standoff:istype("String") {
            set standoff to read_number("Standoff from base (m)", 100, 12).
        }
        set standoff to max(50, standoff).

        //----- find the next overhead pass (ground track vs fixed site) -----
        ui_kv("status", "finding overhead pass", 7).
        local site_v to latlng_vec(tlat, tlng).
        local rotper to body:rotationperiod.
        local best_t to time:seconds + 120.
        local best_a to 999.
        from { local i is 0. } until i > 720 step { set i to i + 1. } do {
            local dt to 120 + 3 * ship:orbit:period * i / 720.
            local pgeo to body:geopositionof(relpos_at(ship, time:seconds + dt) + body:position).
            local lng_f to pgeo:lng - 360 * dt / rotper. //body rotates east under us
            local a to vang(latlng_vec(pgeo:lat, lng_f), site_v).
            if a < best_a {
                set best_a to a.
                set best_t to time:seconds + dt.
            }
        }
        ui_kv("pass", ui_time(best_t - time:seconds) + " away, "
              + round(best_a, 1) + " deg off track", 5).
        if best_a > 2 {
            ui_kv("note", "track misses by " + round(best_a * body:radius * constant():pi / 180 / 1000, 1)
                  + " km - guidance will chase it (costs fuel)", 6).
        }

        //start braking early enough to stop roughly overhead
        local vorb to ship:velocity:orbit:mag.
        local amax to ship:availablethrust / ship:mass.
        local lead to vorb / (1.4 * amax) + 30.
        if best_t - lead > time:seconds + 30 {
            ui_kv("status", "warping to descent point", 7).
            warpto(best_t - lead).
            wait until warp = 0 and ship:unpacked.
        }

        //----- vector-guided powered descent -----
        sas off.
        local tau to 3. //controller time constant, seconds
        local thr to 0.
        local steer_dir to up:vector.
        lock throttle to thr.
        lock steering to lookdirup(steer_dir, ship:facing:topvector).

        until ship:status = "LANDED" or ship:status = "SPLASHED" {
            local upv to up:vector.
            local glocal to body:mu / body:position:mag^2.

            //aim point: standoff meters short of the base, along our approach
            local off_h to vxcl(upv, tgt:position).
            local aim_h to off_h - off_h:normalized * min(standoff, off_h:mag).

            //desired horizontal velocity: toward the aim point, distance-scaled
            local v_des to v(0, 0, 0).
            if aim_h:mag > 1 {
                set v_des to aim_h:normalized * min(60, max(1.5, aim_h:mag / 6)).
            }
            //desired vertical speed: altitude profile, but don't dive while
            //still far off target laterally
            local vtgt to -min(40, max(0.7, alt:radar / 22)).
            if aim_h:mag > max(60, alt:radar) {
                set vtgt to max(vtgt, -2).
            }

            local vh to vxcl(upv, ship:velocity:surface).
            local acc_cmd to (v_des - vh) / tau
                            + upv * ((vtgt - ship:verticalspeed) / tau + glocal).
            set amax to max(0.05, ship:availablethrust / ship:mass).
            if acc_cmd:mag > 0.2 * glocal {
                set steer_dir to acc_cmd.
            } else {
                set steer_dir to upv.
            }
            set thr to min(1, acc_cmd:mag / amax).
            if alt:radar < 250 {
                gear on.
            }

            ui_kv("to base", round(off_h:mag) + " m (aim " + round(aim_h:mag) + ")", 4).
            ui_kv("alt", round(alt:radar) + " m", 5).
            ui_kv("vspd/hspd", round(ship:verticalspeed, 1) + " / " + round(vh:mag, 1) + " m/s", 6).
            ui_kv("status", "guided descent", 7).
            wait 0.02.
        }

        set thr to 0.
        unlock throttle.
        set ship:control:pilotmainthrottle to 0.
        unlock steering.
        sas on.
        ui_kv("status", "LANDED", 7).
        ui_kv("to base", round(vxcl(up:vector, tgt:position):mag) + " m from " + tgt:name, 4).
    }
}
