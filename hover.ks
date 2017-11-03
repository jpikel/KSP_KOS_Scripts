//Filename: hover.ks
//Author: Johannes Pikel
//Description: a hover script that only controls the throttle of a specific ship
// uses a PID loop.  Works reasonably on Kerbin, but still overshoots some.  More tuning required
//Dependecies: lib_physics.ks


@LAZYGLOBAL OFF.

//load libraries
run lib_physics.ks.

declare function display {
    declare parameter passedHID.    
    print "Throttle:"+ round(throttle, 4) at (0,0).
    print "Alt     :"+ round(alt:radar, 4) at (0,1).
    print "LastSampleT:"+ round(passedHID:lastsampletime, 2) at (0,2).
    print "Kp:"+ round(passedHID:KP, 3) at (0,3).
    print "Ki:"+ round(passedHID:KI, 3) at (0,4).
    print "Kd:" + round(passedHID:KD, 3) at (0,5).
    print "Input:"+ round(passedHID:input, 2) at (0,6).
    print "Setpoint:" + round(passedHID:setpoint, 2) at (0,7).
    print "Error:" + round(passedHID:error, 2) at (0,8).
    print "Output:"+round(passedHID:output, 2) at (0,9).
    print "pterm:" +round(passedHID:pterm, 2) at (0,10).
    print "iterm:" +round(passedHID:iterm, 2) at (0,11).
    print "dterm:" +round(passedHID:dterm, 2) at (0,12).
    print "twr:" +round(ship_twr(), 2) at (0,13).
    print "seekalt:"+seekalt at (0,15).
}

declare function process_one {
    parameter ch.
    if ch = terminal:input:pagedowncursor { return -1. }
    else if ch = terminal:input:pageupcursor { return 1. }
    else if ch = terminal:input:endcursor { set done to false. return 0. }
    else terminal:input:clear().
}


declare parameter seekAlt is 3.
set ship:control:pilotmainthrottle to 0.
SAS ON.
//Stage.

local throttleOffset to 0.
local lock alt_radar to alt:radar.
local lock midThrottle to Fg_here()/ship:availablethrust. //hover throttle setting
declare global done to true.
local lock queue to ship:messages.

local Kp to 0.106.
local Ki to 0.050.
local Kd to 0.50.

local hoverPID to PIDLoop(Kp, Ki, Kd, -0.1, 0.25).

lock throttle to midThrottle + throttleOffset.
set hoverPID:setpoint to seekAlt.
clearscreen.
local ch to "".
terminal:input:clear().
until done = false {
    set throttleOffset to hoverPid:update(TIME:SECONDS, alt_radar).
    if hoverPID:setpoint <> seekAlt { set hoverPID:setpoint TO seekAlt. }
    if terminal:input:haschar { set seekAlt to seekAlt + process_one(terminal:input:getchar()).}
//    display(hoverPID).
    wait 0.1.
}
