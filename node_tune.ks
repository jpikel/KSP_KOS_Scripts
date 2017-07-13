//Filename : node_tune.ks
//Description: Tune a node made with hohmann to a desired PERIAPSIS
//Good only for Celestial Body intercepts like the Mun
//Pass in a target periapsis and a time direction.  Meaning
//if a positive value is passed in it will delay the maneuver node
//a negative value will make the maneuver node earlier.


@LAZYGLOBAL OFF.
CLEARSCREEN.

PARAMETER TGT_PERIAPSIS IS -1.
PARAMETER TIME_DIRECTION IS +0.01.

IF TGT_PERIAPSIS < 0 {
    PRINT "ERROR - INVALID PERIAPSIS".
} ELSE {
    LOCAL ND_BACKUP TO NEXTNODE.
    LOCAL ND TO NEXTNODE.
    UNTIL ENCOUNTER:PERIAPSIS > TGT_PERIAPSIS {
        SET ND:PROGRADE TO ND:PROGRADE + TIME_DIRECTION.
        wait 0.001.
    }
    
    IF(ENCOUNTER:NAME = "None") {
        REMOVE ND.
        PRINT "ERROR - Something went wrong...".
        PRINT "Putting old node back... try again.".
        ADD ND_BACKUP.
    } ELSE {
        PRINT "Success Node updated.".
        PRINT "PE: " + ENCOUNTER:PERIAPSIS.
        PRINT "ETA:" + ROUND(ND:ETA, 2).
        PRINT "Dv: " + ROUND(ND:BURNVECTOR:MAG, 2).
    }
    
}
