// Filename: geo.ks
// Description: start of a script that will calculate the geosynchronous altitude for a vessel
// to the body it is orbiting. Then uses the script change_alt.ks to create the maneuver node.
// needs more work

@lazyglobal off.





local GM to constant():G * ship:body:mass.
local day to ship:body:rotationperiod.

local sma to ((GM*day^2)/(4*constant():pi^2))^(1/3).
local geo_alt to sma - ship:body:radius.

runoncepath("0:/change_alt", geo_alt).
//local lock ship_period to ship:orbit:period.
//local lock third_sidereal to ship:body:rotationperiod / 3.

//lock steering to prograde.
//wait until eta:periapsis < 1.
//until ship_period > third_sidereal {
//    lock throttle to 1.
//    wait 0.1.
//}

//lock throttle to 0.
//unlock steering.
//unlock throttle.
