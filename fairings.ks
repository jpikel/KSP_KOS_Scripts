@lazyglobal off.



local fairings to list().
local size1 to ship:partsdubbed("fairingSize1").
local size2 to ship:partsdubbed("fairingSize2").
local size3 to ship:partsdubbed("fairingSize3").


    for fairing in size1{
        fairings.add(fairing).
    }
    for fairing in size2{
        fairings.add(fairing).
    }
    for fairing in size3{
        fairings.add(fairing).
    }

    for fairing in fairings{
        fairing:getmodulebyindex(0):doevent("deploy").
    }
