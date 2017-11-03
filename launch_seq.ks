//SPACEPLANE Aeres Launch Sequence
//Dependencies plane_launch.ks, circ_at.ks, exenode.ks
PARAMETER Ap IS 75000.
PARAMETER tgt_hd IS 90.
SET t0 TO TIME:SECONDS.
RUNPATH("0:/plane_launch", Ap, tgt_hd).
WAIT 1.
RUNPATH("0:/circ_at", "ap").
AG10 ON.
WAIT 3.
RUNPATH("0:/exenode").
CLEARSCREEN.
SET t1 TO TIME:SECONDS - t0.
SET minutes TO ROUND(t1 / 60).
SET sec TO ROUND(MOD(t1, 60), 2).
PRINT "Launch took " + minutes + "mm:" + sec + "ss to complete.".
