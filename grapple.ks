// Filename: grapple.ks
// Description: 


@lazyglobal off.

main().

declare function printDist {
    parameter dist.
    parameter relv.
    print "Dist: " + round(dist, 2) + "        " at (0,5).
    print "Relv: " + round(relv:mag, 3) + "       " at (0,6).
}
    
declare function translate {
    parameter vector.
    if vector:mag > 1 set vector to vector:normalized.

    set ship:control:fore to vector * ship:facing:forevector.
    set ship:control:starboard to vector * ship:facing:starvector.
    set ship:control:top to vector * ship:facing:topvector.
}

declare function main {
    sas off.
    rcs on.
    clearscreen.
    local grab to SHIP:partsdubbed("GrapplingDevice").
    local grabber to grab[0].
    local roll to 0.
    on AG10 {
        set roll to roll + 15.
        if roll > 365 set roll to 0.
        preserve.
    }

    Print "Facing the target".
    local lock steering to lookdirup(target:position, north:vector) + R(0,0,roll).
    wait until vang(ship:facing:forevector, target:position) < 2.
    approach(50,5, grabber).
    approach(15,2, grabber).
    approach(3,0.6, grabber).
    print "Drifting to grapple".
    lock steering to target:position.
    translate(V(0,0,0)).
    set ship:control:mainthrottle to 0.
    set ship:control:neutralize to True.
    wait 3.
    unlock steering.
    SAS on.
    RCS off.
}

declare function approach {
    parameter offset.
    parameter speed.
    parameter grabber.

    local lock targetVector to target:position - grabber:position.
    local lock relv to ship:velocity:orbit - target:velocity:orbit.
    until false or targetVector:mag < offset {
        if hastarget {
            translate((targetVector:normalized*speed) - relv).
            printDist(targetVector:mag, relv).
        } else {
            translate(V(0,0,0)).
            break.
        }
    }
}


