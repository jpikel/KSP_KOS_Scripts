//Filename: hop.ks
//Description: vacuum-world lander and biome hopper, built for the Petal at
//Gilly but generic for any airless body with a high local-TWR craft.
//  - orbiting/suborbital: brakes surface velocity and lands under you
//  - landed: ballistic 45-degree hop of a chosen distance along a heading,
//    then lands again (hop a few km to reach the next biome, run science,
//    hop again)
//NO autostaging here on purpose - a lander is all payload.
//
// Usage:
//   run hop.               interactive (heading/distance when landed)
//   run hop(270, 5000).    scripted: hop 5 km due west

@LAZYGLOBAL OFF.

parameter hd is "ask".
parameter dist is 0.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("HOP: " + ship:name + " @ " + body:name).

local g0 to body:mu / body:radius^2.

if body:atm:exists {
    print "This body has an atmosphere - hop.ks is vacuum-only.".
} else {

declare function show {
    parameter phase.
    ui_kv("phase", phase, 4).
    ui_kv("alt (radar)", round(alt:radar) + " m", 5).
    ui_kv("vspeed", round(ship:verticalspeed, 1) + " m/s", 6).
    ui_kv("hspeed", round(ship:groundspeed, 1) + " m/s", 7).
}

//descend and touch down: velocity-profile controller, steering retrograde
//until nearly stopped then straight up. Does NOT touch time warp - set
//physics warp yourself for the boring high fall; the controller runs fine
//under it (drop back to 1x for the final ~500 m if you like your legs).
declare function vacuum_land {
    sas off.
    local thr to 0.
    lock throttle to thr.
    lock steering to choose srfretrograde if ship:velocity:surface:mag > 3
                     else lookdirup(up:vector, ship:facing:topvector).
    until ship:status = "LANDED" or ship:status = "SPLASHED" {
        local vtgt to -min(35, max(0.8, alt:radar / 25)).
        local acc to max(0.05, ship:availablethrust / ship:mass).
        set thr to min(1, max(0, (vtgt - ship:verticalspeed) / acc)).
        if alt:radar < 250 {
            gear on.
        }
        show("DESCENT").
        wait 0.02.
    }
    set thr to 0.
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    sas on.
    show("LANDED").
    ui_kv("site", "lat " + round(ship:geoposition:lat, 3)
          + " lng " + round(ship:geoposition:lng, 3), 9).
    print "run science, then hop again when ready" at (0, 11).
}

declare function do_hop {
    parameter hdg.
    parameter d.

    //sample terrain along the great-circle path to the landing point
    local posn to (-body:position):normalized.
    local hvec to heading(hdg, 0):vector:normalized.
    local ang to (d / body:radius) * constant():radtodeg.
    declare function terrain_at_frac {
        parameter f.
        local dir to posn * cos(ang * f) + hvec * sin(ang * f).
        return body:geopositionof(dir * body:radius + body:position):terrainheight.
    }
    local h0 to terrain_at_frac(0).
    local dh to terrain_at_frac(1) - h0.

    if dh > 0.75 * d {
        ui_kv("hop", "ABORTED", 9).
        ui_kv("note", "site is " + round(dh) + " m higher - too steep for a"
              + " 45 deg hop, go shorter", 10).
        return.
    }

    //45-degree ballistic speed for a landing site dh higher/lower than here:
    //v = d * sqrt(g / (d - dh))   (flat ground: reduces to sqrt(g*d))
    local v to d * sqrt(g0 / (d - dh)).

    //ridge check: trajectory height y(x) = x - g*x^2/v^2 must clear the
    //terrain along the way; boost speed (flattens nothing - it RAISES the
    //arc) until it does or we give up
    from { local try is 0. } until try = 5 step { set try to try + 1. } do {
        local clear to true.
        from { local i is 1. } until i = 4 step { set i to i + 1. } do {
            local x to d * i / 4.
            local y_traj to x - g0 * x^2 / v^2.
            if y_traj < (terrain_at_frac(i / 4) - h0) + 40 {
                set clear to false.
            }
        }
        if clear {
            break.
        }
        set v to v * 1.12.
        ui_kv("note", "ridge in the path - raising the arc", 10).
    }

    local vorb to sqrt(body:mu / (body:radius + altitude)).
    if v > vorb * 0.8 {
        set v to vorb * 0.8. //don't accidentally reach orbit
        ui_kv("note", "speed capped near orbital velocity", 10).
    }
    ui_kv("hop", round(d / 1000, 1) + " km @ hdg " + round(hdg) + " (" + round(v, 1) + " m/s)", 9).
    ui_kv("site delta", round(dh) + " m " + (choose "uphill" if dh > 0 else "downhill"), 8).

    sas off.
    lock steering to heading(hdg, 45).
    local t0 to time:seconds.
    wait until vang(ship:facing:forevector, heading(hdg, 45):forevector) < 10
        or time:seconds > t0 + 25.

    local thr to 0.
    lock throttle to thr.
    until ship:velocity:surface:mag >= v {
        local acc to max(0.05, ship:availablethrust / ship:mass).
        set thr to min(1, max(0.1, (v - ship:velocity:surface:mag) / acc)).
        show("BOOST").
        wait 0.02.
    }
    set thr to 0.
    gear off.

    //coast up and over, then the landing controller takes it from here
    show("COAST").
    wait until alt:radar > 40.
    vacuum_land().
}

//----- main -----
if ship:status = "LANDED" or ship:status = "PRELAUNCH" {
    if hd:istype("String") {
        set hd to read_number("Hop heading (deg)", 90, 12).
        set dist to read_number("Hop distance (m)", 3000, 13).
    }
    do_hop(hd, max(200, dist)).
} else if ship:status = "ORBITING" or ship:status = "SUB_ORBITAL" or ship:status = "FLYING" {
    //brake surface velocity, then descend
    sas off.
    local thr to 0.
    lock throttle to thr.
    lock steering to lookdirup(-ship:velocity:surface, ship:facing:topvector).
    ui_kv("phase", "DEORBIT BRAKE", 4).
    wait until vang(ship:facing:forevector, -ship:velocity:surface) < 5.
    until ship:groundspeed < 3 {
        local acc to max(0.05, ship:availablethrust / ship:mass).
        set thr to min(1, max(0.05, ship:velocity:surface:mag / acc)).
        show("DEORBIT BRAKE").
        wait 0.02.
    }
    set thr to 0.
    vacuum_land().
} else {
    print "Unsupported situation: " + ship:status.
}

}
