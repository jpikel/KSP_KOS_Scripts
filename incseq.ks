//Filename: incseq.ks
//Description: s script that runs a series of other script.  First it calculates the time to either the 
// ascending or descending node of the target from KSC launchpad.
// Used it sucessefully to launch within 0.1 degrees of Minmus
// Warps to the AN or DN node that the nearest in time
// Dependencies: rocket_launch.ks, circ_at.ks, exenode.ks
@lazyglobal off.
//Inclined rocket Launch Sequence
PARAMETER Ap IS 72500.

clearscreen.
local tgt_hd to 90.
local time1 to ((target:orbit:lan - ship:body:rotationangle) + abs(ship:longitude)) / 360 * ship:body:rotationperiod.
local time2 to (180 - (ship:body:rotationangle + ship:longitude) + target:orbit:lan) / 360 * ship:body:rotationperiod.
local offset to 30. //seconds before AN or DN
local waittime to 0.
local t0 to 0.
local t1 to 0.
print time1.
print time2.
if(time1 > 0 and time1 < time2) {
    set waittime to time:seconds - offset + time1.
    warpto(time:seconds - offset + time1). 
    set tgt_hd to tgt_hd - target:orbit:inclination.
} else if time2 > 0{ //DN is closer warp there!
    set waittime to time:seconds - offset + time2.
    warpto(time:seconds - offset + time2).
    set tgt_hd to tgt_hd + target:orbit:inclination.
} else {
    set waittime to time:seconds - offset + (-1*time1).
    warpto(time:seconds - offset + (-1*time1)).
    set tgt_hd to tgt_hd - target:orbit:inclination.
}

//terminal:input:clear().
//print "Press [Enter] to launch!".
//set ch to terminal:input:getchar().
//if (ch = terminal:input:return) {

    wait until warp = 0 and ship:unpacked.
    //wait until time:seconds > waittime + 2.
    SET t0 TO TIME:SECONDS.
    RUNPATH("0:/rocket_launch", Ap, tgt_hd).
    WAIT 3.
    RUNPATH("0:/circat", "ap").
    //AG10 ON.
    WAIT 3.
    RUNPATH("0:/exenode").
    CLEARSCREEN.
    set t1 TO TIME:SECONDS - t0.
    local minutes TO FLOOR(t1 / 60).
    local sec TO ROUND(MOD(t1, 60)).
    PRINT "Launch took " + minutes + "mm:" + sec + "ss to complete.".
//}
