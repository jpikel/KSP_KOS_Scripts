//Filename: killhorz.ks
//Description: kill horizontal velocity while maintaining as close to 0 vertical speed as possible.

@lazyglobal off.
SAS off.

    clearscreen.
    run lib_physics.ks.

    local reverse to false.
    //wait until just before PE
    print "Wait till PE".
    warpto(time:seconds + eta:periapsis - 180).
    wait until warp = 0 and ship:unpacked.

    print "Testing pitch".
    lock steering to srfretrograde + R(0, 20, 0).
    wait 30.
    if (90 - vang(up:vector, ship:facing:forevector) < 0){
        set reverse to true.
        Print "reverse!".
    }
    unlock steering.


    local Kp to 0.05.
    local Ki to 0.03.
    local Kd to 0.08.
    local slow to 0.
    local pitchPid to pidloop(Kp, Ki, Kd, -1, 1).
    set pitchpid:setpoint to 0.

    local adjustPitch to 0.
    local lock idealPitch to srfretrograde + R(0,adjustPitch,0).
    lock steering to idealPitch.


    lock maxdecel to (ship:maxthrust / ship:mass) - g_here().    // max deceleration of the vehicle 
    lock vel to velocity:surface:mag.

    terminal:input:clear().
    until terminal:input:haschar{
        print "decel time: " + round(vel/maxdecel) at (0,4).
        print "eta pe: " + round(eta:periapsis) + "      " at (0,5).
    }
    local pos0 to ship:geoposition.
    if (ship:groundspeed > 10) {
        until ship:groundspeed < 10 {
            lock throttle to 1.
            set slow to ship:verticalspeed/10.
            if ( reverse = true){
                set adjustPitch to pitchPid:update(time:seconds, slow).
            } else {
                set adjustPitch to pitchPid:update(time:seconds, slow).
            }
        }
    }

    lock throttle to 0.
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    unlock steering.

    domath(pos0, ship:geoposition).




declare function domath {
    parameter pos0.
    parameter pos1.

    local rad to ship:body:radius.
    local lat1 to pos0:lat * constant:pi / 180.
    local lat2 to pos1:lat * constant:pi / 180.
    local d_lat to (pos1:lat - pos0:lat) * constant:pi / 180.
    local d_lng to (pos1:lng - pos0:lng) * constant:pi / 180.

    local a to sin(d_lat/2) * sin(d_lat/2) + cos(lat1) * cos(lat2) * sin(d_lng/2) * sin(d_lng/2).
    local c to arctan2(sqrt(a), sqrt(1-a)).
    local d to rad * c.

    print "Distance traveled: " + round(d, 3).
}
