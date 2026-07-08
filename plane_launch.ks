// Filename: plane_launch.ks
// Description: jet aircraft takeoff and cruise autopilot. Works with the
// career-tech subsonic jets (Juno/Wheesley) but engine-agnostic: full
// throttle, rotate at Vr, climb to a cruise altitude, then hold altitude/
// heading/speed with live key adjustments until you take over.
// (Old Rapier SSTO version kept as plane_launch_old.ks.)
//
// Usage:
//   run plane_launch.                 interactive prompts
//   run plane_launch(3000, 90, 180).  scripted: 3 km, east, 180 m/s
//
// In cruise: UP/DOWN alt +/-250m, HOME/END heading +/-5, PGUP/PGDN speed
// +/-10, AG9 or DELETE ends the autopilot (leaves you trimmed and flying).

@LAZYGLOBAL OFF.

parameter cruise_alt is "ask".
parameter cruise_hd is 90.
parameter cruise_spd is 180.
parameter vr is 50.             //rotation speed, m/s

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("PLANE LAUNCH: " + ship:name).

if cruise_alt:istype("String") {
    set cruise_alt to read_number("Cruise altitude (m)", 3000, 4).
    set cruise_hd to read_number("Heading (deg)", 90, 5).
    set cruise_spd to read_number("Cruise speed (m/s)", 180, 6).
    set vr to read_number("Rotation speed (m/s)", 50, 7).
}

local pitch_cmd to 0.
local hdg_cmd to 90. //runway heading for the takeoff roll
local thr to 0.

//vertical-speed-to-pitch and speed-to-throttle controllers
local pitchpid to pidloop(1.2, 0.12, 0.8, -10, 20).
local thrpid to pidloop(0.08, 0.02, 0.01, 0, 1).

sas off.
brakes on.
lock throttle to thr.
lock steering to heading(hdg_cmd, pitch_cmd).
stage. //light the engines
set thr to 1.
wait 1.
brakes off.

clearscreen.
ui_header("PLANE LAUNCH: " + ship:name).
ui_kv("phase", "TAKEOFF ROLL", 4).
wait until ship:airspeed > vr.
set pitch_cmd to 10.
ui_kv("phase", "ROTATE", 4).
wait until ship:status = "FLYING" and ship:verticalspeed > 2.
gear off.
ui_kv("phase", "CLIMB", 4).

local stop to false.
on ag9 { set stop to true. }
set hdg_cmd to cruise_hd.

until stop {
    if terminal:input:haschar {
        local ch to terminal:input:getchar().
        if ch = terminal:input:UPCURSORONE       { set cruise_alt to cruise_alt + 250. }
        if ch = terminal:input:DOWNCURSORONE     { set cruise_alt to max(500, cruise_alt - 250). }
        if ch = terminal:input:HOMECURSOR        { set cruise_hd to mod(cruise_hd + 355, 360). }
        if ch = terminal:input:ENDCURSOR         { set cruise_hd to mod(cruise_hd + 5, 360). }
        if ch = terminal:input:PAGEUPCURSOR      { set cruise_spd to cruise_spd + 10. }
        if ch = terminal:input:PAGEDOWNCURSOR    { set cruise_spd to max(60, cruise_spd - 10). }
        if ch = terminal:input:DELETERIGHTCURSOR { set stop to true. }
    }
    set hdg_cmd to cruise_hd.

    //altitude -> vertical speed target -> pitch, gentle near the setpoint
    local vs_tgt to max(-15, min(15, (cruise_alt - altitude) / 10)).
    set pitchpid:setpoint to vs_tgt.
    set pitch_cmd to pitchpid:update(time:seconds, ship:verticalspeed).

    set thrpid:setpoint to cruise_spd.
    set thr to thrpid:update(time:seconds, ship:airspeed).

    local phase to "CRUISE".
    if abs(cruise_alt - altitude) > 200 {
        set phase to choose "CLIMB" if cruise_alt > altitude else "DESCEND".
    }
    ui_kv("phase", phase + "  (AG9/DEL to end)", 4).
    ui_kv("altitude", round(altitude) + " -> " + round(cruise_alt) + " m", 5).
    ui_kv("heading", round(cruise_hd) + " deg (HOME/END)", 6).
    ui_kv("speed", round(ship:airspeed) + " -> " + round(cruise_spd) + " m/s (PGUP/PGDN)", 7).
    ui_kv("vspeed", round(ship:verticalspeed, 1) + " m/s", 8).
    wait 0.05.
}

//hand back a trimmed, flying aircraft
unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to thr.
sas on.
ui_kv("phase", "autopilot off - your aircraft", 4).
