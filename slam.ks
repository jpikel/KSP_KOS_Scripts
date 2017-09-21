// Filename: slam.ks
// Description: a hover slam esk script that iterates through the predicted future position of the ship
// to find the location that is below the terrain height.  Uses the time to this location to know when to
// start the burn.  Throttle is a function of the two times divided.
// Works for inclined landings as well.
// Reference: https://github.com/mrbradleyjh/kOS-Hoverslam/blob/master/hoverslam.ks
// Requires: lib_physics.ks


@lazyglobal off.
// landing burn
// configuration
clearscreen.

run lib_physics.ks.

gear on.

sas off.


declare global fuelMass to 0.


getFuelMass().
// physics
local mass0 to ship:mass.
lock initialdecel to (ship:maxthrust / ship:mass) - g_here().    // max deceleration of the vehicle 
lock initialstoptime to velocity:surface:mag / initialdecel.           // time to kill surface velocity
lock maxdecel to (ship:maxthrust / (ship:mass - abs(getMassBurned(initialstoptime)))).
lock stoptime to ((abs(ship:verticalspeed) + abs(ship:groundspeed))/2) / maxdecel.
lock impacttime to time_to_impact(stoptime).                       // time to impact with the current velocity
// state variables
wait until ship:verticalspeed < -1.
print "preparing for landing burn...".
lock steering to srfretrograde.
lock time1 to stoptime.
lock time2 to impacttime.
lock idealthrottle to time1/time2.                  // hoverslam throttling setting
lock shipHeightAboveTerrain to ship:altitude - abs(ship_bottom) - abs(ship:geoposition:terrainheight).

until ship:status = "landed" OR shipHeightAboveTerrain < 5 {
    printdata(time1, time2, shipHeightAboveTerrain).
    if(time1 > time2) {
        print "burn has begun!" at (0,2).
        lock throttle to idealthrottle.
    }
    if( vang(ship:up:vector, srfretrograde:vector) < 2 ){
        lock steering to up + r(0,0,-90).
    }
}
print "landed!".
lock throttle to 0.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
unlock steering.
sas on.

print "mass0: " + round(mass0,2) at (0,10).
print "mass1: " + round(ship:mass, 2) at (0,11).
print "diff : " + round((mass0 - ship:mass), 2) at (0,12).


declare function printdata {
    parameter time1.
    parameter time2.
    parameter shipHeight.
    print "combined velocity: " + round((abs(ship:verticalspeed)+abs(ship:groundspeed)/2), 2) at (0,3).
    print "estimated stop time: " + round(time1,2) at (0,4).
    print "estimated impact time: " + round(time2, 2) at (0,5).
    print "current ship altitude: " + round(shipHeight, 2) at (0,6).

}

declare function getMassBurned {
    parameter secondsBurned.
    local myengines to list().
    local isp to 0.
    local unitsFuel to 0.
    local numEngines to 0.

    list engines in myengines.    
    for eng in myengines {
        set isp to isp + eng:isp.
        set numEngines to numEngines + 1.
    }
    set isp to isp / numEngines.

    set unitsFuel to (ship:maxthrust/isp) * 20.4 * secondsBurned.
    print "Fuel mass: " + round((unitsFuel * fuelMass),2) at (0,8).
    return unitsFuel * fuelMass.
}

declare function getFuelMass {
    local fuels to list().
    set fuels to stage:resources.

    for rsc in fuels {
        if (rsc:name = "LIQUIDFUEL"){
            set fuelMass to fuelMass + rsc:density.
        } else if (rsc:name = "OXIDIZOR"){
            set fuelMass to fuelMass + rsc:density.
        }
    }
    print "Fuel density: " + round(fuelMass,3) at (0,9).
}
