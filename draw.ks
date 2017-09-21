//KOS
// diraxesdraw - Draw the XYZ axes of a given direction (rotation).
//
// Assumes you've already made a list like so:
//  SET DRAWS TO LIST().
// Before calling it the first time.
//
declare parameter dir, scale.

draws:add(list()).
draws[draws:length-1]:ADD(VECDRAW(V(0,0,0), dir*V(1,0,0), RED, "X", 1, true , 0.03) ).
draws[draws:length-1]:ADD(VECDRAW(V(0,0,0), dir*V(0,1,0), GREEN, "Y", 1, true, 0.03) ).
draws[draws:length-1]:ADD(VECDRAW(V(0,0,0), dir*V(0,0,1), BLUE, "Z", 1, true, 0.03) ).
