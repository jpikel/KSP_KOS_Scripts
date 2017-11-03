// Filename: rocket_launch.ks
// Description: rocket launch script 
//using formula found here https://imgur.com/a/SXttd for pitch change
//throttle forumla from http://forum.kerbalspaceprogram.com/index.php?/topic/116228-kos-calculating-spacecraft-weight/
// pitchangle = 90 * (1 - (currentAltitude / turnEnd)^turnExponent)

@LAZYGLOBAL OFF.
parameter tgt_ap is 75000.
parameter tgt_hd is 90.
declare global targettwr to 2.00.
declare global turnend to 45000.
declare global turnexponent to 0.6.
declare global thrott to 1.

declare function countdown {
    clearscreen.
    from { local i is 5.} until i = 0 step {set i to i-1.} do {
        print "counting down..." at (0,0). //(column, row).
        print "t-minus: " + i + " " at (0, 2).
        wait 1.
    }
    if stage:ready {
        clearscreen.
        print "---launch---".
        stage.
    } else {
        clearscreen.
        print "---error--- stage not ready, rebooting...".
        reboot.
    }
}


declare function asparagus {
    parameter old_maxthrust.
    parameter throttle_set.
    if(old_maxthrust > ship:maxthrust or ship:maxthrust = 0){
        set thrott to 0.
        stage.
        wait 0.5.
        set thrott to throttle_set.
    }

    return ship:maxthrust.
}
//main function begins here!!
//will launch a rocket to the desired apoapsis and heading i hope!

    clearscreen.
    set ship:control:pilotmainthrottle to 0. // make sure throttle is 0 before we start
    sas off.                                 // turn off sas
    set sasmode to "STABILITYASSIST".

    run lib_physics.ks.
    lock dthrott to (targettwr * fg_here()) / (ship:maxthrust + 0.001).

    //calculate pitch
    lock result to 90 * (1 - (altitude / turnend)^turnexponent). 
    lock targetpitch to max(2, result).

    //initial launch
    clearscreen.
    lock throttle to thrott.

    countdown().
    lock steering to up + r(0,0,180).
    local old_maxthrust to ship:maxthrust.
    //wait until we've accelerated enough or are at 1km.
    until round(velocity:surface:mag) > 35 or round(altitude) > 500 {}

    //initial pitch over done here.
    local steer_var to 89.
    lock steering to heading(tgt_hd, steer_var) + r(0,0,-90). // avoid roll with +r(0,0,-90) rocket built default rotation vab
    until steer_var < targetpitch {
        set steer_var to steer_var - 1.
        print "target pitch: " + round(targetpitch) + "  " at (0,2).
        set old_maxthrust to asparagus(old_maxthrust, thrott).
        set thrott to dthrott.
        wait 0.2.
    }

    until apoapsis > tgt_ap {
        print "target pitch: " + round(targetpitch) + "  " at (0,2). 
        if tgt_ap - apoapsis > 200 {
            set thrott to dthrott.
        } else {
            set thrott to dthrott * .25.
        }

        if altitude > turnend {
            set steer_var to 1.
            set targettwr to 1.0.
        } else {
            set steer_var to targetpitch.
        }
        set old_maxthrust to asparagus(old_maxthrust, thrott).
    }

    clearscreen.
    print "target pitch: 2     " at (0,2).
    set steer_var to 2. //hold directly to horizon + 1 degree.
    set targettwr to 1.0. //slow down a bit so we can gain altitude

    until altitude > 70000 {
        if apoapsis < (tgt_ap - 25) {
            until apoapsis > tgt_ap {
                set thrott to dthrott * .25.
            }
        } else {
            set thrott to 0.
        }
        set old_maxthrust to asparagus(old_maxthrust, thrott).
    }
    unlock throttle.
    set thrott to 0.
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    sas on.

    panels on.
    runoncepath("0:/antenna", "extend").

    wait 1.
