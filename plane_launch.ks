// Filename: plane_launch.ks
// Description: spaceplane launch for the Ares style spaceplane
// must have Rapier engines  
// hopefully this will become a universal launch script for spaceplanes

@LAZYGLOBAL OFF.
PARAMETER tgt_Ap IS 75000.
PARAMETER tgt_hd IS 90.
DECLARE GLOBAL turnEnd TO 50000.
DECLARE GLOBAL turnExponent TO 0.5.
CLEARSCREEN.

    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0. //set throttle to 0
    SAS OFF.                                //turn off SAS
    LOCAL Rapier_List TO SHIP:PARTSNAMED("Rapier").
    LOCK RapierThrust TO Rapier_List[0]:THRUST.
    
     //calculate pitch
    LOCK result TO 90 * (1 - (ALTITUDE / turnEnd)^turnExponent). 
    LOCK targetPitch TO MAX(1, result).

    //calculate current pitch above horizon.
    LOCK cur_pitch TO 90 - VANG(UP:VECTOR, SHIP:FACING:FOREVECTOR).

    //PID loop set up
    LOCAL Kp TO 0.06.
    LOCAL Ki TO 0.25.
    LOCAL Kd TO 0.1.
    
    LOCAL PID TO PIDLOOP(Kp, Ki, Kd).
    SET PID:SETPOINT TO 5. //initial set point of 5 degrees pitch.
        
    GLOBAL ship_Pi TO 0.25.
    LOCAL ship_Hd TO 90.45.
    LOCK THROTTLE TO 1.0.
    LOCK WHEELSTEERING TO ship_Hd.
    LOCK STEERING TO HEADING (ship_Hd, ship_Pi).
    WAIT 2.
    STAGE.
    WAIT 4.
    BRAKES OFF.
    PRINT "Status: " AT (0,0).
    PRINT "Launch commencing" AT (9,0).
    PRINT "Target Ap: " + tgt_Ap AT (0,1).

    WAIT UNTIL SHIP:AIRSPEED > 100.
    SET ship_Pi TO 1.
    PRINT "Pitch to " + ship_Pi + "          " AT (9,0).
    
    WAIT UNTIL SHIP:STATUS = "FLYING".
    PRINT "Wheels UP        " AT(9,0).
    UNLOCK WHEELSTEERING.
    GEAR OFF.
    SET ship_Hd TO tgt_hd.
    SET PID:SETPOINT TO 5.
    UNTIL SHIP:ALTITUDE > 200 {
        SET ship_Pi TO PID:UPDATE(TIME:SECONDS, cur_pitch).
        WAIT 0.1.
    }
    PRINT "Pitch TO 20      " AT (9,0).
    SET PID:SETPOINT TO 20.
    UNTIL RapierThrust < 180 {
        SET ship_Pi TO PID:UPDATE(TIME:SECONDS, cur_pitch).
        WAIT 0.01.
    }
    
    AG1 ON.
    PRINT "Switching Rapiers" AT (0,2).

    UNTIL SHIP:ALTITUDE > 24000 {
        SET ship_Pi TO PID:UPDATE(TIME:SECONDS, cur_pitch).
        WAIT 0.01.
    }
    AG2 ON.
    PRINT "Jet engines shutdown" AT (0,3).
    
    WAIT UNTIL cur_pitch > targetPitch.
    
    UNTIL APOAPSIS > tgt_Ap {
        SET ship_Pi TO targetPitch.
        WAIT 0.01.
    }

    LOCK THROTTLE TO 0.
    LOCK STEERING TO SHIP:PROGRADE.
    PRINT "Coasting TO space  " AT (9,0).
    WAIT UNTIL SHIP:ALTITUDE > 70000.

    UNLOCK STEERING.
    UNLOCK THROTTLE.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
