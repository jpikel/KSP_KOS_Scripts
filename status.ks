clearscreen.
//the following are all vectors, mainly for use in the roll, pitch, and angle of attack calculations 

lock rightrotation to ship:facing*r(0,90,0).

lock right to rightrotation:vector. //right and left are directly along wings

lock left to (-1)*right.

lock thisUP to ship:up:vector. //up and down are skyward and groundward

lock down to (-1)*thisUP.

lock fore to ship:facing:vector. //fore and aft point to the nose and tail

lock aft to (-1)*fore.

lock righthor to vcrs(thisUP,fore). //right and left horizons

lock lefthor to (-1)*righthor.

lock forehor to vcrs(righthor,thisUP). //forward and backward horizons

lock afthor to (-1)*forehor.

lock top to vcrs(fore,right). //above the cockpit, through the floor

lock bottom to (-1)*top.

//the following are all angles, useful for control programs

lock absaoa to vang(fore,srfprograde:vector). //absolute angle of attack

lock aoa to vang(top,srfprograde:vector)-90. //pitch component of angle of attack

lock sideslip to vang(right,srfprograde:vector)-90. //yaw component of aoa

lock rollang to vang(right,righthor)*((90-vang(top,righthor))/abs(90-vang(top,righthor))). //roll angle, 0 at level flight

lock pitchang to vang(fore,forehor)*((90-vang(fore,thisUP))/abs(90-vang(fore,thisUP))). //pitch angle, 0 at level flight

lock glideslope to vang(srfprograde:vector,forehor)*((90-vang(srfprograde:vector,thisUP))/abs(90-vang(srfprograde:vector,thisUP))).

lock sma to ship:orbit:semimajoraxis.

lock orbprd to round(((2 * constant:PI) * sqrt(((sma*sma*sma)/(constant:G * ship:body:mass)))), 2).

//display some of the info. It's nice to just fly around with this on to get a sense for what's what.

    until false {
        print "######################################" at (0, 2).
        
        print "ALL VALUES ARE IN DEGREES" at (0,4).
        
        print "Roll Angle: "+floor(rollang)+" " at (0,6).
        
        print "Pitch Angle: "+floor(pitchang)+" " at (0,8).
        
        print "Angle of Attack: "+floor(absaoa)+" " at (0, 10).
        
        print "Pitch Component of Angle of Attack: "+floor(aoa)+" " at (0, 12).
        
        print "Sideslip: "+floor(sideslip)+" " at (0, 14).
        
        print "Glide Slope: "+floor(glideslope)+" " at (0, 16).
        
        print "######################################" at (0, 18).
        
        print "Altitude: " + round(altitude, 2) + " m" at (0, 20).
        
        print "Ground speed: " + round(velocity:surface:mag, 2) + " m/s" at (0, 22).
        
        print "Orbital speed: " + round(velocity:orbit:mag, 2) + " m/s" at (0,24).
        
        print "Period calculated: " + orbprd at (0, 26).
        
        print "Period KOS:        " + orbit:period at (0, 28).
        
        print "######################################" at (0, 30).
        
        if hastarget {
        
        print "Distance to target: " + round(target:distance,2) + " m" at (0, 32).
        
        set spd to velocity:orbit - target:velocity:orbit.
        
        print "Relative speed: " + round(spd:mag, 2) + " m" at (0,34).
        
    } else {
        print "          " at (0,32).
        
        print "          " at (0,34).
    
    }
    
}