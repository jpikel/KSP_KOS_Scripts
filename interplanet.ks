//Filename: interplanet.ks
//Description: interplanetary transfer planner, PORKCHOP EDITION. Searches
//departure time x time-of-flight with a real Lambert solver (lib_lambert) -
//full 3D, arbitrary sweep angle, so inclined targets like Eve get direct
//encounters instead of in-plane near-misses. Scores each cell by ejection dv
//plus estimated capture dv, builds the ejection node from the 3D v-infinity
//vector, then self-refines the node against the game's own patched conics
//until the encounter shows up.
//
// Usage:
//   run interplanet.        menu of planets if no target, then adds the node
//
// Execute with node.ks (it warps, even across months). Small mid-course
// trims in map view remain normal. At the destination, run capture.

@LAZYGLOBAL OFF.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("lib_orbit.ks").
runoncepath("lib_lambert.ks").

clearscreen.

declare function pick_planet {
    local candidates to list().
    local bl to list().
    list bodies in bl.
    for b in bl {
        if b:hasbody and b:body = sun and b <> ship:body {
            candidates:add(b).
        }
    }
    if candidates:length = 0 {
        print "No planets found to transfer to.".
        return false.
    }
    local names to list().
    for c in candidates {
        names:add(c:name).
    }
    local choice to read_menu("No target set. Transfer to:", names, 0).
    set target to candidates[choice].
    wait 0.5.
    return true.
}

//----- porkchop search: departure time x TOF, scored by real dv -----
declare function porkchop {
    local bod to ship:body.
    local rpark to ship:orbit:semimajoraxis.
    local vpark to sqrt(bod:mu / rpark).
    local rcap to target:radius + 100000.
    if target:atm:exists {
        set rcap to target:radius + max(100000, target:atm:height + 30000).
    }
    local vesc_cap to sqrt(2 * target:mu / rcap).

    //departure plane normal makes "prograde" physical for the solver
    local hdir to vcrs(positionat(bod, time:seconds) - positionat(sun, time:seconds),
                       velocityat(bod, time:seconds):orbit).

    local n1 to sqrt(sun:mu / ship:body:orbit:semimajoraxis^3).
    local n2 to sqrt(sun:mu / target:orbit:semimajoraxis^3).
    local window to 2 * constant():pi / abs(n1 - n2) * 1.25.
    local hoh to constant():pi * sqrt(
        ((bod:orbit:semimajoraxis + target:orbit:semimajoraxis) / 2)^3 / sun:mu).
    local t0 to time:seconds + 600.

    local oldipu to config:ipu.
    set config:ipu to 2000. //the whole search runs at full CPU speed

    //precompute the target's ephemeris ONCE - per-cell lookups become pure
    //vector math instead of expensive positionat/velocityat engine calls.
    //(interpolation is ~15,000 km blurry: fine for RANKING cells; the
    //refinement passes use exact positions.)
    local eph_t0 to t0 + hoh * 0.3.
    local eph_n to 240.
    local eph_dt to (window + hoh * 1.4) / eph_n.
    local eph_pos to list().
    local eph_vel to list().
    from { local i is 0. } until i > eph_n step { set i to i + 1. } do {
        local t to eph_t0 + i * eph_dt.
        eph_pos:add(positionat(target, t) - positionat(sun, t)).
        eph_vel:add(velocityat(target, t):orbit).
        if mod(i, 30) = 0 {
            ui_bar("ephemeris", i / eph_n, round(100 * i / eph_n) + "%", 4).
        }
    }
    declare function eph {
        parameter t.
        local x to (t - eph_t0) / eph_dt.
        local i to floor(x).
        if i < 0 { set i to 0. }
        if i > eph_n - 1 { set i to eph_n - 1. }
        local f to x - i.
        return list(eph_pos[i] * (1 - f) + eph_pos[i + 1] * f,
                    eph_vel[i] * (1 - f) + eph_vel[i + 1] * f).
    }

    declare function cell {
        parameter r1v.   //departure position (hoisted per column)
        parameter v1k.   //departure planet velocity
        parameter t1.
        parameter tof.
        parameter exact. //true = exact ephemeris (refinement passes)
        local r2v to 0.
        local v2k to 0.
        if exact {
            set r2v to positionat(target, t1 + tof) - positionat(sun, t1 + tof).
            set v2k to velocityat(target, t1 + tof):orbit.
        } else {
            local e to eph(t1 + tof).
            set r2v to e[0].
            set v2k to e[1].
        }
        local sol to lambert(r1v, r2v, tof, sun:mu, hdir).
        if not sol["ok"] {
            return lexicon("cost", 1e30).
        }
        local vinfv to sol["v1"] - v1k.
        local eject to sqrt(vinfv:mag^2 + 2*bod:mu/rpark - 2*bod:mu/bod:soiradius) - vpark.
        local avinf to (sol["v2"] - v2k):mag.
        local cap to sqrt(avinf^2 + vesc_cap^2) - vesc_cap.
        return lexicon("cost", eject + cap, "vinfv", vinfv, "eject", eject,
                       "cap", cap, "avinf", avinf, "r2", r2v:mag).
    }

    local best to lexicon("cost", 1e30).
    local best_t to t0.
    local best_f to hoh.

    //coarse grid: 32 departure columns x 12 TOF rows, interpolated ephemeris
    from { local i is 0. } until i > 32 step { set i to i + 1. } do {
        local t1 to t0 + window * i / 32.
        local r1v to positionat(bod, t1) - positionat(sun, t1).
        local v1k to velocityat(bod, t1):orbit.
        from { local j is 0. } until j > 12 step { set j to j + 1. } do {
            local tof to hoh * (0.5 + j / 12).
            local c to cell(r1v, v1k, t1, tof, false).
            if c["cost"] < best["cost"] {
                set best to c.
                set best_t to t1.
                set best_f to tof.
            }
        }
        ui_bar("porkchop", i / 32, round(100 * i / 32) + "%", 4).
    }
    if best["cost"] > 1e20 {
        set config:ipu to oldipu.
        return lexicon("ok", false).
    }

    //three refinement passes with EXACT ephemeris, 5x5 shrinking grids
    local sd to window / 32.
    local sf to hoh / 12.
    from { local lvl is 0. } until lvl = 3 step { set lvl to lvl + 1. } do {
        set sd to sd / 3.
        set sf to sf / 3.
        from { local a is -2. } until a > 2 step { set a to a + 1. } do {
            from { local b is -2. } until b > 2 step { set b to b + 1. } do {
                local t1 to best_t + a * sd.
                local tof to best_f + b * sf.
                if t1 > time:seconds + 300 and tof > hoh * 0.3 {
                    local r1v to positionat(bod, t1) - positionat(sun, t1).
                    local v1k to velocityat(bod, t1):orbit.
                    local c to cell(r1v, v1k, t1, tof, true).
                    if c["cost"] < best["cost"] {
                        set best to c.
                        set best_t to t1.
                        set best_f to tof.
                    }
                }
            }
        }
        ui_bar("porkchop", 1, "refining " + (lvl + 1) + "/3", 4).
    }
    set config:ipu to oldipu.

    set best["ok"] to true.
    set best["t_dep"] to best_t.
    set best["tof"] to best_f.
    return best.
}

//----- ejection node from the full 3D v-infinity vector -----
declare function eval_candidate {
    parameter p.
    parameter t_dep.
    parameter vinf.
    parameter sgn.
    parameter r2.
    parameter dbgrow.

    local n0 to allnodes:length. //so cleanup can never leave strays
    local bod to ship:body.
    local mu to bod:mu.
    local period to ship:orbit:period.

    local t_start to max(time:seconds + 120, t_dep - period).
    local best_t to t_start.
    local best_a to 361.
    from { local i is 0. } until i > 120 step { set i to i + 1. } do {
        local t to t_start + period * i / 120.
        local a to vang(relpos_at(ship, t):normalized, p).
        if a < best_a {
            set best_a to a.
            set best_t to t.
        }
    }
    local t_lo to best_t - period / 120.
    local t_hi to best_t + period / 120.
    from { local i is 0. } until i = 20 step { set i to i + 1. } do {
        if vang(relpos_at(ship, t_lo):normalized, p)
           < vang(relpos_at(ship, t_hi):normalized, p) {
            set t_hi to (t_lo + t_hi) / 2.
        } else {
            set t_lo to (t_lo + t_hi) / 2.
        }
    }
    set best_t to (t_lo + t_hi) / 2.

    local rb to relpos_at(ship, best_t):mag.
    local vb to sqrt(mu * (2 / rb - 1 / ship:orbit:semimajoraxis)).
    local dvv to sqrt(vinf^2 + 2*mu/rb - 2*mu/bod:soiradius) - vb.

    add node(best_t, 0, 0, dvv).
    wait 0.05.
    local score to 1e30.
    local nd to nextnode.
    ui_kv("dbg" + dbgrow, "rb " + round(rb / 1000) + "km vb " + round(vb)
          + " vinf " + round(vinf) + " dv " + round(dvv)
          + " postAp " + round(nd:orbit:apoapsis / 1e6) + "Mm", dbgrow).
    local pp to nd:orbit.
    from { local i is 0. } until i = 4 or not pp:hasnextpatch step { set i to i + 1. } do {
        set pp to pp:nextpatch.
        if pp:body = target {
            set score to pp:periapsis.
        } else if pp:body = sun and score > 1e20 {
            if sgn < 0 {
                set score to 1e10 + abs((pp:periapsis + sun:radius) - r2).
            } else {
                set score to 1e10 + abs((pp:apoapsis + sun:radius) - r2).
            }
        }
    }
    until allnodes:length <= n0 {
        remove allnodes[allnodes:length - 1].
        wait 0.02.
    }
    return lexicon("score", score, "t", best_t, "dv", dvv).
}

declare function build_ejection {
    parameter t_dep.
    parameter vinfv.  //full 3D v-infinity vector from the Lambert solution
    parameter r2.

    local bod to ship:body.
    local mu to bod:mu.
    local vinf to vinfv:mag.
    local sgn to choose -1 if target:orbit:semimajoraxis < bod:orbit:semimajoraxis else 1.

    //project the asymptote into our parking-orbit plane; the self-refine
    //stage's normal nudges recover whatever the projection loses
    local hn to vcrs(-bod:position, ship:velocity:orbit):normalized.
    local dp to (vinfv:normalized - hn * vdot(vinfv:normalized, hn)):normalized.

    local r0 to ship:orbit:semimajoraxis.
    local ecc to 1 + r0 * vinf^2 / mu.
    local nu to arccos(-1 / ecc).

    local p1 to angleaxis(nu, hn) * dp.
    local p2 to angleaxis(-nu, hn) * dp.
    ui_kv("status", "testing candidate ejection 1 of 2", 13).
    local c1 to eval_candidate(p1, t_dep, vinf, sgn, r2, 18).
    ui_kv("status", "testing candidate ejection 2 of 2", 13).
    local c2 to eval_candidate(p2, t_dep, vinf, sgn, r2, 19).
    local best to c1.
    if c2["score"] < c1["score"] {
        set best to c2.
    }
    add node(best["t"], 0, 0, best["dv"]).
    wait 0.05.
}

//----- self-refine against the game's own patched conics -----
declare function node_score {
    parameter cal.
    parameter t_dep.
    parameter tof.
    local nd to nextnode.
    local solar to 0.
    local p to nd:orbit.
    from { local i is 0. } until i = 4 or not p:hasnextpatch step { set i to i + 1. } do {
        set p to p:nextpatch.
        if p:body = target {
            return p:periapsis.
        }
        if p:body = sun and solar:istype("Scalar") {
            set solar to p.
        }
    }
    if solar:istype("Scalar") {
        return 1e30.
    }
    declare function sep {
        parameter t.
        return (orbit_relpos_at(solar, cal, t)
                - (positionat(target, t) - positionat(sun, t))):mag.
    }
    local best to 1e30.
    local best_t to t_dep + tof.
    from { local i is 0. } until i > 40 step { set i to i + 1. } do {
        local t to t_dep + tof * (0.4 + 1.2 * i / 40).
        local d to sep(t).
        if d < best {
            set best to d.
            set best_t to t.
        }
    }
    local lo to best_t - tof * 1.2 / 40.
    local hi to best_t + tof * 1.2 / 40.
    from { local i is 0. } until i = 25 step { set i to i + 1. } do {
        if sep(lo + (hi - lo) * 0.382) < sep(lo + (hi - lo) * 0.618) {
            set hi to lo + (hi - lo) * 0.618.
        } else {
            set lo to lo + (hi - lo) * 0.382.
        }
    }
    set best to min(best, sep((lo + hi) / 2)).
    return 1e9 + best.
}

declare function refine_node {
    parameter cal.
    parameter t_dep.
    parameter tof.

    local oldipu to config:ipu.
    set config:ipu to 2000.

    local nd to nextnode.
    local best to node_score(cal, t_dep, tof).
    local sp to 10.
    local sn to 30.
    local st to 300.
    from { local r is 0. } until r = 14 or best < 1e9 step { set r to r + 1. } do {
        local improved to false.
        for trial in list(list("p", 1), list("p", -1), list("n", 1), list("n", -1),
                          list("t", 1), list("t", -1)) {
            if trial[0] = "p" { set nd:prograde to nd:prograde + trial[1] * sp. }
            else if trial[0] = "n" { set nd:normal to nd:normal + trial[1] * sn. }
            else { set nd:eta to nd:eta + trial[1] * st. }
            wait 0.02.
            local s to node_score(cal, t_dep, tof).
            if s < best {
                set best to s.
                set improved to true.
            } else {
                if trial[0] = "p" { set nd:prograde to nd:prograde - trial[1] * sp. }
                else if trial[0] = "n" { set nd:normal to nd:normal - trial[1] * sn. }
                else { set nd:eta to nd:eta - trial[1] * st. }
                wait 0.02.
            }
        }
        if not improved {
            set sp to sp / 2.
            set sn to sn / 2.
            set st to st / 2.
        }
        local disp to "miss " + round((best - 1e9) / 1000) + " km".
        if best < 1e9 {
            set disp to "ENCOUNTER, pe " + round(best / 1000) + " km".
        }
        ui_kv("refining", "round " + (r + 1) + ": " + disp + "   ", 13).
    }
    set config:ipu to oldipu.
}

declare function run_interplanet {
    clearscreen.
    ui_header("INTERPLANETARY: " + ship:body:name + " -> " + target:name).

    local sol to porkchop().
    if not sol:haskey("ok") or sol["ok"] = false {
        print "Lambert search found no valid transfer - report this.".
    } else {
        build_ejection(sol["t_dep"], sol["vinfv"], sol["r2"]).

        //calibrate the patch propagator against the most inclined planet
        local calbody to target.
        local bl to list().
        list bodies in bl.
        for b in bl {
            if b:hasbody and b:body = sun
               and b:orbit:inclination > calbody:orbit:inclination {
                set calbody to b.
            }
        }
        local cal to orbit_frame_cal(calbody).
        ui_kv("frame cal", calbody:name + ", residual " + round(cal["resid"], 2)
              + " deg (want < 0.1)", 14).
        ui_kv("status", "refining node against patched conics...", 13).
        refine_node(cal, sol["t_dep"], sol["tof"]).

        ui_kv("window in", ui_time(sol["t_dep"] - time:seconds), 4).
        ui_kv("node in", ui_time(nextnode:eta), 5).
        ui_kv("eject dv", round(nextnode:deltav:mag, 1) + " m/s"
              + (choose " RETROGRADE?!" if nextnode:prograde < 0 else ""), 6).
        ui_kv("v-inf out", round(sol["vinfv"]:mag, 1) + " m/s", 7).
        ui_kv("flight time", ui_time(sol["tof"]), 8).
        ui_kv("arrival", round(sol["avinf"], 1) + " m/s v-inf, capture ~"
              + round(sol["cap"]) + " m/s", 9).

        local enc to 0.
        local solar to 0.
        local p to nextnode:orbit.
        from { local i is 0. } until i = 4 or not p:hasnextpatch step { set i to i + 1. } do {
            set p to p:nextpatch.
            if p:body = sun and solar:istype("Scalar") {
                set solar to p.
            }
            if p:body = target and enc:istype("Scalar") {
                set enc to p.
            }
        }
        if not enc:istype("Scalar") {
            ui_kv("ENCOUNTER", "CONFIRMED - " + target:name + " periapsis "
                  + round(enc:periapsis / 1000) + " km", 10).
            if target:atm:exists and enc:periapsis < target:atm:height + 5000 {
                ui_kv("CAUTION", "periapsis in/near atmosphere - raise at mid-course", 11).
            }
        } else if not solar:istype("Scalar") {
            ui_kv("solar orbit", round((solar:periapsis + sun:radius) / 1e9, 2) + " x "
                  + round((solar:apoapsis + sun:radius) / 1e9, 2) + " Gm", 10).
            ui_kv("encounter", "not in conics yet - trim at mid-course in map view", 11).
        } else {
            ui_kv("WARNING", "node does NOT leave " + ship:body:name + "'s SOI!", 10).
            ui_kv("", "do not burn - report the numbers above", 11).
        }
        ui_kv("node comps", round(nextnode:prograde, 1) + " prograde, "
              + round(nextnode:normal, 1) + " normal", 12).
        if allnodes:length > 1 {
            ui_kv("WARNING", allnodes:length + " nodes on the flight plan - delete extras!", 13).
        }
        print "next: run node (it will warp to the window)" at (0, 15).
        print "then: mid-course trim in map view after escape" at (0, 16).
        print "then: run capture on arrival at " + target:name at (0, 17).
    }
}

if not hastarget {
    if not pick_planet() {
        print "Aborting.".
    }
}

if hastarget {
    if not target:istype("Body") or target:body <> sun {
        print "Target " + target:name + " does not orbit the Sun.".
        print "Use hohmann for transfers inside this planet's system.".
    } else if ship:body:body <> sun {
        print "You are orbiting a moon - transfer to " + ship:body:name + "'s planet first.".
    } else if hasnode {
        print "Existing maneuver node(s) found - delete them first, then re-run.".
        print "(The planner adds and removes trial nodes and must start clean.)".
    } else {
        run_interplanet().
    }
}
