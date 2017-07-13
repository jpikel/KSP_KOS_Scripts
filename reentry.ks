//Filename: reentry.ks
//Description: kill horizontal velocity while maintaining as close to periapsis as possible.

@lazyglobal off.
SAS off.

    clearscreen.
    run lib_physics.ks.

    local reverse to false.
    //wait until just before PE

//    print "Testing pitch".
//    lock steering to ship:retrograde + R(0, 20, 0).
//    wait 30.
//    if (90 - vang(up:vector, ship:facing:forevector) < ship:retrograde:pitch){
//        set reverse to true.
//        Print "reverse!".
//    }
//    unlock steering.

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
    wait until ship:altitude < 72000.
    panels off.
    runoncepath("0:/antenna", "retract").
    wait until ship:altitude < 70500.
    set pitchpid:setpoint to ship:periapsis.
    terminal:input:clear().
    wait until terminal:input:haschar() or ship:altitude < 67500.
    lock throttle to 1.
    until velocity:surface:mag < 2300 or ship:maxthrust = 0 or ship:altitude < 59000 {
        print "cur pitch: " + round(curPitch) at (0,5).
        print "adjustpitch:" + round(adjustPitch) at (0,7).
        if(abs(90 - vang((ship:retrograde:vector + R(0,adjustPitch, 0)), up:vector)) - 30 < 30){
                set adjustPitch to adjustPitch - pitchPid:update(time:seconds, ship:periapsis).
//           if ( reverse = true){
//                set adjustPitch to adjustPitch - pitchPid:update(time:seconds, ship:periapsis).
//            } else {
//                set adjustPitch to adjustPitch + pitchPid:update(time:seconds, ship:periapsis).
//            }
        } 

    }
    lock throttle to 0.
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    lock steering to lookdirup(vcrs(Ship:body:position,ship:velocity:orbit),ship:body:position).
    wait until vang(ship:facing:vector, lookdirup(vcrs(ship:body:position, ship:velocity:orbit),ship:body:position):vector) < 5.
    stage.
    lock steering to srfretrograde + R(0,0,adjustRoll).
    local waitparam to 20000.
    until ship:altitude < 20000 and x = 0 {
        from {local x is 0.} until x = 359 step {set x to x + 1.} do {
            set adjustRoll to adjustRoll + 1.
            wait waitparam/ship:altitude + 0.0001.
        }
    }
    lock steering to srfretrograde.
    wait 5.
    unlock steering.
