// Filename: rlseq.ks
// Description: the launch sequence script that launches a rocket to altitude and target heading
// defaults to 75km and due east.
// dependencies: rocket_launch.ks, circ_at.ks, exenode.ks

PARAMETER Ap IS 72500.
PARAMETER tgt_hd IS 90.
SET t0 TO TIME:SECONDS.
RUNoncePATH("0:/rocket_launch", Ap, tgt_hd).
WAIT 1.
RUNoncePATH("0:/circat", "ap").
//AG10 ON.
WAIT 3.
RUNoncePATH("0:/exenode").
CLEARSCREEN.
SET t1 TO TIME:SECONDS - t0.
SET minutes TO FLOOR(t1 / 60).
SET sec TO ROUND(MOD(t1, 60)).
PRINT "Launch took " + minutes + "mm:" + sec + "ss to complete.".
Print "Ap:  " + round(ship:orbit:apoapsis, 2).
print "Pe: " + round(ship:orbit:periapsis, 2).
