//***********************************/
//*      Auto-docking system v2     */
//***********************************/
// Based on the original by HerrCrazi (FAITO Aerospace), reworked for full automation:
//  - picks a free docking port on your ship and a matching free port on the target
//  - flies around to the target port's approach axis (even if you start behind it)
//  - centers on the axis, then closes with distance-scaled speed, ~0.2 m/s at contact
//
// Usage: target a vessel (or a specific docking port on it), get within loading
// range (~2.5 km) with relative velocity mostly killed, then run dock.
//
// Controls while running:
//   AG9        abort (kills controls, leaves you in a safe hold)
//   HOME/END   roll +/- 15 degrees (for ports that need roll alignment)
//   UP/DOWN    speed scale +/- 25%

@lazyglobal off.

parameter debug is true.	//Set to true to draw the guidance vectors on screen

runoncepath("lib_ui.ks").

declare function clampv {
    parameter v, lo, hi.
    return min(hi, max(lo, v)).
}

//first docking port on the vessel that is free, preferring a matching node size
declare function firstreadyport {
    parameter ves.
    parameter ntype is "".
    for p in ves:dockingports {
        if p:state = "Ready" and (ntype = "" or p:nodetype = ntype) {
            return p.
        }
    }
    return 0.
}

declare function autodock {
    parameter myport.
    parameter tport.

    myport:controlfrom().
    rcs on.
    sas off.

    local rotation to 0.
    local speedscale to 1.0.
    local stop to false.
    on ag9 { set stop to true. }

    //face the target port head-on; controlfrom() above makes ship:facing = our port's facing
    lock steering to lookdirup(-tport:portfacing:forevector, tport:portfacing:upvector) + r(0,0,rotation).

    print "Aligning with " + tport:ship:name + " port...".
    wait until stop or vang(ship:facing:forevector, -tport:portfacing:forevector) < 5.

    //velocity controllers: setpoint is desired relative velocity (m/s) per ship axis,
    //output drives the RCS translation controls (-1..1)
    local pidfore to pidloop(1.5, 0.1, 0.02, -1, 1).
    local pidtop  to pidloop(1.5, 0.1, 0.02, -1, 1).
    local pidstar to pidloop(1.5, 0.1, 0.02, -1, 1).

    local mode to "TRANSIT".
    local vd_err to 0.
    local vd_cmd to 0.
    local vd_axis to 0.
    clearscreen.
    ui_header("AUTO-DOCK: " + tport:ship:name).

    until stop or myport:state <> "Ready" {
        if terminal:input:haschar {
            local ch to terminal:input:getchar().
            if ch = terminal:input:HOMECURSOR      { set rotation to rotation + 15. }
            if ch = terminal:input:ENDCURSOR       { set rotation to rotation - 15. }
            if ch = terminal:input:UPCURSORONE     { set speedscale to speedscale + 0.25. }
            if ch = terminal:input:DOWNCURSORONE   { set speedscale to max(0.25, speedscale - 0.25). }
        }

        local fore to tport:portfacing:forevector.
        local upv to tport:portfacing:upvector.

        //our port's position relative to the target port, split into
        //distance out along the port axis (px) and off-axis offset (plat)
        local p to myport:nodeposition - tport:nodeposition.
        local px to vdot(p, fore).
        local plat to p - fore * px.
        local lateral to plat:mag.

        //pick a waypoint (expressed relative to the target port) and a speed limit
        local wp to v(0,0,0).
        local vmax to 2.0.

        if px < 0 or (px < 5 and lateral > 2) {
            //wrong side of the target: head for a standoff point 50m out on the
            //approach axis, swinging wide so we never cut through the station
            set mode to "TRANSIT".
            local latdir to upv.
            if lateral > 0.1 { set latdir to plat:normalized. }
            if px < 0 and lateral < 20 {
                set wp to fore * 50 + latdir * 30.
            } else {
                set wp to fore * 50.
            }
            set vmax to 3.0.
        } else if lateral > 0.4 and px > 4 {
            //in front but off-axis: slide sideways onto the approach axis
            set mode to "ALIGN  ".
            set wp to fore * max(px, 10).
            set vmax to 1.0.
        } else {
            //on the axis: close in, slowing as we get near (~0.2 m/s at contact)
            set mode to "APPROACH".
            set vmax to clampv(px / 15, 0.2, 1.0).
        }

        //desired velocity: straight at the waypoint, speed proportional
        //to remaining distance and capped by the stage's limit
        local errvec to (tport:nodeposition + wp) - myport:nodeposition.
        local vcmd to v(0,0,0).
        if errvec:mag > 0.05 {
            set vcmd to errvec:normalized * min(vmax * speedscale, 0.05 + errvec:mag * 0.25).
        }

        local relvel to ship:velocity:orbit - tport:ship:velocity:orbit.

        set pidfore:setpoint to vdot(vcmd, ship:facing:forevector).
        set pidtop:setpoint  to vdot(vcmd, ship:facing:upvector).
        set pidstar:setpoint to vdot(vcmd, ship:facing:rightvector).

        set ship:control:fore      to pidfore:update(time:seconds, vdot(relvel, ship:facing:forevector)).
        set ship:control:top       to pidtop:update(time:seconds, vdot(relvel, ship:facing:upvector)).
        set ship:control:starboard to pidstar:update(time:seconds, vdot(relvel, ship:facing:rightvector)).

        if debug {
            set vd_err to vecdraw(v(0,0,0), errvec, green, "to waypoint", 1, true, 0.1).
            set vd_cmd to vecdraw(v(0,0,0), vcmd * 10, yellow, "cmd vel x10", 1, true, 0.05).
            set vd_axis to vecdraw(tport:nodeposition, fore * 10, red, "port axis", 1, true, 0.1).
        }

        ui_kv("mode", mode, 4).
        ui_bar("approach", max(0, min(1, 1 - px / 50)), round(px, 2) + " m", 5).
        ui_kv("off-axis", round(lateral, 2) + " m", 6).
        ui_kv("closing", round(-vdot(relvel, errvec:normalized), 2) + " m/s", 7).
        ui_kv("speed x", round(speedscale, 2) + "  (UP/DOWN keys)", 8).
        ui_kv("roll", round(rotation) + " deg  (HOME/END keys)", 9).
        ui_kv("rel angle", round(vang(-tport:portfacing:forevector, ship:facing:forevector), 1) + " deg", 10).

        wait 0.05.
    }

    unlock steering.
    set ship:control:neutralize to true.
    clearvecdraws().

    if stop {
        print "--- aborted (AG9) ---".
        sas on.
    } else {
        //magnets have grabbed; hands off and let them pull us in
        print "--- capture! state: " + myport:state + " ---".
        wait 5.
        rcs off.
    }
}

//main starts here: resolve which two ports we are docking
clearvecdraws().
clearscreen.

if not hastarget {
    print "No target. Select a vessel or docking port, then re-run.".
} else if target:istype("DockingPort") {
    local tport to target.
    local myport to firstreadyport(ship, tport:nodetype).
    if myport = 0 { set myport to firstreadyport(ship). }
    if myport = 0 {
        print "No free docking port on this ship!".
    } else {
        autodock(myport, tport).
    }
} else if not target:loaded {
    print "Target not loaded - close to within ~2.5 km first.".
} else {
    local myport to firstreadyport(ship).
    if myport = 0 {
        print "No free docking port on this ship!".
    } else {
        local tport to firstreadyport(target, myport:nodetype).
        if tport = 0 { set tport to firstreadyport(target). }
        if tport = 0 {
            print "No free docking port on " + target:name + "!".
        } else {
            autodock(myport, tport).
        }
    }
}
