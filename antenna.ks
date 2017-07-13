

@lazyglobal off.

//allowed parameters are retract and extend otherwise defaults to toggle

parameter dowhat to "toggle".

    local c16 TO SHIP:PARTSDUBBED("Communotron 16").
    local cm1 TO SHIP:PARTSDUBBED("Comms DTS-M1").
    local c88 TO SHIP:PARTSDUBBED("Communotron 88-88").
    local antennae TO LIST().
    for antenna in c16 {
            antennae:add(antenna).
    }
    for antenna in cm1 {
            antennae:add(antenna).
    }
    for antenna in c88 {
            antennae:add(antenna).
    }
    for antenna in antennae {
        if dowhat = "toggle" {
            if (antenna:getmodule("moduledeployableantenna"):hasevent("extend antenna")){
                antenna:getmodule("moduledeployableantenna"):doevent("extend antenna").
            } else {
                antenna:getmodule("moduledeployableantenna"):doevent("retract antenna").
            }
        } else if dowhat = "extend" {
            if (antenna:getmodule("moduledeployableantenna"):hasevent("extend antenna")){
                antenna:getmodule("moduledeployableantenna"):doevent("extend antenna").
            }
        } else if dowhat = "retract" {
            if (antenna:getmodule("moduledeployableantenna"):hasevent("retract antenna")){
                antenna:getmodule("moduledeployableantenna"):doevent("retract antenna").
            }

        }
    }
