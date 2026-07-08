//Filename: capture.ks
//Description: adds a retrograde capture node at the next periapsis, braking
//the current (hyperbolic arrival or elliptical) orbit into an ellipse with a
//chosen apoapsis. Cheapest way to arrive: burn only what capture needs.
//If a moon orbits this body, its altitude is offered as the default apoapsis
//(e.g. arriving at Eve -> default apoapsis at Gilly's orbit).
//
// Usage:
//   run capture.             interactive prompt
//   run capture(31500000).   scripted: capture to a 31,500 km apoapsis
// Execute the node with node.ks.

@LAZYGLOBAL OFF.

parameter tgt_ap is "ask".  //apoapsis (m above surface... no: RADIUS-ALTITUDE, see below)

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.

if ship:orbit:hasnextpatch = false and ship:orbit:eccentricity < 1 and ship:apoapsis > 0 and ship:apoapsis < ship:body:soiradius {
    print "Already captured (Ap " + round(ship:apoapsis / 1000) + " km) - use hohmann or circat instead.".
} else if eta:periapsis <= 0 {
    print "No upcoming periapsis found - are we on an escape trajectory outbound?".
} else {
    //default apoapsis: the first moon's orbit if this body has one
    local default_ap to ship:body:soiradius * 0.4.
    local bl to list().
    list bodies in bl.
    for b in bl {
        if b:hasbody and b:body = ship:body {
            set default_ap to b:orbit:semimajoraxis - ship:body:radius.
            break.
        }
    }

    ui_header("CAPTURE AT " + ship:body:name).
    ui_kv("periapsis", round(ship:periapsis / 1000) + " km in " + ui_time(eta:periapsis), 4).
    if tgt_ap:istype("String") {
        set tgt_ap to read_number("Capture apoapsis altitude (m)", round(default_ap), 6).
    }

    local mu to ship:body:mu.
    local t_pe to time:seconds + eta:periapsis.
    local r_pe to ship:periapsis + ship:body:radius.
    local r_ap to tgt_ap + ship:body:radius.
    local v_now to velocityat(ship, t_pe):orbit:mag.
    local a_new to (r_pe + r_ap) / 2.
    local v_want to sqrt(mu * (2 / r_pe - 1 / a_new)).

    add node(t_pe, 0, 0, v_want - v_now).

    ui_kv("capture dv", round(v_want - v_now, 1) + " m/s (retrograde)", 8).
    ui_kv("new orbit", round(ship:periapsis / 1000) + " x " + round(tgt_ap / 1000) + " km", 9).
    print "next: run node to execute the capture burn" at (0, 11).
}
