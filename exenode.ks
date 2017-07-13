// Filename: exenode.ks
// Description: a short script that executes a maneuver node.  Based on the
// tutorial presented on the KOS Documentation page.
// https://ksp-kos.github.io/KOS/tutorials.html
// Dependency: requires the file lib_physics.ks to be in the same directory

@LAZYGLOBAL OFF.
CLEARSCREEN.
//calculates the time required for the deltaV set by the maneuver node.
//https://www.reddit.com/r/Kos/comments/4568p2/executing_maneuver_nodes_figuring_out_the_rocket/
run lib_physics.ks.
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

declare function print_data {
    parameter nd.
    parameter burn_duration.
    local hpd to kuniverse:hoursperday.
    local secs to nd:eta.
    local mins to floor(secs/60). set secs to round(mod(secs, 60)).
    local hrs to floor(mins/60). set mins to mod(mins, 60).
    local days to floor(hrs/hpd). set hrs to mod(hrs, hpd).
    print "Node in: " + days + "d " + hrs + "h " + mins + "m " + secs + "s      "  at (0,0).
    print "Deltav : " + round(nd:deltav:mag, 2) + "             " at (0,1).
    print "Estimated burn time: " + round(burn_duration, 2) + " s        " at (0,2).
    wait 0.1.
}

declare function run_node {
    sas off.
    clearscreen.
    //update_ts().
    set ship:control:pilotmainthrottle to 0.
    //get the next node.
    local nd to nextnode.
    local max_acc to ship:availablethrust/ship:mass.
    local lock burn_duration to calc_time(nd).


    local waitTime to 3.
    until waitTime < 0 {
        print "Executing Node in " + round(waitTime,0) + " seconds   " at (0,2).
        set waitTime to waitTime -1.
        wait 1.
    }
    clearscreen.
    //warp to current time + node eta - estimated burn time - 30 seconds padding.
    if(time:seconds < time:seconds + nd:eta - burn_duration/2 -50){
        print "Warping to node." at (0,4).
        local warpedTime to (time:seconds + nd:eta - burn_duration/2 -50).
        warpto(time:seconds + nd:eta - burn_duration/2 - 50).
        until time:seconds > warpedTime and warp = 0 and ship:unpacked {
            print_data(nd, burn_duration).
        }
    }

    lock steering to lookdirup(nd:burnvector, ship:facing:topvector).
    //wait until we're facing the manuever node and then warp the rest of the way until we're 10 seconds out
    //from the burn start time.  Should give enough time for the game to catch up.
    until vang(nd:burnvector, ship:facing:forevector) < 3 {
        print_data(nd, burn_duration).
    }
    warpto(time:seconds + nd:eta - burn_duration/2 - 10).
    until nd:eta <= (burn_duration/2){
        print_data(nd, burn_duration).
    }

    local tset to 0.
    local dv0 to nd:deltav.
    local done to false.
    local old_availablethrust to ship:availablethrust.
    lock throttle to tset.

    until done {
        print "burn commencing" at (0,5).
      //  update_ts().
        if(old_availablethrust > ship:availablethrust){
            local temp_tset to tset.
            set tset to 0.
            stage.
            wait 0.25.
            set tset to temp_tset.
            set old_availablethrust to ship:availablethrust.
        } else {
            set max_acc to ship:availablethrust / ship:mass.
            set tset to min(nd:deltav:mag/(max_acc + 0.01), 1). //remove +0.01
            set old_availablethrust to ship:availablethrust.
        }
        if vdot(dv0, nd:deltav) < 0 {
            print "burn complete" at (0,6).
            lock throttle to 0.
            break.
        }
        if nd:deltav:mag < 2 {
            unlock steering.
            sas on.
        }

        if nd:deltav:mag < 0.05 {   //changed from 0.1
            print "finalizing" at (0,6).
            wait until vdot(dv0, nd:deltav) < 0.025. //changed from 0.5
            lock throttle to 0.
            print "burn complete" at (0,7).
            set done to true.
        }
        wait 0.
    }

    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    print "---goodbye---" at (0,8).
    set waitTime to 3.
    until waitTime < 0 {
        print "Removing manuever node in " + round(waitTime, 0) + " seconds    " at (0,9).
        set waitTime to waitTime -1.
        wait 1.
    }
    remove nd.
    clearscreen.
    print "AP: " + round(ship:orbit:apoapsis).
    print "PE: " + round(ship:orbit:periapsis).
    if (ship:apoapsis > 0 ){
        print "Period: " + round(ship:orbit:period,4).
    }
}

if hasnode {
    run_node().
} else {
    print "---error---no node found to execute.".
    
}
