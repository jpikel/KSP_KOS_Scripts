//Filename: timewarp.ks
//Description: warp-to menu - node minus a margin, apoapsis, periapsis, SOI
//transition, or a custom number of seconds. The little tool every mission
//reaches for ten times.
//
// Usage: run timewarp.

@LAZYGLOBAL OFF.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("TIME WARP").

local opts to list().
local acts to list(). //seconds-from-now for each option
if hasnode {
    opts:add("node minus 2 min  (in " + ui_time(nextnode:eta) + ")").
    acts:add(nextnode:eta - 120).
}
if ship:orbit:eccentricity < 1 and apoapsis > 0 {
    opts:add("apoapsis  (in " + ui_time(eta:apoapsis) + ")").
    acts:add(eta:apoapsis - 15).
}
if periapsis > body:atm:height or ship:orbit:eccentricity >= 1 {
    opts:add("periapsis  (in " + ui_time(eta:periapsis) + ")").
    acts:add(eta:periapsis - 15).
}
if ship:orbit:hasnextpatch {
    opts:add("SOI change  (in " + ui_time(eta:transition) + ")").
    acts:add(eta:transition - 30).
}
opts:add("custom seconds from now").
acts:add(-1).
opts:add("cancel").
acts:add(-2).

local c to read_menu("Warp to:", opts, 4).
local dt to acts[c].
if dt = -1 {
    set dt to read_number("Seconds from now", 600, 4 + opts:length + 2).
}
if dt > 0 {
    warpto(time:seconds + dt).
    wait until warp = 0 and ship:unpacked.
    ui_kv("status", "arrived", 4 + opts:length + 2).
}
