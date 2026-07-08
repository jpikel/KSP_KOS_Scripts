//Filename: planeland.ks
//Description: automatic landing on the KSC runway (09, landing eastward).
//From anywhere flying around Kerbin: navigates to an approach fix ~25 km west
//of the runway, descends a 5-degree glideslope down the centerline, flares,
//touches down, and brakes to a stop.
//EXPERIMENTAL: if ORBITING/SUB_ORBITAL (future spaceplanes), it first flies a
//deorbit + reentry phase: retro burn timed for KSC, then a nose-high attitude
//hold through entry until the air is thick and slow enough to fly normally.
//
// Usage: run planeland.
// Abort anytime with AG9 (autopilot releases, SAS on).

@LAZYGLOBAL OFF.

runoncepath("lib_ui.ks").

clearscreen.
ui_header("AUTOLAND: KSC RUNWAY 09").

local t0 to time:seconds.
local log_file to "0:/planeland_log.csv".
if exists(log_file) { deletepath(log_file). }
log "met,phase,alt,alt_radar,q,airspeed,vspeed,pitch_cmd,aoa,fpa,thr,dist_rwy" to log_file.
local last_log_t to 0.

declare function log_flight {
    parameter phase.
    parameter dist.
    local fpa to 90 - vang(ship:up:vector, ship:srfprograde:vector).
    local aoa to 0.
    if ship:airspeed > 1 {
        set aoa to vang(ship:facing:vector, ship:srfprograde:vector).
    }
    local met to round(time:seconds - t0).
    log met + "," + phase + "," + round(altitude) + "," + round(alt:radar) + "," + round(ship:q, 4) + "," + round(ship:airspeed) + "," + round(ship:verticalspeed, 1) + "," + round(pitch_cmd, 1) + "," + round(aoa, 1) + "," + round(fpa, 1) + "," + round(thr, 2) + "," + round(dist) to log_file.
}

//KSC runway 09: threshold at the WEST end, landing heading ~090
local rwy to latlng(-0.0486, -74.7245).
local rwy_alt to 70.
local fix to latlng(-0.0486, -77.1).   //~25 km west, straight-in
local fix_alt to 3000.

local stop to false.
on ag9 { set stop to true. }

local pitch_cmd to 0.
local hdg_cmd to 90.
local thr to 0.
local pitchpid to pidloop(1.2, 0.12, 0.8, -12, 18).
// Significantly reduced Kp and Ki to smooth out the throttle during cruise
local thrpid to pidloop(0.02, 0.005, 0.01, 0, 1).

declare function fly_tick {
    parameter alt_tgt.
    parameter spd_tgt.
    parameter vs_floor.
    local vs_tgt to max(vs_floor, min(12, (alt_tgt - altitude) / 10)).
    set pitchpid:setpoint to vs_tgt.
    set pitch_cmd to pitchpid:update(time:seconds, ship:verticalspeed).
    set thrpid:setpoint to spd_tgt.
    set thr to thrpid:update(time:seconds, ship:airspeed).
}

declare function show {
    parameter phase.
    parameter dist.
    ui_kv("phase", phase + "  (AG9 aborts)", 4).
    ui_kv("distance", round(dist / 1000, 1) + " km", 5).
    ui_kv("altitude", round(altitude) + " m", 6).
    ui_kv("speed", round(ship:airspeed) + " m/s  vs " + round(ship:verticalspeed, 1), 7).
    
    if time:seconds > last_log_t + 1 {
        log_flight(phase, dist).
        set last_log_t to time:seconds.
    }
}

sas off.
lock throttle to thr.
lock steering to heading(hdg_cmd, pitch_cmd).

//----- EXPERIMENTAL: deorbit + entry for spaceplanes -----
if ship:status = "ORBITING" {
    ui_kv("phase", "DEORBIT (experimental)", 4).
    //burn retro roughly 115 deg of longitude before KSC
    local burn_lng to -74.5 - 115.
    if burn_lng < -180 { set burn_lng to burn_lng + 360. }
    until abs(ship:geoposition:lng - burn_lng) < 2 or stop {
        ui_kv("status", "waiting for deorbit point (lng " + round(burn_lng) + ")", 8).
        if warp = 0 { set warp to 3. }
        wait 0.5.
    }
    set warp to 0.
    wait until ship:unpacked.
    lock steering to lookdirup(-ship:velocity:orbit, up:vector).
    wait until vang(ship:facing:forevector, -ship:velocity:orbit) < 5 or stop.
    until ship:periapsis < 28000 or stop {
        set thr to 1.
        show("DEORBIT BURN", rwy:distance).
        wait 0.05.
    }
    set thr to 0.
}
if (ship:status = "SUB_ORBITAL" or altitude > 25000) and not stop {
    //nose-high entry hold: bleed speed high in the atmosphere
    ui_kv("phase", "REENTRY HOLD (experimental)", 4).
    lock steering to heading(rwy:heading, min(30, max(0, 90 - vang(up:vector, srfprograde:vector) + 12))).
    until (altitude < 20000 and ship:airspeed < 900) or stop {
        show("REENTRY HOLD", rwy:distance).
        wait 0.2.
    }
    lock steering to heading(hdg_cmd, pitch_cmd).
}

//----- NAVIGATE to the approach fix -----
until fix:distance < 4000 or rwy:distance < 20000 or stop {
    set hdg_cmd to fix:heading.
    fly_tick(fix_alt, 200, -15).
    show("TO APPROACH FIX", fix:distance).
    wait 0.05.
}

//----- FINAL: 5-degree glideslope to the threshold -----
until alt:radar < 25 or stop {
    set hdg_cmd to rwy:heading.
    local gs_alt to rwy_alt + rwy:distance * 0.0875. //tan(5 deg)
    local spd to max(75, min(150, rwy:distance / 200)).
    fly_tick(min(fix_alt, gs_alt), spd, -12).
    gear on.
    show("FINAL APPROACH", rwy:distance).
    wait 0.05.
}

//----- FLARE and touchdown -----
until ship:status = "LANDED" or stop {
    set hdg_cmd to 90.
    set thr to 0.
    set pitchpid:setpoint to -1.5.
    set pitch_cmd to max(2, pitchpid:update(time:seconds, ship:verticalspeed)).
    show("FLARE", rwy:distance).
    wait 0.05.
}

//----- ROLLOUT -----
brakes on.
set thr to 0.
until ship:groundspeed < 1 or stop {
    set pitch_cmd to 0.
    set hdg_cmd to 90.
    show("ROLLOUT - braking", rwy:distance).
    wait 0.1.
}

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
sas on.
if stop {
    ui_kv("phase", "ABORTED - your aircraft", 4).
} else {
    ui_kv("phase", "WELCOME HOME - full stop", 4).
}
