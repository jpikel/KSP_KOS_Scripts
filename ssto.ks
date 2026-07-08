//Filename: ssto.ks
//Description: single-stage-to-orbit ascent for RAPIER spaceplanes.
//Phases: takeoff -> climb -> SPEEDRUN (hold altitude, build speed on air-
//breathers until they plateau) -> mode switch to closed cycle -> rocket
//pitch-up to apoapsis -> coast out of atmosphere -> circularize (circat+node).
//Come home later with planeland. AG9 aborts to manual at any point.
//
// Usage:
//   run ssto.                     interactive prompts
//   run ssto(80000, 90).          scripted, defaults for the rest
//
// Design assumptions: stable plane (CoL behind wet AND dry CoM), thrust line
// through CoM, enough oxidizer for ~1400 m/s of closed-cycle burn.

@LAZYGLOBAL OFF.

parameter tgt_ap is "ask".
parameter hd is 90.
parameter run_alt is 12000.     //altitude to level off at, then speed-run on jets
parameter vr is 80.             //rotation speed
parameter rocket_pitch is 35.   //MAX pitch for the closed-cycle climb (adaptive below)

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
runoncepath("flightlog.ks").

clearscreen.
ui_header("SSTO ASCENT: " + ship:name).

if tgt_ap:istype("String") {
    set tgt_ap to read_number("Target apoapsis (m)", max(80000, body:atm:height + 10000), 4).
    set hd to read_number("Heading (deg)", 90, 5).
    set run_alt to read_number("Level-off altitude for speed run (m)", 12000, 6).
    set vr to read_number("Rotation speed (m/s)", 80, 7).
    set rocket_pitch to read_number("Max rocket pitch (deg, adaptive)", 35, 8).
}

//hottest part temperature ratio on the ship. kOS Part exposes only INTERNAL
//temperature (:temperature / :maxtemp), which lags the skin's aero heating -
//so the trigger threshold below is set conservatively low to compensate.
//Sampled periodically; iterating all parts every tick is expensive.
declare function hot_ratio {
    local worst to 0.
    for p in ship:parts {
        //hassuffix guard: kOS suffix names vary by version, and a wrong name
        //should DISABLE the watchdog (return 0), never crash the ascent
        if p:hassuffix("MAXTEMPERATURE") and p:hassuffix("TEMPERATURE")
           and p:maxtemperature > 0 {
            local r to p:temperature / p:maxtemperature.
            if r > worst {
                set worst to r.
            }
        }
    }
    return worst.
}

//close every air intake - once on closed cycle they are pure drag (and drag
//is heat). Guarded event lookup; only closes, never reopens.
declare function close_intakes {
    local n to 0.
    for p in ship:parts {
        if p:hasmodule("ModuleResourceIntake") {
            local m to p:getmodule("ModuleResourceIntake").
            if m:hasevent("close intake") {
                m:doevent("close intake").
                set n to n + 1.
            } else if m:hasevent("close") {
                m:doevent("close").
                set n to n + 1.
            }
        }
    }
    return n.
}

//true if any multi-mode engine (RAPIER) has flamed out - i.e. run out of air
//in air-breathing mode. This is the definitive "switch now" signal.
declare function air_flamed_out {
    for p in ship:parts {
        if p:hasmodule("MultiModeEngine") and p:hassuffix("FLAMEOUT") and p:flameout {
            return true.
        }
    }
    return false.
}

//switch every RAPIER that is STILL in air-breathing mode to closed cycle.
//Mode-aware: reads the module's mode field so we don't fight the RAPIER's
//own auto-switch (toggling an already-closed engine back to air = flameout
//loop). Falls back to a blind toggle if the mode field can't be read.
declare function switch_modes {
    local n to 0.
    for p in ship:parts {
        if p:hasmodule("MultiModeEngine") {
            local m to p:getmodule("MultiModeEngine").
            local is_air to true. //assume air-breathing if we can't tell
            if m:hasfield("mode") {
                local md to m:getfield("mode").
                set is_air to md:contains("Air") or md:contains("air").
            }
            if is_air {
                if m:hasevent("toggle mode") {
                    m:doevent("toggle mode").
                    set n to n + 1.
                } else if m:hasevent("switch mode") {
                    m:doevent("switch mode").
                    set n to n + 1.
                }
            }
        }
    }
    return n.
}

//----- flight data recorder -----
declare function res {
    parameter nm.
    local a to 0.
    for r in ship:resources {
        if r:name = nm {
            set a to a + r:amount.
        }
    }
    return a.
}
declare global ssto_log_t to 0.
local prev_LF to ship:liquidfuel.
local prev_Ox to ship:oxidizer.
local prev_log_t to time:seconds.

if exists("0:/ssto_log.csv") {
    deletepath("0:/ssto_log.csv").
}
log "met,phase,alt,q,airspeed,vspeed,pitchAOH,throttle,thrust,LF,Ox,intakeAir,cmdpitch,aoa,fpa,vs_tgt,iterm,LF_rate,Ox_rate"
    to "0:/ssto_log.csv".

local stop to false.
on ag9 { set stop to true. }

//pitch_cmd is global so the display can show the commanded ("desired") pitch;
//g_* hold a smoothed airspeed acceleration for the display and path verdict.
global pitch_cmd to 0.
global g_accel to 0.
global g_as_prev to 0.
global g_as_t to 0.
//pitch-loop diagnostics (set each tick, logged by show() - globals dodge kOS
//function scoping the same way pitch_cmd does): the vspeed the loop is CHASING
//and the PID integral term, so a limit cycle / windup is visible in the log.
global g_vs_tgt to 0.
global g_iterm to 0.
//low-pass-filtered vertical speed + its last-sample time. The pitch loop feeds
//on THIS, not raw verticalspeed, so it stops chasing (and pumping) the airframe's
//fast ~3-4 s short-period pitch wiggle.
global g_vs_filt to 0.
global g_vs_ft to 0.
local hdg_cmd to 90.
local thr to 1.
local pitchpid to 0. // Unused, kept to avoid breaking external dependencies if any
local dv0 to ship:deltav:vacuum.
local t0 to time:seconds.

sas off.
//gentler steering: a rear-heavy / marginally-stable plane porpoises if the
//autopilot snaps at it. Larger maxstoppingtime = softer commands, which stops
//the script EXCITING a pitch oscillation. This is a band-aid for a marginal
//airframe - the real fix is CoM ahead of CoL (wet AND dry). Ignored harmlessly
//if the plane is well-balanced.
set steeringmanager:maxstoppingtime to 3.
brakes on.
lock throttle to thr.
lock steering to heading(hdg_cmd, pitch_cmd).
stage. //light the engines
wait 1.
brakes off.

clearscreen.
ui_header("SSTO ASCENT: " + ship:name).

//plain-language read on whether the trajectory looks healthy right now
declare function path_verdict {
    parameter aoa.
    if ship:availablethrust < 1 and altitude < body:atm:height {
        return "no thrust - flameout / staging?".
    }
    if ship:q > 6 {
        return "BAD: high q - drag & heat, climb out".
    }
    if aoa > 8 {
        return "BAD: high AoA - fighting the airstream".
    }
    if ship:verticalspeed < -8 and altitude < body:atm:height {
        return "WARN: sinking".
    }
    if g_accel < 1.5 and ship:airspeed > 700 and altitude < body:atm:height {
        return "WARN: not accelerating - near ceiling".
    }
    return "on profile - good".
}

declare function show {
    parameter phase.
    //smoothed acceleration over ~1 s (for the readout and the verdict)
    if time:seconds > g_as_t + 1 {
        set g_accel to (ship:airspeed - g_as_prev) / max(0.1, time:seconds - g_as_t).
        set g_as_prev to ship:airspeed.
        set g_as_t to time:seconds.
    }
    //nose pitch, flight-path angle (where velocity points), angle of attack
    local aoh to 90 - vang(ship:up:vector, ship:facing:forevector).
    local fpa to 90 - vang(ship:up:vector, ship:srfprograde:vector).
    local aoa to vang(ship:facing:forevector, ship:srfprograde:vector).

    ui_kv("phase", phase + "  (AG9 = manual)", 4).
    ui_kv("alt / vspd", round(altitude) + " m / " + round(ship:verticalspeed) + " m/s", 5).
    ui_kv("airspeed", round(ship:airspeed) + " m/s  (accel " + round(g_accel, 1) + ")", 6).
    ui_kv("apoapsis", round(apoapsis / 1000, 1) + " / " + round(tgt_ap / 1000) + " km", 7).
    ui_kv("pitch", "cmd " + round(pitch_cmd) + " / nose " + round(aoh)
          + " / path " + round(fpa), 8).
    //line 9 belongs to the phase logic (corridor / punch / heat status)
    ui_kv("AoA / q", round(aoa, 1) + " deg / " + round(ship:q, 2)
          + (choose "  HIGH!" if ship:q > 5 else ""), 10).
    ui_kv("thrust/air", round(ship:availablethrust) + " kN / air "
          + round(res("IntakeAir"), 2), 11).
    ui_kv("LF / Ox", round(res("LiquidFuel")) + " / " + round(res("Oxidizer")), 12).
    ui_kv("PATH", path_verdict(aoa), 13).

    //flight data recorder: one row per second (global-scope values only)
    if time:seconds > ssto_log_t + 1 {
        set ssto_log_t to time:seconds.
        
        local lf_burn_rate to (prev_LF - res("LiquidFuel")) / max(0.001, time:seconds - prev_log_t).
        local ox_burn_rate to (prev_Ox - res("Oxidizer")) / max(0.001, time:seconds - prev_log_t).
        set prev_LF to res("LiquidFuel").
        set prev_Ox to res("Oxidizer").
        set prev_log_t to time:seconds.
        
        log round(missiontime) + "," + phase + "," + round(altitude) + ","
            + round(ship:q, 4) + "," + round(ship:airspeed) + ","
            + round(ship:verticalspeed, 1) + ","
            + round(aoh, 1) + ","
            + round(throttle, 2) + "," + round(ship:availablethrust) + ","
            + round(res("LiquidFuel")) + "," + round(res("Oxidizer")) + ","
            + round(res("IntakeAir"), 2) + ","
            + round(pitch_cmd, 1) + "," + round(aoa, 1) + "," + round(fpa, 1) + ","
            + round(g_vs_tgt, 1) + "," + round(g_iterm, 2) + ","
            + round(lf_burn_rate, 2) + "," + round(ox_burn_rate, 2)
            to "0:/ssto_log.csv".
    }
}

//----- takeoff roll: nose down, accelerate to the minimum rotation speed -----
until ship:airspeed > vr or stop {
    set pitch_cmd to 0.
    show("TAKEOFF ROLL").
    wait 0.05.
}
//----- rotate, but CONFIRM the plane can actually fly before committing.
//With too little wing a plane lifts off at Vr yet can't climb - it balloons
//up, mushes, and glides back into the ground. So ease the nose up gently and
//only retract gear / start the climb once we have SUSTAINED climb (vspeed > 2
//for ~1.5 s) with a speed margin over Vr. If it starts sinking, it rotated
//too early: lower the nose and keep building speed on the runway. This
//auto-finds the real takeoff speed for whatever wing area the plane has.
set pitch_cmd to 6.
local climb_t to time:seconds.
local committed to false.
until committed or stop {
    if ship:verticalspeed < 1 {
        set climb_t to time:seconds.   //not climbing - restart the timer
        if ship:verticalspeed < -1 and pitch_cmd > 2 {
            set pitch_cmd to pitch_cmd - 0.5.   //sinking: lower nose, build speed
        } else if pitch_cmd < 10 {
            set pitch_cmd to pitch_cmd + 0.15.
        }
    } else if pitch_cmd < 12 {
        set pitch_cmd to pitch_cmd + 0.2.
    }
    if ship:status = "FLYING" and ship:verticalspeed > 2
       and ship:airspeed > vr + 15 and time:seconds > climb_t + 1.5 {
        set committed to true.
    }
    show("ROTATE / BUILDING SPEED").
    wait 0.05.
}
gear off.
set hdg_cmd to hd.

//----- AIRBREATHING ASCENT: one adaptive corridor -----
//The old climb phase held a vertical speed with no opinion about airspeed,
//so hot planes hit 1500 m/s in thick air. Now: a HEAT FLOOR - the minimum
//safe altitude for the current airspeed - rises as we accelerate, and the
//plane rides it up. An extremum seeker tunes how far ABOVE the floor to fly
//for best acceleration. Switch to closed cycle when airspeed plateaus.
//heat floor: minimum safe altitude for the current airspeed. The old slope
//(9 m/m/s) put the floor at 16.6 km by 1466 m/s and forced a steep climb at
//the top of airbreathing (314 m/s vertical!) that drained oxidizer. Flight
//data showed q was already well past its peak and falling there, so a gentler
//slope keeps the plane lower, flatter, and faster - it enters the rocket
//phase with far less vertical speed to bleed off. Watchdog still backstops.
declare function alt_floor {
    return max(1500, 6500 + (ship:airspeed - 400) * 6).
}
local seek_off to 800.  //meters above the floor; self-tunes 0..5000
local vmax to ship:airspeed.
local t_gain to time:seconds.
local win_v0 to ship:airspeed.
local win_t0 to time:seconds.
local last_acc to 0.
local nudge to 1.
local hot to 0.
local hot_t to time:seconds.
//AIRBREATHING PROFILE (classic SSTO): climb to run_alt, then hold it LEVEL and
//let the jets build speed. Level flight keeps angle of attack near 0 - low
//drag, and the nose cone takes clean head-on airflow instead of the angled
//battering that cooked it. Switch to rockets on a jet plateau, a flameout, OR
//when heat closes in (high q or rising part temp) - "fly straight until the
//thermal gets close, then column up on rockets".
local vmax_ref to ship:airspeed.
local vmax_ref_t to time:seconds.
local jets_done to false.
local heat_close to false.
//cap the level speed-run at 1550 m/s. Flight data (low-and-fast profile) showed
//the old 1400 cap forced the switch while q was only ~0.8 atm and the jets were
//still making ~400 kN - i.e. heat was NOT the limiter, the cap was. Every extra
//m/s on jets is free LF; every m/s on rockets costs scarce Ox. So milk the jets
//higher (heat_close/jets_done still cut it short if genuinely overheating or
//plateaued) to leave more oxidizer for circularization.
until stop or air_flamed_out() or jets_done or heat_close
      or (altitude > run_alt - 500 and ship:airspeed > 1550) {
    //sample the hottest part temp once per 0.5 s (used here and by the watchdog)
    if time:seconds > hot_t + 0.5 {
        set hot to hot_ratio().
        set hot_t to time:seconds.
    }
    //jets plateaued? peak speed gaining < 10 m/s per 10 s past 1350 m/s.
    if time:seconds > vmax_ref_t + 10 {
        if vmax > 1350 and vmax - vmax_ref < 10 {
            set jets_done to true.
        }
        set vmax_ref to vmax.
        set vmax_ref_t to time:seconds.
    }
    //heat is a SAFETY cutout, NOT the normal switch.
    if hot > 0.85 or ship:q > 8 {
        set heat_close to true.
    }

    local current_twr to ship:availablethrust / max(0.001, ship:mass * 9.81).
    local base_pitch to max(8, min(25, current_twr * 10)). 
    
    local pitch_target to base_pitch.
    if altitude < 9000 {
        // Hold steep initial climb out of the thickest lower atmosphere
        set pitch_target to base_pitch.
    } else if altitude < 15000 {
        // Smoothly blend down to 12 degrees by 15km
        set pitch_target to base_pitch - ((altitude - 9000) / 6000) * (base_pitch - 12).
    } else {
        // Speed run: 12 degrees gently down to 5 degrees by 23km
        set pitch_target to max(5, 12 - ((altitude - 15000) / 8000) * 7).
    }
    
    // Override if we are losing altitude or heating up too fast
    local q_limit to 3.5. // Safe dynamic pressure limit
    local max_safe_speed to 10000. // Uncapped above 16km
    if altitude < 16000 {
        // Keep it much slower down low: ~1100 m/s at 10km, ~1340 m/s at 16km
        set max_safe_speed to 700 + (altitude / 1000) * 40.
    }
    
    if ship:q > q_limit {
        // Linearly throttle back as we exceed safe Q (e.g., if q=4.5, thr=0.5)
        set thr to max(0.1, 1.0 - (ship:q - q_limit) * 0.5).
        ui_kv("adaptive", "HIGH Q: Throttling to " + round(thr * 100) + "% (q=" + round(ship:q, 2) + ")", 9).
    } else if ship:airspeed > max_safe_speed {
        set thr to max(0.05, 1.0 - (ship:airspeed - max_safe_speed) * 0.02).
        ui_kv("adaptive", "THERMAL LIMIT: Throttling (Speed " + round(ship:airspeed) + " > " + round(max_safe_speed) + ")", 9).
    } else if hot > 0.75 {
        set pitch_target to max(pitch_target, 20).
        set thr to 0.4.
        ui_kv("adaptive", "HEAT " + round(hot * 100) + "% - climbing out / throttling down", 9).
    } else {
        set thr to 1.
        ui_kv("adaptive", "TWR " + round(current_twr, 1) + " Pitch Curve  q " + round(ship:q, 2), 9).
    }
    
    // Transonic AoA Limiter: Prevent the plane from aerodynamically flipping backwards
    // when crossing the sound barrier by capping how far the nose can pull above prograde.
    // 8 degrees was still too much at Mach 1.5. Clamping to 4 degrees.
    local ppitch to 90 - vang(ship:up:vector, ship:srfprograde:vector).
    if pitch_target > ppitch + 4 {
        set pitch_target to ppitch + 4.
        ui_kv("adaptive", "AoA LIMITER ACTIVE (Pitch capped to " + round(pitch_target, 1) + ")", 9).
    }

    // Slew pitch smoothly (0.2 deg per tick = 4 deg per sec) to prevent snapping
    set pitch_cmd to pitch_cmd + max(-0.2, min(0.2, pitch_target - pitch_cmd)).
    
    if ship:airspeed > vmax + 0.4 {
        set vmax to ship:airspeed.
        set t_gain to time:seconds.
    }
    
    show("AIR ASCENT (peak " + round(vmax) + " m/s)").
    wait 0.05.
}

//----- switch to closed cycle and climb out -----
if not stop {
    local nsw to switch_modes().
    wait 0.7. //let the mode change settle
    //verify: if we have no thrust available, the switch went the wrong way
    //(or the RAPIER auto-switched and our toggle undid it) - correct it once
    if ship:availablethrust < 1 {
        set nsw to nsw + switch_modes().
        wait 0.7.
    }
    
    // If we STILL have no thrust after toggling modes, the craft likely uses 
    // separate rocket engines (like NERVs) that need to be staged.
    if ship:availablethrust < 1 {
        stage.
        wait 0.7.
        ui_kv("engines", "Staged separate rocket engines", 9).
    } else if nsw > 0 {
        ui_kv("engines", nsw + " RAPIER switch(es), thrust "
              + round(ship:availablethrust) + " kN", 9).
    } else {
        ui_kv("engines", "already closed cycle (auto-switched)", 9).
    }
    //intakes are now dead weight and drag - close them
    local nic to close_intakes().
    if nic > 0 {
        ui_kv("intakes", nic + " closed (drag reduction)", 10).
    }
    lock steering to heading(hdg_cmd, pitch_cmd).
}
//adaptive rocket climb: fly NEAR PROGRADE (minimum gravity/AoA loss), pitching
//above it only enough to keep time-to-apoapsis ~30 s. The old fixed-12-deg
//base climbed too steeply at 1460 m/s and burned all the oxidizer on altitude
//instead of orbital speed. Prograde-relative keeps it flat and accelerating.
local drag_loss_est to 0.
until apoapsis >= tgt_ap + drag_loss_est or stop {
    // Dynamically estimate how much apoapsis will be lost to drag during the coast.
    // The lower we are when the rockets cut out, the more drag we will suffer.
    // Increased the multiplier to 0.20 (drag loss > 2500m observed on this airframe).
    set drag_loss_est to max(0, (65000 - altitude) * 0.20).

    local ppitch to 90 - vang(ship:up:vector, ship:srfprograde:vector).
    
    // Lock throttle to 100% for maximum efficiency (minimize gravity drag)
    set thr to 1.0.

    // Manage Apoapsis using Pitch instead of Throttle
    // Limit AoA drag: gently pull nose relative to prograde instead of yanking to 25 deg
    local ptarget to 25.
    if eta:apoapsis > 60 {
        // Apoapsis is running away, gently push nose down to flatten out
        set ptarget to ppitch - 2. 
        ui_kv("adaptive", "PITCH DOWN: eta:ap > 60s", 9).
    } else if eta:apoapsis < 45 {
        // Need to climb, pull nose up enough to fight gravity, but prevent massive air-braking
        // 20 degrees caused too much drag at 25km. Clamping to 10 degrees.
        set ptarget to ppitch + 10.
        ui_kv("adaptive", "PITCH UP: eta:ap < 45s", 9).
    } else {
        // Maintain a slight climb
        set ptarget to ppitch + 5.
        ui_kv("adaptive", "PITCH HOLD: eta:ap stable", 9).
    }
    
    // Hard floor and ceiling so we don't dive or flip
    set ptarget to max(5, min(35, ptarget)).
    
    // Gently slew the pitch command so we don't yank the nose
    set pitch_cmd to pitch_cmd + max(-0.2, min(0.2, ptarget - pitch_cmd)).

    // Hard limit near target
    if (tgt_ap + drag_loss_est) - apoapsis < 2000 {
        set thr to min(thr, 0.2).
    }
    
    // ui_kv for adaptive is already handled in the pitch logic above, so we just show climb status
    ui_kv("orbit info", "apo in " + round(eta:apoapsis) + "s  prograde "
          + round(ppitch) + " -> pitch " + round(pitch_cmd), 9).
    show("ROCKET CLIMB").
    wait 0.05.
}
set thr to 0.

//----- coast out, keeping the apoapsis alive against drag -----
if not stop {
    lock steering to lookdirup(ship:prograde:vector, ship:facing:topvector).
}
until altitude > 70000 or stop {
    if apoapsis < tgt_ap - 50 {
        set thr to max(0.1, min(1.0, (tgt_ap - apoapsis) / 200)).
    } else {
        set thr to 0.
    }
    ui_kv("adaptive", "Coasting... dV left: " + round(ship:deltav:vacuum) + " m/s", 9).
    show("COAST TO SPACE").
    wait 0.05.
}
set thr to 0.

if stop {
    unlock throttle.
    unlock steering.
    set ship:control:pilotmainthrottle to 0.
    sas on.
    ui_kv("phase", "ABORTED - your aircraft", 4).
} else {
    //----- circularize with the proven chain -----
    ui_kv("phase", "CIRCULARIZING", 4).
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    runpath("0:/circat", "ap").
    runpath("0:/node").

    clearscreen.
    ui_header("SSTO IN ORBIT: " + ship:name).
    ui_kv("orbit", round(apoapsis / 1000, 1) + " x " + round(periapsis / 1000, 1) + " km", 4).
    ui_kv("dv to orbit", round(dv0 - ship:deltav:vacuum) + " m/s", 5).
    ui_kv("dv remaining", round(ship:deltav:vacuum) + " m/s", 6).
    ui_kv("oxidizer", "watch this - it is the SSTO currency", 7).
    log_flight(dv0 - ship:deltav:vacuum, time:seconds - t0, 0, 0).
    print "home later: run planeland (deorbit + KSC autoland)" at (0, 9).
}
