// Filename: rlseq.ks
// Description: the launch sequence script that launches a rocket to altitude and
// target heading, circularizes at apoapsis, and executes the node.
// Run bare for interactive prompts; pass parameters to run scripted:
//   run rlseq.                    ask for apoapsis, heading, and TWR limits
//   run rlseq(100000, 90).        scripted, defaults for the TWR limits
// dependencies: rocket_launch.ks, circat.ks, node.ks, lib_input.ks

PARAMETER Ap IS "ask".
PARAMETER tgt_hd IS 90.
PARAMETER liftofftwr IS 1.45.
PARAMETER maxtwr IS 2.20.
PARAMETER stopstage IS 0.

RUNONCEPATH("lib_input.ks").
RUNONCEPATH("lib_ui.ks").
RUNONCEPATH("flightlog.ks").

IF Ap:ISTYPE("String") {
    CLEARSCREEN.
    PRINT "=== launch sequence setup (ENTER accepts default) ===".
    SET Ap TO read_number("Target apoapsis (m)", MAX(75000, BODY:ATM:HEIGHT + 10000), 2).
    SET tgt_hd TO read_number("Heading (deg, 90 = east)", 90, 3).
    SET liftofftwr TO read_number("Liftoff TWR", 1.45, 4).
    SET maxtwr TO read_number("Max TWR (upper atmosphere)", 2.20, 5).
    SET stopstage TO read_number("Auto-stage floor (0 = auto-detect payload)", 0, 6).
}

SET t0 TO TIME:SECONDS.
SET dv0 TO SHIP:DELTAV:VACUUM.
// RUNPATH, not RUNONCEPATH: these are actions, and a second launch in the
// same CPU session (e.g. a moon hopper relaunching) must actually run them.
RUNPATH("0:/rocket_launch", Ap, tgt_hd, liftofftwr, maxtwr, stopstage).
WAIT 1.
RUNPATH("0:/circat", "ap").
WAIT 3.
RUNPATH("0:/node").
CLEARSCREEN.
SET t1 TO TIME:SECONDS - t0.
ui_header("ORBIT ACHIEVED: " + SHIP:NAME).
ui_kv("elapsed", ui_time(t1), 4).
ui_kv("apoapsis", ROUND(SHIP:ORBIT:APOAPSIS / 1000, 1) + " km", 5).
ui_kv("periapsis", ROUND(SHIP:ORBIT:PERIAPSIS / 1000, 1) + " km", 6).
ui_kv("inclination", ROUND(SHIP:ORBIT:INCLINATION, 2) + " deg", 7).
ui_kv("dv to orbit", ROUND(dv0 - SHIP:DELTAV:VACUUM) + " m/s (good = under ~3500)", 8).
log_flight(dv0 - SHIP:DELTAV:VACUUM, t1, liftofftwr, maxtwr).
ui_kv("logged", "0:/flightlog.csv", 9).
