// Filename: dock.ks
// Description: a docking script that I am working on and needs way 
// more work...


@lazyglobal off.

declare function dock {
    sas off.
    rcs on.
    clearscreen.

    lock st to lookdirup(target:position,-north:vector).
    lock steering to st.
    wait until vang(ship:facing:vector, target:position) < 2.
    

    local kp1 to 1.
    local ki1 to 0.005.
    local kd1 to 8.

    local kp2 to kp1.
    local ki2 to ki1.
    local kd2 to kd1.

    local kp3 to kp1.
    local ki3 to ki1.
    local kd3 to kd1.

    local x_pid to PIDLoop(kp1, ki1, kd1, -1, 1).
    local y_pid to pidloop(kp2, ki2, kd2, -1, 1).
    set x_pid:setpoint to 0.
    set y_pid:setpoint to 0.

    local d_pid to pidloop(kp3, ki3, kd3, -1, 1).
    set d_pid:setpoint to 15.

    local done to false.
    local docking to false.
    local readytodock to false.

    local currTime to time:seconds.
    local currDist to target:distance.
    local relv to 0.
    local t0 to time:seconds.

    terminal:input:clear().

    until done {
        if time:seconds - currTime > 1 {
            set relv to get_relv(currTime, currDist).
            set currTime to time:seconds.
            set currDist to (ship:position - target:position):mag.
        
        }

        print "relv: " + round(relv, 4) + "      " at (0,0).
        print "Dist: " + round(currDist, 4) + "      " at (0,1).
        print "xdif: " + round(get_x_diff(),4) + "      " at (0,2).
        print "ydif: " + round(get_y_diff(),4) + "      " at (0,3).
        print "zdif: " + round(get_z_diff(),4) + "      " at (0,4).
        print "xout: " + round(x_pid:output,4) + "      " at (0,5).
        print "yout: " + round(y_pid:output,4) + "      " at (0,6).
        print "zout: " + round(d_pid:output,4) + "      " at (0,7).
        print "dset: " + round(d_pid:setpoint, 4) + "        " at(0,8).
        print "xset: " + round(x_pid:setpoint, 4) + "        " at (0,9).
        print "yset: " + round(y_pid:setpoint, 4) + "        " at (0,10).
        print "Elapsed: " + round(time:seconds - t0, 4) + "         " at (0,11).
        print "kd1: " + round(kd1, 4) + "      " at (0,13).

        set ship:control:starboard to x_pid:update(time:seconds, get_x_diff()).
        set ship:control:top to y_pid:update(time:seconds, get_y_diff()).
//        if docking = false  {
//        set ship:control:fore to -1*d_pid:update(time:seconds, get_z_diff()).
//        } else if docking = true {
        //set ship:control:fore to d_pid:update(time:seconds, relv).
//        }

        if currDist < 15 {
            set d_pid:setpoint to 0.5.
        }

        if docking = false and abs(relv) > 0.05 {
            set t0 to time:seconds.
        }

        if currDist < 2 {
            set done to true.
        }
    }

    set ship:control:mainthrottle to 0.
    unlock steering.
    set ship:control:neutralize to True.
    SAS on.
    RCS off.
}


declare function get_x_diff {
    return VDOT(ship:position - target:position, target:facing:starvector).
//    return ship:facing:starvector:normalized * target:position.
}

declare function get_y_diff {
//    return VDOT(ship:position - target:position, target:facing:topvector).
    return ship:facing:topvector:normalized * target:position.
}

declare function get_z_diff {
//    return VDOT(ship:position - target:position, target:facing:forevector).
    return ship:facing:forevector:normalized * target:position.
}

declare function get_dir {
    return lookdirup(ship:facing:topvector, target:facing:forevector).
    
}

declare function get_relv {
    parameter oldTime.
    parameter oldDist.
//    return (oldDist - (ship:position - target:position):mag) /abs((oldTime - time:seconds)).
    return (target:velocity:orbit - ship:velocity:orbit):mag.
}

dock().
