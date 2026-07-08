// Filename: rocket_launch.ks
// Description: adaptive gravity-turn launch script.
//throttle forumla from http://forum.kerbalspaceprogram.com/index.php?/topic/116228-kos-calculating-spacecraft-weight/
// Trajectory: a pitchover kick sized to liftoff TWR seeds the turn, then the
// nose rides surface prograde at zero angle of attack while a time-to-apoapsis
// controller (hold eta:apoapsis near eta_target) nudges the pitch within a
// pressure-aware AoA limit. No turn-shape formula - it self-adapts to any TWR.

@LAZYGLOBAL OFF.
parameter tgt_ap is "ask".      // run bare for interactive prompts; pass numbers to skip them
parameter tgt_hd is 90.
parameter liftofftwr is 1.45.   // gentle off the pad, kind to draggy rockets
parameter maxtwr is 2.20.       // once the air thins out, open it up
parameter stopstage is 0.       // never auto-stage past this stage number (protects payload!)

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

//interactive setup when no apoapsis was passed (sequence scripts pass one)
if tgt_ap:istype("String") {
    clearscreen.
    print "=== launch setup (ENTER accepts default) ===".
    set tgt_ap to read_number("Target apoapsis (m)", max(75000, body:atm:height + 10000), 2).
    set tgt_hd to read_number("Heading (deg, 90 = east)", 90, 3).
    set liftofftwr to read_number("Liftoff TWR", 1.45, 4).
    set maxtwr to read_number("Max TWR (upper atmosphere)", 2.20, 5).
    set stopstage to read_number("Auto-stage floor (0 = auto-detect payload)", 0, 6).
}

declare global eta_target to 45.  // seconds-to-apoapsis the ascent controller holds
declare global maxaoa to 3.       // max angle of attack (deg) in thick air - near-zero-AoA turn
declare global thrott to 1.

declare function countdown {
    clearscreen.
    ui_header("LAUNCH: " + ship:name).
    from { local i is 5.} until i = 0 step {set i to i-1.} do {
        ui_kv("target", round(tgt_ap / 1000) + " km @ heading " + tgt_hd, 4).
        ui_kv("t-minus", i + " s", 5).
        wait 1.
    }
    if stage:ready {
        ui_kv("t-minus", "LIFTOFF", 5).
        stage.
    } else {
        clearscreen.
        print "---error--- stage not ready, rebooting...".
        reboot.
    }
}

//one consistent flight readout for every ascent phase
declare function ascent_display {
    parameter phase.
    parameter pitch_now.
    local twr_now to thrott * ship:availablethrust / weight().
    ui_kv("phase", phase, 4).
    ui_kv("altitude", round(altitude / 1000, 1) + " km", 5).
    ui_bar("apoapsis", apoapsis / tgt_ap,
           round(apoapsis / 1000, 1) + " / " + round(tgt_ap / 1000) + " km", 6).
    ui_bar("twr", twr_now / maxtwr,
           round(twr_now, 2) + " (tgt " + round(targettwr, 2) + ")", 7).
    ui_kv("pitch", round(pitch_now) + " deg (prograde " + round(progradepitch()) + ")", 8).
    ui_kv("velocity", round(ship:velocity:surface:mag) + " m/s", 9).
    ui_kv("stage", stage:number, 10).
    ui_kv("apo in", round(eta:apoapsis) + " s  (vspd " + round(verticalspeed) + " m/s)", 11).
}


runoncepath("lib_staging.ks").

declare function asparagus {
    parameter old_maxthrust. //kept for caller compatibility; no longer used
    parameter throttle_set.
    if stage_needed() {
        if safe_to_stage(stopstage) {
            set thrott to 0.
            stage.
            wait 0.5.
            set thrott to throttle_set.
        }
    }

    return ship:availablethrust.
}

// pitch angle of the surface velocity vector above the horizon
declare function progradepitch {
    return 90 - vang(ship:up:vector, ship:srfprograde:vector).
}
//main function begins here!!
//will launch a rocket to the desired apoapsis and heading i hope!

    clearscreen.
    set ship:control:pilotmainthrottle to 0. // make sure throttle is 0 before we start
    sas off.                                 // turn off sas

    runoncepath("lib_physics.ks").

    // TWR schedule: liftofftwr at sea level ramping to maxtwr by 12 km (the cap
    // only exists to tame drag and flip risk in thick air), then FULL THROTTLE
    // above 16 km - throttling in thin air just buys extra gravity losses.
    lock targettwr to liftofftwr + (maxtwr - liftofftwr) * min(1, max(0, altitude / 12000)).
    // weight() from lib_physics returns gravitational force in kN, same units as thrust.
    lock dthrott to choose 1 if altitude > 16000
        else min(1, max(0, (targettwr * weight()) / max(ship:availablethrust, 0.001))).

    //allowed angle of attack: tight (maxaoa) in thick air where flying sideways
    //flips rockets, opening up to ~30 deg as dynamic pressure falls off.
    declare function max_aoa_now {
        return maxaoa + 25 * max(0, min(1, 1 - ship:q / 0.02)).
    }

    //adaptive guidance: ride surface prograde at zero AoA, corrected by a
    //time-to-apoapsis controller. Lofting (eta:apo above target) -> pitch a
    //little below prograde to turn harder; apoapsis closing in (weak stage)
    //-> climb above prograde; sinking -> maximum sustainable climb. Every
    //correction is capped by max_aoa_now, so it can only whisper in thick air.
    declare function guided_pitch {
        local pp is progradepitch().
        local allow is max_aoa_now().
        local corr is 0.
        if verticalspeed < 0 {
            set corr to allow.
        } else if eta:apoapsis > eta_target and apoapsis < tgt_ap {
            set corr to -min(allow, 0.5 * (eta:apoapsis - eta_target)).
        } else if eta:apoapsis < 0.6 * eta_target and altitude > 15000 {
            set corr to min(allow, 0.5 * (0.6 * eta_target - eta:apoapsis)).
        }
        return max(0, min(90, pp + corr)).
    }

    //initial launch
    clearscreen.
    lock throttle to thrott.

    countdown().
    lock steering to up + r(0,0,180).
    local old_maxthrust to ship:availablethrust.
    set thrott to dthrott.

    clearscreen.
    ui_header("ASCENT: " + ship:name).

    //climb straight up only as long as needed - vertical flight is the most
    //expensive part of the ascent, so start the turn as soon as we have airspeed.
    until ship:velocity:surface:mag > 50 and altitude > 250 {
        ascent_display("LIFTOFF", 90).
        set old_maxthrust to asparagus(old_maxthrust, thrott).
        set thrott to dthrott.
        wait 0.1.
    }

    //pitchover kick sized to liftoff TWR: hot rockets kick harder. The kick is
    //held until prograde falls to meet the nose - that seeds the gravity turn.
    local kick to min(12, max(4, 5 + 8 * (liftofftwr - 1.4))).
    local steer_var to 90 - kick.
    lock steering to heading(tgt_hd, steer_var) + r(0,0,-90). // avoid roll with +r(0,0,-90) rocket built default rotation vab

    until progradepitch() <= 90 - kick or altitude > 12000 {
        ascent_display("PITCHOVER " + round(kick) + " DEG", steer_var).
        set old_maxthrust to asparagus(old_maxthrust, thrott).
        set thrott to dthrott.
        wait 0.1.
    }

    until apoapsis > tgt_ap {
        //free to pitch down, rate-limited (~10 deg/s) pitching back up
        set steer_var to min(steer_var + 1, guided_pitch()).
        ascent_display("GRAVITY TURN", steer_var).
        if tgt_ap - apoapsis > 200 {
            set thrott to dthrott.
        } else {
            set thrott to dthrott * .25.
        }
        set old_maxthrust to asparagus(old_maxthrust, thrott).
        wait 0.1.
    }

    set steer_var to 2. //hold directly to horizon + 1 degree.

    until altitude > body:atm:height {
        //track prograde for minimum drag; full rescue guidance if sinking
        if verticalspeed < 0 {
            set steer_var to guided_pitch().
        } else {
            set steer_var to max(2, progradepitch()).
        }
        ascent_display("COAST TO SPACE", steer_var).
        if verticalspeed < 0 {
            set thrott to dthrott. //fell past apoapsis inside the atmosphere - climb!
        } else if apoapsis < (tgt_ap - 25) {
            set thrott to dthrott * .25.
        } else {
            set thrott to 0.
        }
        set old_maxthrust to asparagus(old_maxthrust, thrott).
        wait 0.1.
    }
    ascent_display("ATMOSPHERE CLEAR", steer_var).
    unlock throttle.
    set thrott to 0.
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    sas on.

    runoncepath("deploy_fairings.ks").
    lights on.
    panels on.
    runoncepath("0:/antenna", "extend").
    wait 1.
