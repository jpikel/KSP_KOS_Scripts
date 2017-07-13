// Filename: rove.ks
// Description: the start of an autonomous rover script. 
// Lots of work still required

@lazyglobal off.

    parameter way_name.
    clearscreen.
    //set way point up here
    local way1 to waypoint(way_name).
    brakes off.
    //motor pid loop
    local kp to .85.
    local ki to .25.
    local kd to .1.

    local drive to pidloop(kp, ki, kd, -1, 1).

    set drive:setpoint to 5.    // m/s

    local thrott to 0.
    lock wheelthrottle to thrott.
    //end motor pid loop
    
    //steering pid loop
    local kp1 to 0.025.
    local ki1 to 0.0075.
    local kd1 to 0.001.

    local steer to pidloop(kp1, ki1, kd1, -0.1, 0.1).
    set steer:setpoint to way1:geoposition.

    local steervar to 0.
    local shipbear to ship:bearing.
    lock wheelsteering to steervar.

    until way1:geoposition:distance < 5 {
        set thrott to drive:update(time:seconds, ship:groundspeed).
        set shipbear to ship:bearing.
        if shipbear < 0 {
            set shipbear to shipbear + 180.
        }
        set steervar to steervar + steer:update(time:seconds, ship:geoposition).
        print "thrott" + thrott at (0,1).
        print "ship bear:" + ship:bearing at (0,2).
        print "way bear: " + way1:geoposition:bearing at (0,3).
        if(ship:groundspeed > 7){
            brakes on.
        } else {
            brakes off.
        }
    } 
    
