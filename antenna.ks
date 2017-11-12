

//allowed parameters are retract and extend otherwise defaults to toggle

parameter dowhat to "toggle".


for p in ship:parts {
    if p:modules:contains("ModuleDeployableAntenna"){
        local m is p:getmodule("ModuleDeployableAntenna").

        if dowhat = "extend" { 
            extend(m). 
        }
        else if dowhat = "retract" {
            retract(m).
        }
        
        if dowhat ="toggle" and m:hasevent("extend antenna"){ 
            extend(m).
        }
        else { 
            retract(m). 
        }
    }
}

declare function extend {
    parameter m.
    if m:hasevent("extend antenna"){ m:doevent("extend antenna").}
}

declare function retract {
    parameter m.
    if m:hasevent("extend antenna"){ m:doevent("retract antenna").}
}
