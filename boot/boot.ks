//Filename: boot/boot.ks
//Description: runs on every kOS CPU boot. Syncs the library files and the
//most-used scripts from the archive to the local disk (in priority tiers,
//as space allows), so a vessel that loses comms can still run its own
//scripts: SWITCH TO 1. then run them by name.
//With comms: leaves you on the archive volume as usual.

@LAZYGLOBAL OFF.

set terminal:width to 52.
set terminal:height to 36.
//kOS executes CONFIG:IPU opcodes per physics tick (default a sluggish 200).
//2000 makes every script ~10x faster at a small real-CPU cost - lower this
//if the game ever stutters during script runs.
set config:ipu to 2000.

//priority tiers: libraries first, then core flight ops, then the rest.
//a small disk gets the top tiers; a big one gets everything.
local tiers to list(
    list("lib_physics.ks", "lib_input.ks", "lib_ui.ks", "lib_orbit.ks",
         "lib_staging.ks", "lib_lambert.ks", "flightlog.ks"),
    list("node.ks", "circat.ks", "science.ks", "hop.ks"),
    list("fc.ks", "hohmann.ks", "capture.ks", "matchplanes.ks",
         "node_tune.ks", "dock.ks"),
    list("rendezvous.ks", "landat.ks", "basedock.ks", "grapple.ks",
         "launchwindow.ks", "deploy_fairings.ks", "antenna.ks",
         "rocket_launch.ks", "rlseq.ks", "ssto.ks", "planeland.ks")
).

clearscreen.
print "== kOS boot: " + ship:name + " ==".

//dead-man's switch: if this CPU rebooted (power loss?) while a script was
//managing time warp, nothing is slowing that warp anymore - kill it NOW
//before we sail months past whatever the script was warping toward.
if kuniverse:timewarp:rate > 1 {
    kuniverse:timewarp:cancelwarp().
    print "KAL: I blacked out mid-warp. Warp CANCELLED - check power".
    print "     and your maneuver node, then re-run node.".
}

if homeconnection:isconnected {
    switch to core:volume.
    local copied to 0.
    local current to 0.
    local skipped to 0.
    for tier in tiers {
        for f in tier {
            if exists("0:/" + f) {
                local srcsize to open("0:/" + f):size.
                if exists(f) and open(f):size = srcsize {
                    set current to current + 1.
                } else {
                    if exists(f) {
                        deletepath(f). //make room before checking space
                    }
                    if core:volume:freespace < 0 or core:volume:freespace >= srcsize + 64 {
                        copypath("0:/" + f, f).
                        set copied to copied + 1.
                    } else {
                        set skipped to skipped + 1.
                    }
                }
            }
        }
    }
    switch to 0. //normal ops run from the archive while connected
    print "local sync: " + copied + " copied, " + current + " current, "
          + skipped + " skipped (no space)".
    if skipped > 0 {
        print "  (small disk: top-priority tiers were synced first)".
    }
    print " ".
    print "run fc.   <- flight computer".
} else {
    switch to core:volume.
    print "NO COMMS - running from the local disk.".
    print "Synced scripts are available by name (e.g. run hop.)".
    print "Note: scripts that chain to others via 0:/ still need comms.".
}
