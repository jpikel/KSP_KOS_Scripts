// Filename: dock.ks
// Description: a docking script that I am working on and needs way 
// more work...


@lazyglobal off.

declare function dock {
    sas off.
    rcs on.
    clearscreen.
    local parts to List().
    local parts to ship:partsdubbed("PortA").
    if parts:length = 0 { local dummy to 1/0. }
    local myPort to parts[0].

    lock st to get_dir(myPort).
    lock steering to st.
    wait until vang(ship:facing:vector, lookdirup(target:facing:vector*-1, ship:facing:topvector):vector) < 2.
    

    local kp1 to 0.1.
    local ki1 to 0.00001.
    local kd1 to 5.

    local kp2 to kp1.
    local ki2 to ki1.
    local kd2 to kd1.

    local kp3 to kp1.
    local ki3 to ki1.
    local kd3 to kd1.

    local x_pid to PIDLoop(kp1, ki1, kd1, -1, 1).
    local y_pid to pidloop(kp2, ki2, kd2, -1, 1).
    set x_pid:setpoint to get_x_diff(myPort).
    set y_pid:setpoint to get_y_diff(myPort).

    local d_pid to pidloop(kp3, ki3, kd3, -1, 1).
    set d_pid:setpoint to get_z_diff(myPort).

    local done to false.
    local docking to false.
    local readytodock to false.

    local currTime to time:seconds.
    local currDist to target:ship:distance.
    local relv to 0.
    local t0 to time:seconds.

    terminal:input:clear().

    until done {
        if time:seconds - currTime > 1 {
            set relv to get_relv(currTime, currDist, myPort).
            set currTime to time:seconds.
            set currDist to (myPort:position - target:position):mag.
        }

        print "relv: " + round(relv, 4) + "      " at (0,0).
        print "Dist: " + round(currDist, 4) + "      " at (0,1).
        print "xdif: " + round(get_x_diff(myPort),4) + "      " at (0,2).
        print "ydif: " + round(get_y_diff(myPort),4) + "      " at (0,3).
        print "zdif: " + round(get_z_diff(myPort),4) + "      " at (0,4).
        print "xout: " + round(x_pid:output,4) + "      " at (0,5).
        print "yout: " + round(y_pid:output,4) + "      " at (0,6).
        print "zout: " + round(d_pid:output,4) + "      " at (0,7).
        print "dset: " + round(d_pid:setpoint, 4) + "        " at(0,8).
        print "Elapsed: " + round(time:seconds - t0, 4) + "         " at (0,9).
        print "kd1: " + round(kd1, 4) + "      " at (0,13).

        set ship:control:starboard to x_pid:update(time:seconds, get_x_diff(myPort)).
        set ship:control:top to -1*y_pid:update(time:seconds, get_y_diff(myPort)).
        if docking = false  {
            set ship:control:fore to -1*d_pid:update(time:seconds, get_z_diff(myPort)).
        } else if docking = true {
            set ship:control:fore to d_pid:update(time:seconds, relv).
        }

        if terminal:input:haschar(){ 
            local ch to terminal:input:getchar().
            terminal:input:clear().
            if ch = "g" {
                set readytodock to true.
            }
        }

        if time:seconds - t0 > 2 {
            set d_pid:setpoint to max(10, d_pid:setpoint - 1).
            set y_pid:setpoint to max(0, y_pid:setpoint - 1).
            set x_pid:setpoint to max(0, x_pid:setpoint - 1).
        }

        if docking = false 
            and readytodock = true
            and abs(get_x_diff(myPort)) < 0.075 
            and abs(get_y_diff(myPort)) < 0.075 
            and  time:seconds-t0 > 10 {
            set docking to true.
            print "docking..." at (0,10).
            d_pid:reset().
            x_pid:reset().
            y_pid:reset().
            set d_pid:setpoint to 0.5.
            set d_pid:maxoutput to 0.2.
            set d_pid:minoutput to -0.2.
            set d_pid:kd to 1.5.
            set x_pid:kd to 1.2.
            set y_pid:kd to 1.2.
            set x_pid:ki to 0.
            set y_pid:ki to 0.

        } else if docking = false and abs(relv) > 0.05 {
            set t0 to time:seconds.
        }

        if docking = true and abs(get_z_diff(myPort)) < target:acquirerange + 0.25 {
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
    parameter myPort.
    return VDOT(myPort:position - target:position, target:portfacing:starvector).
//    return ship:facing:starvector:normalized * target:position.
}

declare function get_y_diff {
    parameter myPort.
    return VDOT(myPort:position - target:position, target:portfacing:topvector).
//    return ship:facing:topvector:normalized * target:position.
}

declare function get_z_diff {
    parameter myPort.
    return VDOT(myPort:position - target:position, target:portfacing:forevector).
//    return ship:facing:forevector:normalized * target:position.
}

declare function get_dir {
    parameter myPort.
    return lookdirup(target:facing:forevector*-1, myPort:portfacing:topvector).
    
}

declare function get_relv {
    parameter oldTime.
    parameter oldDist.
    parameter myPort.
    return (oldDist - (myPort:position - target:position):mag) /abs((oldTime - time:seconds)).
}

dock().
