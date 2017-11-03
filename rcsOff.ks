

@lazyglobal off.
parameter turnOff to true.
//allowed parameters are retract and extend otherwise defaults to toggle

    local rcsBlock TO SHIP:PARTSDUBBED("RCSBlock").

    local x to 0.
    if turnOff = false {
        set x to 1.
    }
    local rcsBlocks to List(). 
    for block in rcsBlock {
        rcsBlocks:add(block).
    }

    for block in rcsBlocks {
//        print block:getmodule("modulercsfx"):allfieldnames.
//        print block:getmodule("modulercsfx"):allfields.
        if block:getmodule("modulercsfx"):hasevent("show actuation toggles"){
            block:getmodule("modulercsfx"):doevent("show actuation toggles").
        }
        if block:getmodule("modulercsfx"):hasfield("yaw"){
            block:getmodule("modulercsfx"):setfield("yaw", x).
            block:getmodule("modulercsfx"):setfield("pitch", x).
            block:getmodule("modulercsfx"):setfield("roll", x).
        }
    }
