// Filename: dock.ks
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

declare function draw {
    parameter vector.
    clearvecdraws().
    vecdraw(V(0,0,0), vector, RGB(0,0,1), "Move here", 1, true, 0.2).
}

declare function cancelRelv {
    Print "Cancelling relative velocity to taget".
    lock steering to target:ship:velocity:orbit - ship:velocity:orbit.
    wait until vang(target:ship:velocity:orbit, ship:velocity:orbit) < 5.
    local lock relv to target:ship:velocity:orbit - ship:velocity:orbit.
    until false {
        local lastDiff to (target:ship:velocity:orbit - ship:velocity:orbit):mag.
        set ship:control:mainthrottle to min(1,relv:mag).
        print "Relv: " + round(relv:mag, 3) + "       " at (0,6).
        if relv:mag > lastDiff {
            unlock steering.
            set ship:control:mainthrottle to 0.
            break.
        }
    }
    unlock steering.
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
        if vang(hostPort:portfacing:vector, distVector) < 2 and abs(offset - distVector:mag) < 0.1{
            translate(V(0,0,0)).
            break.
        }
    }
}

declare function main {
    sas off.
    rcs on.
    clearscreen.

    local ports to ship:partsdubbed("thisPort").
    if ports:length = 0 {
        set ports to ship:partsdubbed("dockingPort1").
        if ports:length = 0 {
            set ports to ship:partsdubbed("dockingPort2").
        }
    }
    local hostPort to ports[0].
    hostPort:controlfrom().

    local thatPort to 0.
    set thatPort to target.
    local roll to 0.
    //cancelRelv().
    on AG10 {
        set roll to roll + 15.
        if roll > 365 set roll to 0.
        preserve.
    }
    Print "Facing the target".
    local lock steering to lookdirup(thatPort:portfacing:vector*-1, north:vector) + R(0,0,roll).
    wait until vang(ship:facing:forevector, thatPort:portfacing:vector*-1) < 0.5.
    moveToTop(10,0.5,hostPort, thatPort).
    wait 0.1.
    moveToTop(8,0.5,hostPort, thatPort).
    wait 0.1.
    moveToTop(6,0.5,hostPort, thatPort).
    wait 0.1.
    moveToTop(4,0.4,hostPort, thatPort).

//    moveTopFront(50,2,hostPort, thatPort).
    //approach(40,1, hostPort, thatPort).
//    approach(30,1, hostPort, thatPort).
  //  approach(20,0.8, hostPort, thatPort).
    //approach(10,0.4, hostPort, thatPort).
//    approach(8,0.4, hostPort, thatPort).
  // approach(6,0.4, hostPort, thatPort).
    approach(2,0.4, hostPort, thatPort).
    wait 0.1.
    approach(2,0.4, hostPort, thatPort).
    wait 0.1.
    approach(1, 0.3, hostPort, thatPort).
    wait 0.1.
    approach(1, 0.3, hostPort, thatPort).
    wait 0.1.
    approach(0.5,0.2, hostPort, thatPort).
    wait 0.1.
    approach(0.5,0.2, hostPort, thatPort).
    wait 0.1.
    approach(0,0.2, hostPort, thatPort).
    translate(V(0,0,0)).
    set ship:control:mainthrottle to 0.
    set ship:control:neutralize to True.
    unlock steering.
    SAS on.
    RCS off.
    clearvecdraws().
}
