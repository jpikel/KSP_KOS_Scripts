@lazyglobal off.

local FLIGHT_TIME to 525. //8 minutes to ap
local SHIP_DEG_TRAVELLED to 70. //we travel approximately 70 degrees longitude

local kerbin_circ to 2 * constant:pi * target:orbit:semimajoraxis.
print "Orbital circumference: " + round(kerbin_circ, 2) at (0,0).

local target_speed to target:velocity:orbit:mag.
print "Target orbital speed: " + round(target_speed, 2) at (0,1).

//local period to kerbin_circ / target_speed.
local period to target:orbit:period.
print "Period: " + round(period, 2) at(0,2).

local degrees_per_sec to 360/period.
print "Deg per sec: " + round(degrees_per_sec, 4) at (0,3).

local degrees_travelled to degrees_per_sec * FLIGHT_TIME.
print "Estimated degrees travelled: " + round(degrees_travelled, 4) at (0,4).

local ship_lng to ship:geoposition:lng.
print "Ship Longitude: " + ship_lng at (0,5).

local start_lng_target to ship_lng + SHIP_DEG_TRAVELLED - degrees_travelled.

print "Station start longitude: " + start_lng_target at (0,6).

local target_current_lng to target:geoposition:lng.
print "Current target longitude: " + target_current_lng at (0,7).

local wait_time to 0.

if target_current_lng < 0 and target_current_lng > start_lng_target {
    set wait_time to abs(target_current_lng) / degrees_per_sec.
    set wait_time to wait_time + (180 / degrees_per_sec).
    set wait_time to wait_time + ((180 + start_lng_target) / degrees_per_sec).
}
else if target_current_lng > 0 {
    set wait_time to (180 - target_current_lng) / degrees_per_sec.
    set wait_time to wait_time + ((180 + start_lng_target) / degrees_per_sec).
}
else {
 set wait_time to (abs(target_current_lng) - abs(start_lng_target)) / degrees_per_sec.
}

local kerbin_period to ship:body:rotationperiod.
local kerbin_deg_per_sec to 360/kerbin_period.
local kerbin_deg_travelled to kerbin_deg_per_sec * wait_time.
set wait_time to wait_time + (kerbin_deg_travelled / degrees_per_sec).


print "Wait time: " + wait_time at (0,8).
local t1 to time:seconds + wait_time.
warpto(time:seconds + wait_time).
wait until time:seconds > t1.
print target:geoposition:lng.
until target:geoposition:lng >= start_lng_target {
print "Current target longitude: " + target:geoposition:lng + "         " at (0,7).
}
runoncepath("0:/s2l.ks").
