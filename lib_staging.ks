//Filename: lib_staging.ks
//Description: generic autostage safety logic shared by rocket_launch.ks and node.ks.
//To include: runoncepath("lib_staging.ks").
//
// safe_to_stage(floor) - true only if firing the next stage would:
//   (a) ignite at least one engine, or
//   (b) shed a flamed-out engine (booster / spent stage separation), or
//   (c) do something inert like deploying a fairing.
// A separator, docking port, or parachute stage that gains nothing is the
// payload - it is refused with an on-screen warning, whatever the rocket.
// floor is an optional manual stage limit on top (0 = rely on detection).

@LAZYGLOBAL OFF.

//is staging actually called for? True only when nothing is producing thrust,
//or an ignited engine has genuinely run dry (flameout). Never infer burnout
//from thrust readings - they flatten at the top of the atmosphere and float
//noise reads as a "drop", which staged a healthy rocket to death once.
declare function stage_needed {
    if ship:availablethrust = 0 {
        return true.
    }
    local es to list().
    list engines in es.
    for e in es {
        if e:ignition and e:flameout {
            return true.
        }
    }
    return false.
}

declare function next_stage_ignites {
    local es to list().
    list engines in es.
    for e in es {
        if e:stage = stage:number - 1 {
            return true.
        }
    }
    return false.
}

declare function safe_to_stage {
    parameter floor is 0.

    if stage:number = 0 or stage:number <= floor {
        return false.
    }
    if next_stage_ignites() {
        return true.
    }
    local es to list().
    list engines in es.
    for e in es {
        //separation that sheds a burned-out engine (booster or spent stage)
        if e:flameout and e:decoupledin = stage:number - 1 {
            return true.
        }
    }
    for p in ship:parts {
        if p:stage = stage:number - 1 {
            if p:hasmodule("ModuleDecouple") or p:hasmodule("ModuleAnchoredDecoupler")
               or p:hasmodule("ModuleParachute") or p:hasmodule("ModuleDockingNode") {
                print ("autostage BLOCKED: stage " + (stage:number - 1)
                      + " separates but gains nothing (payload?)"):padright(46)
                      at (0, terminal:height - 2).
                return false.
            }
        }
    }
    return true. //inert stage (fairing deploy etc) - chain through it
}
