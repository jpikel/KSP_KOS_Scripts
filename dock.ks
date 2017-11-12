// Filename: dock.ks
// Description: 


@lazyglobal off.

parameter localport is "a".
main(localport).

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

declare function draw {
    parameter vector.
    clearvecdraws().
    vecdraw(V(0,0,0), vector, RGB(0,0,1), "Move here", 1, true, 0.2).
}

declare function moveTopFront {
    parameter offset.
    parameter speed.
    parameter hostPort.
    parameter thatPort.

    print "MoveTopFront".
    local lock starVec to thatPort:portFacing:starvector.
    local lock frtVec to thatPort:portFacing:forevector.

    local lock distOffset to angleaxis(45,starVec) * frtVec * offset.
    local lock moveVector to thatPort:position - hostPort:position + distOffset.
    local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
    until false {
        translate((moveVector:normalized * speed) - relv).
        printDist(moveVector:mag, relv).
        if moveVector:mag < 2 {
            translate(V(0,0,0)).
            break.
        }
    }
}

declare function moveToTop {
    parameter offset.
    parameter speed.
    parameter hostPort.
    parameter thatPort.

    local lock sideDir to thatPort:portfacing:topvector.

    local lock distOffset to sideDir * offset.
    local lock moveVector to thatPort:position - hostPort:position + distOffset.
    local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
    until false {
        translate((moveVector:normalized * speed) - relv).
        draw(moveVector).
        printDist(moveVector:mag, relv).
        if moveVector:mag < 2 {
            translate(V(0,0,0)).
            break.
        }
    }

}


declare function approach {
    parameter offset.
    parameter speed.
    parameter hostPort.
    parameter thatPort.

    local lock distOffset to thatPort:portfacing:vector * offset.
    local lock targetVector to thatPort:position - hostPort:position + distOffset.
    local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
    until hostPort:state <> "Ready" {
        translate((targetVector:normalized*speed) - relv).
        local distVector to (thatPort:position - hostPort:position).
        printDist(targetVector:mag, relv).
        draw(targetVector).
        if vang(hostPort:portfacing:vector, distVector)<2 and abs(offset-distVector:mag) < 0.1{
            translate(V(0,0,0)).
            break.
        }
    }
}

declare function main {
    parameter localport is "a".
    sas off.
    rcs on.
    clearscreen.

    local ports to ship:partsdubbed(localport).
    if ports:length > 0 {
        local hostPort to ports[0].
        hostPort:controlfrom().
        local thatPort to target.
        local r to 0.
        on AG9 {
            set r to r - 7.5.
            if r < 0 set r to 365.
            preserve.
        }

        on AG10 {
            set r to r + 7.5.
            if r > 365 set r to 0.
            preserve.
        }
        Print "Facing the target".
        lock steering to lookdirup(thatPort:portfacing:vector*-1, north:vector)+R(0,0,r).
        wait until vang(ship:facing:forevector, thatPort:portfacing:vector*-1) < 2.
        approach(10,1.5, hostPort, thatPort).
        approach(10,1, hostPort, thatPort).
        approach(8,1, hostPort, thatPort).
        approach(8,0.8, hostPort, thatPort).
        approach(6,0.8, hostPort, thatPort).
        approach(6,0.7, hostPort, thatPort).
        approach(4,0.6, hostPort, thatPort).
        approach(4,0.5, hostPort, thatPort).
        approach(2,0.3, hostPort, thatPort).
        approach(2,0.3, hostPort, thatPort).
        approach(0,0.3, hostPort, thatPort).
        translate(V(0,0,0)).
        set ship:control:mainthrottle to 0.
        set ship:control:neutralize to True.
        unlock steering.
        SAS on.
        RCS off.
        clearvecdraws().

    }
}
