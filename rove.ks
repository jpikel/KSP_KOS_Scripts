@lazyglobal off.

clearscreen.

parameter targetSpeed to 3.   
parameter targetHeading to 0.
parameter targetWayPoint to 0.

main().

set ship:control:wheelthrottle to 0.
set ship:control:neutralize to true.
unlock all.
brakes on.

function main {
   lock currentSpeed to GROUNDSPEED.
   brakes off.
   local stop to 0.
   local ch to 0.
   local startTime to time:seconds.
                        //KP KI KD
   local drive to pidloop(1, 2, 0.25).
   set drive:maxoutput to 1.
   set drive:minoutput to -1.
   set drive:setpoint to targetSpeed.

   local steer to pidloop(0.2,0.0001,0.5).
   set steer:maxoutput to 1.
   set steer:minoutput to -1.

   local control to ship:control.

   local northPole to latlng(90,0).
   lock myHeading to mod(360 - northPole:bearing,360).
   lock myPitch to 90 - vectorangle(up:vector, ship:facing:forevector).
   local mainWayPoint to 0.
   if targetWayPoint {
      set targetHeading to calcBearingToWaypoint(targetWayPoint).
      set mainWayPoint to waypoint(targetWayPoint).
   }

   if not targetHeading {
      set targetHeading to round(mod(360 - northPole:bearing,360)).
   }

   set steer:setpoint to targetHeading.

   until stop {
      if terminal:input:haschar() {
         set stop to 1.
      }
      
      local out to drive:update(time:seconds, currentSpeed).
      local steerOut to steer:update(time:seconds, myHeading).
      set control:wheelsteer to -1*steerOut.
      set control:wheelthrottle to out.

      debug("Speed Setpoint:", targetSpeed, 0).
      debug("Current Speed :", currentSpeed, 1).
      debug("Target Heading: ", targetHeading, 2).
      debug("My Heading    : ", myHeading, 3).
      debug("My Pitch      : ", myPitch, 4).
      if targetWayPoint {  
         local newHeading to calcBearingToWaypoint(targetWayPoint).
         if abs(newHeading - targetHeading) > 3 {
            set targetHeading to newHeading.
            set steer:setpoint to targetHeading.
         }
         debug("Required Head  : ", calcBearingToWaypoint(targetWayPoint), 5).

         if abs((mainWayPoint:position - ship:position):mag) < 10 {
            debug("You have arrived at ", "targetWayPoint", 5).
            set stop to 1.
         }
      }
   }

   debug("Travel Time:", timeDiff(time:seconds - startTime), 6).
}

function timeDiff {
   parameter secs to 0.
   local hpd to kuniverse:hoursperday.
   if secs {
    local mins to floor(secs/60). set secs to round(mod(secs, 60)).
    local hrs to floor(mins/60). set mins to mod(mins, 60).
    local days to floor(hrs/hpd). set hrs to mod(hrs, hpd).
    return days + " days, " + hrs + " hrs, " + mins + " mins".
   }
   return "".
}
//https://www.dougv.com/2009/07/calculating-the-bearing-and-compass-rose-direction-between-two-latitude-longitude-coordinates-in-php/
function calcHeadToWaypoint {
   parameter wayPointText to 0.
   local thisWayPoint to waypoint(wayPointText).
   local lat2 to thisWayPoint:geoposition:lat.
   local lng2 to thisWayPoint:geoposition:lng.
   local lat1 to ship:geoposition:lat.
   local lng1 to ship:geoposition:lng.
   local dlat to lat2 - lat1.
   local dlng to lng2 - lng1.
   local y to sin(lng2 - lng1)*cos(lat2).
   local x to cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lng2-lng1).
   local wayPointHeading to -1.
   if y > 0 {
      if x > 0 { set wayPointHeading to arctan(y/x).}
      if x < 0 { set wayPointHeading to 180 - arctan((-y)/x). }
      if x = 0 { set wayPointHeading to 90. }
   }
   if y < 0 {
      if x > 0 { set wayPointHeading to -arctan((-y)/x).}
      if x < 0 { set wayPointHeading to arctan(y/x)-180. }
      if x = 0 { set wayPointHeading to 270. }
   }
   if y = 0 {
      if x > 0 { set wayPointHeading to 0. }
      if x < 0 { set wayPointHeading to 180. }
      if x = 0 { set targetSpeed to 0. }
   }
   return wayPointHeading.
}

function calcBearingToWaypoint {
   parameter wayPointText to 0.
   local thisWayPoint to waypoint(wayPointText).
   if wayPointText {
      local lat1 to thisWayPoint:geoposition:lat * constant:DegToRad.
      local lng1 to thisWayPoint:geoposition:lng * constant:DegToRad.
      local lat2 to ship:geoposition:lat * constant:DegToRad.
      local lng2 to ship:geoposition:lng * constant:DegToRad.
      local dLng to abs(abs(lng2) - abs(lng1)).
      local x to cos(lat2) * sin(dLng).
      local y to cos(lat1) * sin(lat2) - sin(lat1) * cost(lat2) * cos(dLng).
      return arctan2(x, y).
   }
   return 90.
}


function debug {
   parameter what.
   parameter this.
   parameter x.

   print what + " " + this at (0,x).
}