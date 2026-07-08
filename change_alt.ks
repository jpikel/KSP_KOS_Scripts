// Filename: change_alt.ks
// Description: change orbital altitude - adds a Hohmann node (at periapsis to
// raise, at apoapsis to lower), optionally executes it and circularizes.
// target_alt is the ABSOLUTE altitude above the surface you want.
//
// Usage:
//   run change_alt.           interactive prompt
//   run change_alt(250000).   scripted: move to 250 km

@LAZYGLOBAL OFF.

parameter target_alt is "ask".

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("CHANGE ALTITUDE").

if ship:status <> "ORBITING" {
    print "Not in orbit.".
} else {
    ui_kv("current", round(apoapsis / 1000, 1) + " x " + round(periapsis / 1000, 1) + " km", 4).
    if target_alt:istype("String") {
        set target_alt to read_number("New altitude (m)", round(apoapsis), 5).
    }
    if ship:orbit:eccentricity > 0.1 {
        ui_kv("note", "orbit not circular - result will be approximate", 11).
    }

    local rad1 to ship:orbit:semimajoraxis.
    local tgt_sma to ship:body:radius + target_alt.
    local u to ship:body:mu.
    local dv to sqrt(u / rad1) * (sqrt((2 * tgt_sma) / (rad1 + tgt_sma)) - 1).

    local raising to tgt_sma > apoapsis + ship:body:radius.
    if raising {
        add node(time:seconds + eta:periapsis, 0, 0, dv).
    } else {
        add node(time:seconds + eta:apoapsis, 0, 0, dv).
    }
    ui_kv("burn 1", round(dv, 1) + " m/s at " + (choose "periapsis" if raising else "apoapsis"), 6).
    ui_kv("then", "circularize at the new " + (choose "apoapsis" if raising else "periapsis"), 7).

    local c to read_menu("Execute both burns now?", list(
        "yes - burn and circularize",
        "no - just leave the node"), 9).
    if c = 0 {
        runpath("0:/node").
        runpath("0:/circat", choose "ap" if raising else "pe").
        runpath("0:/node").
        clearscreen.
        ui_header("ALTITUDE CHANGE COMPLETE").
        ui_kv("orbit", round(apoapsis / 1000, 1) + " x " + round(periapsis / 1000, 1) + " km", 4).
    }
}
