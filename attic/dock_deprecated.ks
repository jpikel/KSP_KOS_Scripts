// Filename: dock.ks
// Description: 


@lazyglobal off.

parameter localport is "dock_here".
main(localport).

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


declare function print_screen {
    parameter speed.
    parameter offset.
    parameter rotation.
    parameter final_vector.
    print "Speed: " + speed + "     " at (0,1).
    print "Offset: " + offset + "     " at (0,2).
    print "Rotation: " + rotation + "     " at (0,3).
    print "Vector: " + final_vector + "     " at (0,4).
    print "Vector Mag: " + final_vector:mag + "     " at (0,5).
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
        print "Facing the target" at (0,0).
        local rotation to 0.
        local offset to 10.
        local speed to 2.
        lock steering to lookdirup(thatPort:portfacing:vector*-1, north:vector)+R(0,0,rotation).
        wait until vang(ship:facing:forevector, thatPort:portfacing:vector*-1) < 2.
        local lock distOffset to thatPort:portfacing:vector * offset.
        local lock targetVector to thatPort:position - hostPort:position + distOffset.
        local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
        until hostPort:haspartner {

            if terminal:input:haschar {
                local ch to terminal:input:getchar().
                if ch = "8" {
                    set offset to offset - 1.
                }
                else if ch = "2" {
                    set offset to offset + 1.
                }
                else if ch = "4" {
                    set rotation to rotation + 7.5.
                }
                else if ch = "6" {
                    set rotation to rotation - 7.5.
                }
                else if ch = "9" {
                    set speed to speed + 0.2.
                }
                else if ch = "3" {
                    set speed to speed - 0.2.
                }
                else if ch = terminal:input:ENDCURSOR {
                    set done to true.
                }
                if offset < 0 set offset to 0.
                if rotation < 0 set rotation to 365.
                if rotation > 365 set rotation to 0.
                if speed < 0 set speed to 0.

            }
            local final_vector to (targetVector:normalized*speed) - relv.
            local distVector to thatPort:position - hostPort:position.
            translate(final_vector).
            print_screen(speed, offset, rotation, final_vector).
            vecdraw(V(0,0,0), targetVector, RGB(0,0,1), "Move here", 1, true, 0.2).
            vecdraw(V(0,0,0), final_vector, RGB(0,1,0), "Final_vector", 1, true, 0.2).
            clearvecdraws().
        }
        set ship:control:mainthrottle to 0.
        set ship:control:neutralize to True.
        unlock steering.
        SAS on.
        RCS off.
        clearvecdraws().

    }
}

// declare function printDist {
//     parameter dist.
//     parameter relv.
//     // print "Dist: " + round(dist, 2) + "        " at (0,5).
//     // print "Relv: " + round(relv:mag, 3) + "       " at (0,6).
// }
    
// declare function approach {
//     parameter offset.
//     parameter speed.
//     parameter hostPort.
//     parameter thatPort.

//     local lock distOffset to thatPort:portfacing:vector * offset.
//     local lock targetVector to thatPort:position - hostPort:position + distOffset.
//     local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
//     until hostPort:state <> "Ready" {
//         if (targetVector:normalized * speed):mag < 2 {
//             set speed to max(0.2, speed / 2).
//         }
//         if terminal:input:haschar {
//             local ch to terminal:input:getchar().
//             if ch = "8" {
//                 set offset to offset - 0.2.
//             }
//             else if ch = "2" {
//                 set offset to offset + 0.2.
//             }
//             else if ch = "4" {
//                 set rotation to rotation + 7.5.
//             }
//             else if ch = "6" {
//                 set rotation to rotation - 7.5.
//             }
//             else if ch = "9" {
//                 set speed to speed + 0.25.
//             }
//             else if ch = "3" {
//                 set speed to speed - 0.25.
//             }
//             else if ch = terminal:input:ENDCURSOR {
//                 set done to true.
//             }
//             if distance < 0 set distance to 0.
//             if rotation < 0 set rotation to 365.
//             if rotation > 365 set rotation to 0.
//             if speed < 0 set speed to 0.

//         }
//         local final_vector = (targetVector:normalized*speed) - relv.
//         translate(final_vector).
//         local distVector to thatPort:position - hostPort:position.
//         print_screen(speed, distance, rotation, final_vector).
//         // printDist(targetVector:mag, relv).
//         draw(targetVector).
//         if vang(hostPort:portfacing:vector, distVector)<2 and abs(offset-distVector:mag) < 0.2 {
//             translate(V(0,0,0)).
//             break.
//         }
//     }
// }


// declare function moveTopFront {
//     parameter offset.
//     parameter speed.
//     parameter hostPort.
//     parameter thatPort.

//     print "MoveTopFront".
//     local lock starVec to thatPort:portFacing:starvector.
//     local lock frtVec to thatPort:portFacing:forevector.

//     local lock distOffset to angleaxis(45,starVec) * frtVec * offset.
//     local lock moveVector to thatPort:position - hostPort:position + distOffset.
//     local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
//     until false {
//         translate((moveVector:normalized * speed) - relv).
//         printDist(moveVector:mag, relv).
//         if moveVector:mag < 2 {
//             translate(V(0,0,0)).
//             break.
//         }
//     }
// }

// declare function moveToTop {
//     parameter offset.
//     parameter speed.
//     parameter hostPort.
//     parameter thatPort.

//     local lock sideDir to thatPort:portfacing:topvector.

//     local lock distOffset to sideDir * offset.
//     local lock moveVector to thatPort:position - hostPort:position + distOffset.
//     local lock relv to ship:velocity:orbit - thatPort:ship:velocity:orbit.
//     until false {
//         translate((moveVector:normalized * speed) - relv).
//         draw(moveVector).
//         printDist(moveVector:mag, relv).
//         if moveVector:mag < 2 {
//             translate(V(0,0,0)).
//             break.
//         }
//     }

// }