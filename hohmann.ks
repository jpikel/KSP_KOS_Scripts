//Filename: hohmann.ks
//Description: calculates a hohmann transfer to another body or vessel as the target that is orbiting the
// same reference body.  Works fairly well.
// Use this frequently in the Kerbin system.  
// Does not work for interplanetary maneuver
//reference https://www.faa.gov/other_visit/aviation_industry/designees_delegations/designee_types/ame/media/Section%20III.4.1.5%20Maneuvering%20in%20Space.pdf

@LAZYGLOBAL OFF.

clearscreen.
//precondtions: circular equatorial orbit, target has circular orbit.
PARAMETER tgt_periapsis is 0.

function run_hohmann{
    LOCAL rad1 TO SHIP:ORBIT:SEMIMAJORAXIS.
    LOCAL tgt_sma to TARGET:ORBIT:SEMIMAJORAXIS.
    LOCAL u to SHIP:BODY:MU.
    LOCAL dv TO sqrt((u/rad1))*((sqrt((2*tgt_sma)/(rad1+tgt_sma))) - 1 ).
    LOCAL TOF TO constant():PI * sqrt((((tgt_sma+rad1)/2)^3)/target:body:MU).
    LOCAL tgt_ang_vel TO sqrt(target:body:MU/tgt_sma^3).
    LOCAL intercept_ang_vel TO sqrt(ship:body:MU/ship:orbit:semimajoraxis^3).
    LOCAL intercept_lead_angle TO tgt_ang_vel*TOF.
    LOCAL phi_final TO constant():PI - intercept_lead_angle.
    LOCAL current_ang TO (target:longitude - ship:longitude)*(constant():PI/180).
    LOCAL wait_time TO (phi_final - current_ang)/(tgt_ang_vel - intercept_ang_vel).
    LOCAL x_var to 1.
    LOCAL prev_time TO wait_time.
    if wait_time < 0 {
        until wait_time > 0 {
            set wait_time TO (x_var*2*constant():PI + phi_final - current_ang)/(tgt_ang_vel - intercept_ang_vel).
            set x_var TO x_var + 1.
            if (wait_time < prev_time) {
                break.
            }
            SET prev_time TO wait_time.
        }
        set x_var TO 1.
        until wait_time > 0 {
            set wait_time TO (phi_final - current_ang - x_var*2*constant():PI)/(tgt_ang_vel - intercept_ang_vel).
            set x_var TO x_var + 1.
            SET prev_time TO wait_time.
        }
    }

    add NODE(TIME:SECONDS + wait_time,0,0,dv).
  
   print "**********************".
   print "Node Added.".
   print "TOF: " + TOF.
   print "ETA: " + NEXTNODE:ETA.
   print "Wait: " + wait_time.
   print "Dv: " + dv.
   print "Tgt Ang Vel: " + tgt_ang_vel.
   Print "Int Ang Vel: " + intercept_ang_vel.
   Print "Int Lead Ang: " + intercept_lead_angle.
   Print "Phi Final: " + phi_final.
   Print "Curr Ang: " + current_ang.
   print "***********************".
}

run_hohmann().



