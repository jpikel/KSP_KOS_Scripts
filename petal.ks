//petal.ks - self-contained Gilly lander kit. No libraries, fits a 5k disk.
//run petal.   then: 1) hop  2) science sweep  3) land from orbit
//Type numbers blind (no echo) and press ENTER. Crewed ops - no comms needed.
@lazyglobal off.

local g to body:mu / body:radius^2.

declare function num {
    parameter p.
    parameter d.
    print p + " [" + d + "] type + ENTER:".
    local s to "".
    until false {
        wait until terminal:input:haschar.
        local c to terminal:input:getchar().
        if c = terminal:input:enter { break. }
        if "0123456789.-":contains(c) { set s to s + c. }
    }
    if s = "" { return d. }
    return s:tonumber(d).
}

declare function land {
    sas off.
    local th to 0.
    lock throttle to th.
    lock steering to choose srfretrograde if ship:velocity:surface:mag > 3
                     else lookdirup(up:vector, ship:facing:topvector).
    until ship:status = "LANDED" {
        local vt to -min(35, max(0.8, alt:radar / 25)).
        set th to min(1, max(0, (vt - ship:verticalspeed)
                  / max(0.05, ship:availablethrust / ship:mass))).
        if alt:radar < 250 { gear on. }
        print "alt " + round(alt:radar) + "  vspd " + round(ship:verticalspeed, 1) + "    " at (0, 8).
        wait 0.02.
    }
    set th to 0.
    unlock throttle.
    unlock steering.
    set ship:control:pilotmainthrottle to 0.
    sas on.
    print "LANDED lat " + round(ship:geoposition:lat, 3)
          + " lng " + round(ship:geoposition:lng, 3) + "   " at (0, 9).
}

declare function hop {
    parameter hd.
    parameter d.
    local p to (-body:position):normalized.
    local hv to heading(hd, 0):vector.
    local a to (d / body:radius) * constant():radtodeg.
    local dh to body:geopositionof((p * cos(a) + hv * sin(a)) * body:radius + body:position):terrainheight
              - body:geopositionof(p * body:radius + body:position):terrainheight.
    if dh > 0.75 * d {
        print "site " + round(dh) + "m higher - too steep, go shorter".
        return.
    }
    local v to d * sqrt(g / (d - dh)).
    local vo to sqrt(body:mu / (body:radius + altitude)).
    if v > vo * 0.8 { set v to vo * 0.8. }
    print "hop " + round(d) + "m @" + round(hd) + "  v " + round(v, 1) + "  dh " + round(dh).
    sas off.
    lock steering to heading(hd, 45).
    wait 8.
    local th to 0.
    lock throttle to th.
    until ship:velocity:surface:mag >= v {
        set th to 1.
        wait 0.02.
    }
    set th to 0.
    gear off.
    wait until alt:radar > 40.
    land().
}

declare function sci {
    local n to 0.
    for m in ship:modulesnamed("ModuleScienceExperiment") {
        if not m:inoperable and not m:hasdata {
            if not (m:part:hasmodule("ModuleCommand") and ship:crew():length = 0) {
                m:deploy.
                local t to time:seconds.
                wait until m:hasdata or time:seconds > t + 6.
            }
        }
        if m:hasdata { set n to n + 1. }
    }
    print n + " experiments hold data (stored; scientist can EVA-reset goo/matbay).".
}

clearscreen.
print "PETAL KIT  1) hop  2) science  3) land from orbit".
wait until terminal:input:haschar.
local c to terminal:input:getchar().
if c = "1" {
    hop(num("heading", 90), max(200, num("distance m", 3000))).
} else if c = "2" {
    sci().
} else if c = "3" {
    sas off.
    local th to 0.
    lock throttle to th.
    lock steering to lookdirup(-ship:velocity:surface, ship:facing:topvector).
    wait until vang(ship:facing:forevector, -ship:velocity:surface) < 5.
    until ship:groundspeed < 3 {
        set th to min(1, max(0.05, ship:velocity:surface:mag
                  / max(0.05, ship:availablethrust / ship:mass))).
        wait 0.02.
    }
    set th to 0.
    land().
}
