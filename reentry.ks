//Filename: reentry.ks

@lazyglobal off.
SAS off.
//    copypath("0:/antenna", "1:/antenna").
    clearscreen.
    if ship:altitude > 2500000 {
        set warp to 5.
        wait until ship:altitude < 2500000.
    }
    if ship:altitude > 600000 {
        set warp to 4.
        wait until ship:altitude < 600000.
    }
    if ship:altitude > 300000 {
        set warp to 3.
        wait until ship:altitude < 300000.
    }
    set warp to 2.
    wait until ship:altitude < 100000.
    set warp to 1.
    wait until ship:altitude < 79000.
    set warp to 0.

    local Kp to 0.005.
    local Ki to 0.05.
    local Kd to 0.5.
    local slow to 0.
    local pitchPid to pidloop(Kp, Ki, Kd, -.1, .1).

    local adjustPitch to 0.
    local adjustRoll to 0.
    local lock idealPitch to ship:retrograde:vector + R(0,adjustPitch,0).
    lock steering to idealPitch.
    local lock curPitch to 90 - vang(up:vector, ship:facing:forevector).
    wait until ship:altitude < 73000.
    panels off.
//    runoncepath("1:/antenna", "retract").
    wait until ship:altitude < 70500.
    set pitchpid:setpoint to ship:periapsis.
    terminal:input:clear().
    wait until terminal:input:haschar() or ship:altitude < 69500.
    lock throttle to 1.
    until velocity:surface:mag < 2300 or ship:altitude < 58000 {
        print "cur pitch: " + round(curPitch) at (0,5).
        print "adjustpitch:" + round(adjustPitch) at (0,7).
        if(abs(90 - vang((ship:retrograde:vector + R(0,adjustPitch, 0)), up:vector)) - 30 < 30){
                set adjustPitch to adjustPitch - pitchPid:update(time:seconds, ship:periapsis).
        } 

    }
    lock throttle to 0.
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    lock steering to north + R(0,85,0).
    wait 3.
    stage.
    wait until stage:ready.
    stage.
    lock steering to srfretrograde + R(0,0,adjustRoll).
    wait 5.
    until ship:altitude < 20000 {
        from {local x is 0.} until x = 359 step {set x to x + 1.} do {
            set adjustRoll to adjustRoll + 1.
            wait 0.05.
        }
    //    if ship:altitude < 50000 set warp to 2.
    }
    lock steering to srfretrograde.
    wait until ship:altitude < 3000.
    unlock steering.
    set warp to 0.
