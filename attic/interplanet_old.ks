@lazyglobal off.


local SUNGRAV to SUN:MU.
local ORIGGRAV to SHIP:BODY:MU.
local PI to constant():PI.

function main {
   local destination to TARGET.
   local planet to BODY.  
   local r2 to TARGET:ORBIT:SEMIMAJORAXIS.
   local r1 to BODY:ORBIT:SEMIMAJORAXIS.
   local TOF to transferTime(r1, r2).
   local destDegrees to destDegreesTravelled(TOF, r2).
   displayTime(TOF).
   debug("Degrees travelled", destDegrees).
   local phaseAngle to calcPhaseAngle(TOF, r2).
   debug("Phase Angle", phaseAngle).
   local v1 to calcChangeVelocity(r1, r2).
   debug("dV", v1).
   local ev to calcEjectionVelocty.
   debug("Ejection Velocity", ev).
   local ea to calcEjectAngle(ev).
   debug("Ejection Angle", ea).

   local cV to ship:velocity:orbit:mag.

   local reqV to ev - v1 - cV.
   debug("Node velocty", reqV).

   local waitTime to calcWaitTime(TOF, r1, r2, ea).
   displayTime(waitTime).

   add NODE(TIME:SECONDS + waitTime,0,0,v1).
}

function calcWaitTime {
   parameter TOF to 0.
   parameter r1 to 0.
   parameter r2 to 0.
   parameter ejectionAngle to 0.

   local wait_time to 0.
   if TOF and HASTARGET and r1 and r2 {
      LOCAL tgt_ang_vel TO sqrt(SUNGRAV/r2^3).
      LOCAL intercept_ang_vel TO sqrt(SUNGRAV/r1^3).
      LOCAL intercept_lead_angle TO tgt_ang_vel*TOF.
      LOCAL phi_final TO constant():PI - intercept_lead_angle.
      LOCAL current_ang TO (TARGET:longitude - BODY:longitude)*(constant():PI/180).
      set wait_time TO (phi_final - current_ang)/(tgt_ang_vel - intercept_ang_vel).
      local v1 to POSITIONAT(SHIP, TIME:SECONDS + wait_time).
      local v2 to Kerbin:velocity:orbit - Sun:velocity:orbit.
      local vAng to vectorangle(v1, v2).
      print "Angle to Prograde: " + round(vAng, 2).



   }
   return wait_time.
}

function calcEjectAngle {
   parameter ev to 0.
   local r1 to SHIP:ORBIT:SEMIMAJORAXIS.
   if ev {
      local theta to ((ev ^ 2)/2) - (ORIGGRAV/r1).
      local h to r1 * ev.
      local epsilon to sqrt(1 + ((2 * theta * h^2)/(ORIGGRAV^2))).
      return 180 - arccos(1/epsilon).
   }
}

function calcChangeVelocity {
   parameter r1 to 0.
   parameter r2 to 0.
   if r1 and r2 {
      return sqrt((SUNGRAV/r1)) * (sqrt(((2 * r2) / (r1 + r2))) - 1).
   }
}

function calcEjectionVelocty {
   local r1 to SHIP:ORBIT:SEMIMAJORAXIS.
   local r2 to SHIP:BODY:SOIRADIUS.
   local v2 to sqrt(((2 * ORIGGRAV)/r1)).

   if r1 and r2 {
      return sqrt( (r1 * (r2 * (v2^2) - (2*ORIGGRAV)) + 2 * r2 * ORIGGRAV) / (r1 * r2)   ).
   }
}

function calcPhaseAngle {
   parameter time to 0.
   parameter radiusTwo to 0.
   if time and radiusTwo {
      return 180 - destDegreesTravelled(time, radiusTwo).
   }

}

function destDegreesTravelled {
   parameter time to 0.
   parameter radiusTwo to 0.

   if time and radiusTwo {
      return sqrt((SUNGRAV/radiusTwo)) * (time / radiusTwo) * (180 / PI).
   }
   return 0.
}

function transferTime {
   parameter bodyOne to 0.
   parameter bodyTwo to 0.

   if bodyOne and bodyTwo {
      local numer to (bodyOne + bodyTwo) ^ 3.
      local denom to (8 * SUNGRAV).
      local root to sqrt((numer / denom)).
      return PI * root.
   }

   return 0.
}

function debug {
   parameter what to "Tag".
   parameter this to 0.
   print what + " " + this.
}

function displayTime {
   parameter secs to 0.
   local hpd to kuniverse:hoursperday.
   if secs {
    local mins to floor(secs/60). set secs to round(mod(secs, 60)).
    local hrs to floor(mins/60). set mins to mod(mins, 60).
    local days to floor(hrs/hpd). set hrs to mod(hrs, hpd).
    print days + " days, " + hrs + " hrs, " + mins + " mins".
   }
}

if HASTARGET {
   main().
}
else {
   print "Please select a destination.".
}

