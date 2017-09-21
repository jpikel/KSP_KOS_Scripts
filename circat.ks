// Filename: circ_at.ks
// Description: adds a maneuver node at the given passed in parameter
// "pe" is periapsis and "ap" is apoapsis.  The maneuver should circularize
// the vessel at the given location

@LAZYGLOBAL OFF.
clearscreen.

//function: circ_pe and circ_ap
//description: defaults to circularizing at apoapsis
//


parameter choice is "ap".


function circ_pe {
    //circularize node at pe
    local radius_ap to (apoapsis + ship:body:radius).
    local radius_pe to periapsis + ship:body:radius.

    local ecc to 1 - ( 2 / ((radius_ap / radius_pe) + 1 )).
    local sma to (radius_pe + radius_ap)  / 2.	//semi-major axis

    local velocity_ap to sqrt(((1 - ecc) * body:mu) / ((1 + ecc) * sma)).
    local velocity_pe to sqrt(((1 + ecc) * body:mu) / ((1 - ecc) * sma)).

    local circdv to sqrt(body:mu / radius_pe) - velocity_pe.

    add node(time:seconds + eta:periapsis, 0 ,0, circdv).
}

function circ_ap {
    //circularize node at ap
    local radius_ap to (apoapsis + ship:body:radius).
    local radius_pe to periapsis + ship:body:radius.

    local ecc to 1 - ( 2 / ((radius_ap / radius_pe) + 1 )).
    local sma to (radius_pe + radius_ap)  / 2.    //semi-major axis

    local velocity_ap to sqrt(((1 - ecc) * body:mu) / ((1 + ecc) * sma)).
    local velocity_pe to sqrt(((1 + ecc) * body:mu) / ((1 - ecc) * sma)).

    local circdv to sqrt(body:mu / radius_ap) - velocity_ap.

    add node(time:seconds + eta:apoapsis, 0 ,0, circdv).
}

if (choice = "pe"){
    circ_pe().
} else {
    circ_ap().
}
