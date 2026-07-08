//Physics Library.  
//Author: Johannes Pikel
//Description: Library of physics functions that may be called.
//To include in another script run lib_physics.ks

@LAZYGLOBAL OFF.


declare function distance {
   return ship:altitude + ship:body:radius.
}

//Function: weight
//Parameters: none
//Description: gravitational FORCE on the ship at the current location, in kN
//(ship:mass is in metric tons, so G*m1*m2/r^2 comes out in kN, matching thrust units).

declare function weight {
   return constant():G * (ship:mass * ship:body:mass) / (distance()^2).
}

//Function: g_here
//Parameters: none
//Description: gravitational ACCELERATION at the current location, in m/s^2.

declare function g_here {
    return ship:body:mu / (distance()^2).
}

//Function:Fg_here
//Parameters: none
//Description: returns the force upon the ship due to the gravity at the current location, in kN.
//Reference:https://www.youtube.com/watch?v=BYE-V6luP0U

declare function fg_here {
    return weight().
}


//Function: ship_twr
//Parameters: none
//Description: thrust-to-weight ratio (dimensionless), both in kN.

declare function ship_twr {
    return ship:availablethrust / Fg_here().
}
//Function:
//Parameters:
//Description:
//Postconditions:

declare function grav_standard {
        return 9.80665.
}
//Function:
//Parameters:
//Description:
//Postconditions:

declare function stand_grav_param {
    return SHIP:BODY:MU / SHIP:BODY:RADIUS^2. //standard gravitational parameter
}
//Function:
//Parameters:
//Description:
//Postconditions:

declare function find_ship_bottom {
    Local partsList to List().
    list parts in partsList.
    local least_offset to 0.
    local lowest_part to 0.
    for each in partslist {
        if facing:vector*each:position < least_offset {
            set least_offset to facing:vector*each:position.
            set lowest_part to each.
        }
    }
    return abs(least_offset).
}

declare global ship_bottom to find_ship_bottom().

//Function:
//Parameters:
//Description:
//Postconditions:

declare function time_to_impact {
    parameter stoptime.
    local myship to ship.
    local pos to 0.
    local actual to 0.

    set pos to positionat(myship,time:seconds+stoptime).
    set actual to ship:body:altitudeof(pos) - abs(ship_bottom) - abs(ship:body:geopositionof(pos):terrainheight).
    print "Actual: " + round(actual,2) at (0,7).
    return actual/abs(ship:verticalspeed).
}

//Function:
//Parameters:
//Description:
//Postcondition:

declare function find_ship_length {
    Local partsList to List().
    list parts in partsList.
    local least_offset to 0.
    local most_offset to 0.
    local lowest_part to 0.
    local highest_part to 0.
    for each in partslist {
        if facing:vector*each:position < least_offset {
            set least_offset to facing:vector*each:position.
            set lowest_part to each.
        }
        if facing:vector*each:position > most_offset {
            set most_offset to facing:vector*each:position.
            set highest_part to each.
        }
    }
    return (abs(most_offset)+abs(least_offset)).
}
