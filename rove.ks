// Filename: rove.ks
// Description: rover cruise autopilot - hold a speed and heading, or drive
// to a career waypoint (survey markers etc). Bearing/distance come from kOS
// geoposition natively (the old hand-rolled spherical trig is gone, along
// with its radians-into-degree-trig bug and the cost() typo).
//
// Usage:
//   run rove.                 interactive (speed, then heading or waypoint)
//   run rove(8, 270).         scripted: 8 m/s due west
//   run rove(8, -1, "Site A"). scripted: 8 m/s to the named waypoint
//
// Driving keys: PGUP/PGDN speed +/-1, HOME/END heading +/-5 (heading mode),
// DELETE or AG9 stops (brakes on).

@LAZYGLOBAL OFF.

parameter tspeed is "ask".
parameter thead is -1.      // -1 = hold current heading
parameter wname is "".      // waypoint name ("" = none)

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("ROVER: " + ship:name).

declare function norm180 {
    parameter a.
    set a to mod(a, 360).
    if a > 180 { set a to a - 360. }
    if a < -180 { set a to a + 360. }
    return a.
}

local northpole to latlng(90, 0).
declare function myheading {
    return mod(360 - northpole:bearing, 360).
}

//----- setup -----
local wp to 0. //waypoint geoposition, or 0

if tspeed:istype("String") {
    set tspeed to read_number("Cruise speed (m/s)", 8, 4).
    local opts to list("hold current heading", "enter a heading").
    local wps to list().
    for w in allwaypoints() {
        if w:body = body and wps:length < 7 {
            wps:add(w).
            opts:add("waypoint: " + w:name).
        }
    }
    local c to read_menu("Drive where?", opts, 6).
    if c = 1 {
        set thead to read_number("Heading (deg)", round(myheading()), 6 + opts:length + 1).
    } else if c >= 2 {
        set wp to wps[c - 2]:geoposition.
    }
} else if wname <> "" {
    for w in allwaypoints() {
        if w:body = body and w:name = wname {
            set wp to w:geoposition.
        }
    }
    if wp = 0 {
        print "Waypoint '" + wname + "' not found on " + body:name + ".".
    }
}

if not (wname <> "" and wp = 0) {
    if thead < 0 {
        set thead to round(myheading()).
    }

    local stop to false.
    on ag9 { set stop to true. }
    sas off.
    brakes off.

    local drive to pidloop(1, 2, 0.25, -1, 1).
    set drive:setpoint to tspeed.
    //steer on the WRAPPED heading error (setpoint 0) so 359->1 deg is a
    //2-degree nudge, not a 358-degree wrong-way lock
    local steer to pidloop(0.05, 0.001, 0.15, -1, 1).
    set steer:setpoint to 0.

    local t0 to time:seconds.
    until stop {
        if terminal:input:haschar {
            local ch to terminal:input:getchar().
            if ch = terminal:input:PAGEUPCURSOR        { set tspeed to tspeed + 1. set drive:setpoint to tspeed. }
            if ch = terminal:input:PAGEDOWNCURSOR      { set tspeed to max(1, tspeed - 1). set drive:setpoint to tspeed. }
            if ch = terminal:input:HOMECURSOR and wp = 0 { set thead to mod(thead + 355, 360). }
            if ch = terminal:input:ENDCURSOR and wp = 0  { set thead to mod(thead + 5, 360). }
            if ch = terminal:input:DELETERIGHTCURSOR   { set stop to true. }
        }

        if not wp:istype("Scalar") {
            set thead to wp:heading. //bearing to the waypoint, native kOS
            if wp:distance < 15 {
                ui_kv("status", "ARRIVED at waypoint", 8).
                set stop to true.
            }
        }

        set ship:control:wheelthrottle to drive:update(time:seconds, ship:groundspeed).
        set ship:control:wheelsteer to -steer:update(time:seconds, norm180(myheading() - thead)).

        ui_kv("speed", round(ship:groundspeed, 1) + " -> " + tspeed + " m/s (PGUP/PGDN)", 4).
        ui_kv("heading", round(myheading()) + " -> " + round(thead) + " deg", 5).
        if not wp:istype("Scalar") {
            ui_kv("waypoint", round(wp:distance / 1000, 2) + " km", 6).
        }
        ui_kv("slope", round(90 - vang(up:vector, ship:facing:topvector), 1) + " deg", 7).
        wait 0.05.
    }

    set ship:control:wheelthrottle to 0.
    set ship:control:wheelsteer to 0.
    set ship:control:neutralize to true.
    brakes on.
    sas on.
    ui_kv("status", "stopped, brakes on - drove " + ui_time(time:seconds - t0), 9).
}
