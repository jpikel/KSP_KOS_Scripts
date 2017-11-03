// Filename: land.ks
// Description: creates a maneuver node at the Apoapsis that first reduces the PE to the terrain height
// Then iteratively checks the future ship position for 1 orbit and increases the PE until there are no
// terrain obstacles in the way of the future ship's orbit.  Works reasonably well.  
// the FROM loop can be improved with a smaller step.

@LAZYGLOBAL off.

//dependencies lib_physics.ks and run_node.ks

//function to run pitch PID to keep vertical speed to 0 m/s
declare function set_pitch {
    local Kp to .156.
    local Ki to .101.
    local Kd to .060.

    local pitch_PID to PIDLOOP(Kp, Ki, Kd).
    set pitch_PID:setpoint to -5.

    return pitch_PID:update(TIME:SECONDS, verticalspeed).
}

    clearscreen.
    local nd to node(time:seconds+orbit:period/2, 0,0,0).
    local nd_terrain_height to geoposition:terrainheight.
    add nd.
    local dv to 0.
until nd:orbit:periapsis <  nd_terrain_height {
    set dv to dv -1.
    set nd:prograde to dv.
    wait 0.001.
}

//function starts here!
//create a maneuver node from AP that just barely passes all the terrain by the offset + shiplength
    run lib_physics.ks.
    local myship to ship.
    local ship_length to find_ship_length().
    local offset to 20.
    local alt_at to 0.
    local pos to 0.
    local actual to 0.
    local ter_at to 0.
    local cur_time to time:seconds + nd:eta.
    local done to false.
    local error to false.

    until done {
        from { cur_time. } until cur_time > time:seconds+orbit:period step { set cur_time to cur_time + 1. } do {
            set pos to positionat(myship, cur_time).
            set alt_at to ship:body:altitudeof(pos).
            set ter_at to ship:body:geopositionof(pos):terrainheight.
            set actual to alt_at - ter_at.
            if actual < ship_length + offset { set nd:prograde to nd:prograde + 1. set error to true. break. }
            else { set error to false. }
        }
        if error = false { set done to true. }
    }

    //runoncepath("0:/exenode.ks").

    //runoncepath("0:/slam.ks").
