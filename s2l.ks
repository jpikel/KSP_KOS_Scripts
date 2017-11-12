@lazyglobal off.
parameter tgt_ap is 120000.
parameter tgt_hd is 90.
clearscreen.


declare function print_stats {
    parameter pitch.
    parameter dpitch.
    parameter targetpitch.
    print "current pitch: " + pitch + "    " at (0,3).
    print "desired pitch: " + dpitch + "    " at (0,4).
    print "target  pitch: " + targetpitch + "    " at (0,5).
}

    local t1 to time:seconds.
    local lng_1 to ship:geoposition:lng.
    local ap_fuzz to 300.
    local turnend to 50000.
    local turnexponent to 0.525.

    set ship:control:pilotmainthrottle to 0. //set throttle to 0
    sas off.                                //turn off sas
    brakes on.


    //calculate pitch turn
    lock result to 90 * (1 - (altitude / turnend)^turnexponent). 
    lock targetpitch to round(max(2, result)).

    //calculate current pitch above horizon.
    lock cur_pitch to round(90 - vang(up:vector, ship:facing:forevector)).

    local pitch_pid to pidloop(0.5, 0.1, 0.4).

    local ship_pitch to 0.25.
    local ship_hd to 90.25.

    local thrott to 0.
    lock throttle to thrott.
    lock steering to heading (ship_hd, ship_pitch).
    stage.
    toggle ag1.
    wait 2.

    set thrott to 1.
    wait 2.
    brakes off.
    print "status: " at (0,0).
    print "launch commencing" at (9,0).
    print "target ap: " + tgt_ap at (0,1).

    wait until ship:airspeed > 150.
    set ship_pitch to 5.
    print "pitch to " + ship_pitch + "          " at (9,0).
    
    wait until ship:status = "flying".
    print "wheels up        " at(9,0).
    gear off.
    set ship_hd to tgt_hd.
    set pitch_pid:setpoint to 10.
    local runmode to 0.
    until ship:apoapsis > tgt_ap + ap_fuzz {
        set ship_pitch to round(pitch_pid:update(time:seconds, cur_pitch)).
        print_stats(cur_pitch, ship_pitch, targetpitch).
        if runmode = 0 and ship:altitude > 1500 and ship:velocity:surface:mag > 400 {
            print "0" at (0,6).
            set pitch_pid:setpoint to 20.
            set runmode to 1.
        }
        else if runmode = 1 and ship:altitude > 15000 {
            print "1" at (0,6).
            toggle ag1.
            set pitch_pid:setpoint to 30.
            set runmode to 2.
        } 
        else if runmode = 2 and ship:altitude > 25000 {
            print "2" at (0,6).
            toggle ag2.
            set runmode to 3.
        }
        else if runmode = 3 and targetpitch < cur_pitch {
            print "3" at (0,6).
            lock steering to heading(ship_hd, targetpitch).
            set runmode to 4.
        }
    }

    until altitude > 70000 {
        if apoapsis < (tgt_ap - 200) {
            until apoapsis > tgt_ap {
                set thrott to .25.
            }
        } else {
            set thrott to 0.
        }
    }

    unlock steering.
    unlock throttle.
    set ship:control:pilotmainthrottle to 0.
    local t2 to time:seconds - t1.
    local lng_2 to ship:geoposition:lng.
    local minutes to floor(t2 / 60).
    local sec to round(mod(t2, 60)).

    print "launch took " + minutes + " mm:" + sec + " ss to complete.".
    print "starting longitude: " + lng_1.
    print "current longitude: " + lng_2.
