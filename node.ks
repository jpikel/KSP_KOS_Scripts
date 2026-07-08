// Filename: node.ks
// Description: a short script that executes a maneuver node.  Based on the
// tutorial presented on the KOS Documentation page.
// https://ksp-kos.github.io/KOS/tutorials.html
// Dependency: requires the file lib_physics.ks to be in the same directory

@LAZYGLOBAL OFF.
CLEARSCREEN.
//calculates the time required for the deltaV set by the maneuver node.
//https://www.reddit.com/r/Kos/comments/4568p2/executing_maneuver_nodes_figuring_out_the_rocket/
run lib_physics.ks.
runoncepath("lib_staging.ks").
runoncepath("lib_ui.ks").

declare global nd_total_dv to 0. //full node dv, for the burn progress bar
declare function calc_time {
    parameter nd.
    local myengines to list().
    list engines in myengines.    
    //calculate average ship isp.
    local numerator to 0.
    local denominator to 0.
    for eng in myengines {
        set numerator to numerator + eng:availablethrust.
        if eng:isp > 0 {
            set denominator to denominator + eng:availablethrust/eng:isp.
        }
    }
    local eisp to numerator/denominator. //average isp.
    local ve to eisp * grav_standard().   //exhaust velocity.
    local massflowrate to ship:availablethrust / ve.
    local finalmass to ship:mass / (constant:e^(nd:burnvector:mag / ve)).
    if massflowrate > 0 {
        local dtime to ((ship:mass - finalmass) / massflowrate).
        return dtime.
    } else {
        return 0.
    }
}

declare function update_ts {
    set steeringmanager:pitchts to abs((ship:mass/(log10(ship:mass)*10))).
    set steeringmanager:yawts to abs((ship:mass/(log10(ship:mass)*12))).
}

declare FUNCTION smoothRotate {
    PARAMETER dir.
    LOCAL spd IS max(SHIP:ANGULARMOMENTUM:MAG/10,4).
    LOCAL curF IS SHIP:FACING:FOREVECTOR.
    LOCAL curR IS SHIP:FACING:TOPVECTOR.
    LOCAL dirF IS dir:FOREVECTOR.
    LOCAL dirR IS dir:TOPVECTOR.
    LOCAL axis IS VCRS(curF,dirF).
    LOCAL axisR IS VCRS(curR,dirR).
    LOCAL rotAng IS VANG(dirF,curF)/spd.
    LOCAL rotRAng IS VANG(dirR,curR)/spd.
    LOCAL rot IS ANGLEAXIS(min(2,rotAng),axis).
    LOCAL rotR IS R(0,0,0).
    IF VANG(dirF,curF) < 90{
        SET rotR TO ANGLEAXIS(min(0.5,rotRAng),axisR).
    }
    RETURN LOOKDIRUP(rot*curF,rotR*curR).
}

declare function print_data {
    parameter nd.
    parameter burn_duration.
    ui_kv("node in", ui_time(nd:eta), 4).
    ui_kv("burn time", round(burn_duration, 2) + " s", 5).
    ui_bar("delta-v", 1 - nd:deltav:mag / max(nd_total_dv, 0.001),
           round(nd:deltav:mag, 1) + " m/s left", 6).
    wait 0.1.
}

//a control part that faces away from the engines (e.g. a nose-down docked
//lander pod) would make every burn fly inverted - refuse to burn like that.
declare function control_agrees_with_engines {
    local thrust_dir to v(0,0,0).
    local es to list().
    list engines in es.
    for e in es {
        if e:availablethrust > 0 {
            set thrust_dir to thrust_dir + e:facing:forevector.
        }
    }
    if thrust_dir:mag > 0 and vdot(thrust_dir:normalized, ship:facing:forevector) < 0 {
        return false.
    }
    return true.
}

declare function ecfrac {
    for r in ship:resources {
        if r:name = "ElectricCharge" {
            return r:amount / max(0.1, r:capacity).
        }
    }
    return 1.
}

declare function run_node {
    sas off.
    clearscreen.
    //update_ts().
    set ship:control:pilotmainthrottle to 0.
    //get the next node.
    local nd to nextnode.
    set nd_total_dv to nd:deltav:mag.
    local max_acc to ship:availablethrust/ship:mass.
    local lock burn_duration to calc_time(nd).
    local time_div to 1.9.

    ui_header("EXECUTE NODE: " + round(nd_total_dv, 1) + " m/s").
    local waitTime to 3.
    until waitTime < 0 {
        ui_kv("status", "executing in " + round(waitTime, 0) + " s", 7).
        set waitTime to waitTime -1.
        wait 1.
    }
    //ALIGN FIRST, THEN WARP: the burn vector is inertially fixed and a ship
    //on rails doesn't rotate, so an attitude locked in before warping is
    //still perfect on arrival. No more guessing how long a heavy station
    //needs to turn - it takes however long it takes, before any warping.
    set steeringmanager:maxstoppingtime to 1.75.
    set steeringmanager:yawpid:kd to 1.
    lock steering to lookdirup(nd:burnvector, ship:facing:topvector).
    ui_kv("status", "aligning before warp", 7).
    local align_t0 to time:seconds.
    until (vang(nd:burnvector, ship:facing:forevector) < 2
           and ship:angularvel:mag < 0.02)
          or time:seconds > align_t0 + 300 {
        print_data(nd, burn_duration).
        ui_kv("align", round(vang(nd:burnvector, ship:facing:forevector), 1) + " deg", 8).
    }

    //already pointed - warp to just before the burn, small margin to settle.
    //Babysit the battery the whole way: kOS itself manages the warp rate, so
    //if the CPU browns out mid-warp NOTHING slows the warp and we sail past
    //the node. Charge up first, and pause the warp to sunbathe if EC drops.
    if ecfrac() < 0.5 and nd:eta - burn_duration/time_div > 120 {
        ui_kv("status", "charging batteries before warp (" + round(ecfrac() * 100) + "%)", 7).
        wait until ecfrac() > 0.8 or nd:eta - burn_duration/time_div < 120.
    }
    if nd:eta - burn_duration/time_div > 25 {
        if ship:altitude > ship:body:atm:height {
            ui_kv("status", "warping (pre-aligned)", 7).
            warpto(time:seconds + nd:eta - burn_duration/time_div - 15).
        } else {
            ui_kv("status", "waiting for vacuum to warp", 7).
        }
    }
    
    local was_in_atm to (ship:altitude < ship:body:atm:height).
    
    until nd:eta <= (burn_duration/time_div){
        print_data(nd, burn_duration).
        ui_kv("align", round(vang(nd:burnvector, ship:facing:forevector), 1) + " deg", 8).
        ui_kv("battery", round(ecfrac() * 100) + "%", 9).
        
        // Start warp once we safely leave the atmosphere
        if was_in_atm and ship:altitude > ship:body:atm:height {
            set was_in_atm to false.
            kuniverse:timewarp:cancelwarp(). // In case the user started manual physics warp
            wait until kuniverse:timewarp:issettled.
            if nd:eta - burn_duration/time_div > 20 {
                ui_kv("status", "exited atmosphere - warping to node", 7).
                warpto(time:seconds + nd:eta - burn_duration/time_div - 15).
            }
        }
        
        if ecfrac() < 0.15 and nd:eta - burn_duration/time_div > 60 {
            kuniverse:timewarp:cancelwarp().
            ui_kv("status", "BATTERY LOW - warp paused to recharge", 7).
            wait until ecfrac() > 0.7 or nd:eta - burn_duration/time_div < 60.
            ui_kv("status", "warping (pre-aligned)", 7).
            warpto(time:seconds + nd:eta - burn_duration/time_div - 15).
        }
    }

    local tset to 0.
    local dv0 to nd:deltav.
    local done to false.
    local aborted to false.
    local old_availablethrust to ship:maxthrust.
    lock throttle to tset.

    until done {
        ui_bar("delta-v", 1 - nd:deltav:mag / max(nd_total_dv, 0.001),
               round(nd:deltav:mag, 1) + " m/s left", 6).
        ui_kv("status", "BURNING", 7).
      //  update_ts().
        if stage_needed() {
            if safe_to_stage() {
                local temp_tset to tset.
                set tset to 0.
                stage.
                wait 0.25.
                set tset to temp_tset.
                set old_availablethrust to ship:maxthrust.
            } else if ship:availablethrust = 0 {
                //out of thrust and the next stage is payload: stop burning
                //rather than fire through it. Node is kept for a retry.
                lock throttle to 0.
                ui_kv("status", "BURN ABORTED - next stage is payload!", 7).
                ui_kv("dv left", round(nd:deltav:mag, 1) + " m/s - node kept for retry", 8).
                set aborted to true.
                set done to true.
            } else {
                set old_availablethrust to ship:maxthrust.
            }
        }
        
        if not aborted and ship:availablethrust > 0 {
            set max_acc to ship:availablethrust / ship:mass.
            set tset to max(min(nd:deltav:mag/max_acc, 1),0.005). 
            set old_availablethrust to ship:maxthrust.
        }
        if vdot(dv0, nd:deltav) < 0 {
            ui_kv("status", "burn complete", 7).
            lock throttle to 0.
            break.
        }
        if nd:deltav:mag < 5 {
            unlock steering.
            sas on.
        }

        if nd:deltav:mag < 0.04 {   //changed from 0.1
            ui_kv("status", "finalizing", 7).
            wait until vdot(dv0, nd:deltav) < 0.01. //changed from 0.5
            lock throttle to 0.
            ui_kv("status", "burn complete", 7).
            set done to true.
        }
        wait 0.
    }

    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    if not aborted {
        set waitTime to 3.
        until waitTime < 0 {
            ui_kv("cleanup", "removing node in " + round(waitTime, 0) + " s", 9).
            set waitTime to waitTime -1.
            wait 1.
        }
        remove nd.
        clearscreen.
        ui_header("NODE COMPLETE").
    } else {
        clearscreen.
        ui_header("NODE ABORTED - node kept, re-run to retry").
    }
    ui_kv("apoapsis", round(ship:orbit:apoapsis) + " m", 4).
    ui_kv("periapsis", round(ship:orbit:periapsis) + " m", 5).
    if (ship:apoapsis > 0 ){
        ui_kv("period", ui_time(ship:orbit:period), 6).
    }
}

if not hasnode {
    print "---error---no node found to execute.".
} else if not control_agrees_with_engines() {
    clearscreen.
    ui_header("BURN REFUSED: control part faces backwards").
    print "The current control point looks AWAY from the active" at (0, 4).
    print "engines - this burn would fly inverted (hello, Kerbin)." at (0, 5).
    print " " at (0, 6).
    print "Right-click a forward-facing probe core or pod and" at (0, 7).
    print "choose 'Control From Here', then run node again." at (0, 8).
} else {
    run_node().
}
