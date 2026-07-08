//Filename : node_tune.ks
//Description: fine-tune the next maneuver node's prograde dv until the predicted
//encounter periapsis reaches a desired altitude. Good for Celestial Body
//intercepts like the Mun after running hohmann.
//The step direction is probed automatically (no more guessing the sign), and the
//node is restored if the encounter is lost while tuning.
//
// Usage:
//   run node_tune.               interactive prompts
//   run node_tune(15000).        scripted: tune encounter periapsis to 15 km
//   run node_tune(15000, 0.05).  scripted: with a coarser dv step

@LAZYGLOBAL OFF.

parameter tgt_periapsis is "ask".  //pass a number to skip the interactive prompts
parameter dv_step is 0.01.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").
clearscreen.

declare function tune_node {
    parameter tgt_pe.
    parameter step0.

    local nd to nextnode.
    local backup_prograde to nd:prograde.
    local start_pe to encounter:periapsis.
    local raising to start_pe < tgt_pe.
    local step to abs(step0).

    clearscreen.
    ui_header("NODE TUNE: " + encounter:name).
    ui_kv("start pe", round(start_pe) + " m", 4).
    ui_kv("target pe", round(tgt_pe) + " m", 5).

    //probe: take one step and see which way the periapsis moves
    set nd:prograde to nd:prograde + step.
    wait 0.02.
    if not encounter:istype("Orbit") {
        set nd:prograde to backup_prograde.
        print "---error--- lost the encounter probing. Node restored, try a smaller step.".
        return.
    }
    if (encounter:periapsis > start_pe) <> raising {
        set step to -step.
    }

    local iters to 0.
    until iters > 5000 {
        if not encounter:istype("Orbit") {
            set nd:prograde to backup_prograde.
            print "---error--- lost the encounter. Node restored, try again.".
            return.
        }
        if (raising and encounter:periapsis >= tgt_pe)
           or ((not raising) and encounter:periapsis <= tgt_pe) {
            break.
        }
        set nd:prograde to nd:prograde + step.
        set iters to iters + 1.
        local frac to 1.
        if abs(tgt_pe - start_pe) > 0.1 {
            set frac to (encounter:periapsis - start_pe) / (tgt_pe - start_pe).
        }
        ui_bar("tuning", max(0, min(1, frac)), round(encounter:periapsis) + " m", 7).
        wait 0.001.
    }

    if iters > 5000 {
        set nd:prograde to backup_prograde.
        print "---error--- did not converge in 5000 steps. Node restored.".
        return.
    }

    ui_kv("status", "node updated", 8).
    ui_kv("periapsis", round(encounter:periapsis) + " m", 9).
    ui_kv("node in", ui_time(nd:eta), 10).
    ui_kv("burn dv", round(nd:burnvector:mag, 2) + " m/s", 11).
}

if not hasnode {
    print "---error--- no maneuver node to tune. Run hohmann first.".
} else if not encounter:istype("Orbit") {
    print "---error--- no encounter yet. Nudge the node in map view until one shows,".
    print "            or re-run hohmann with a different offset.".
} else {
    if tgt_periapsis:istype("String") {
        ui_header("NODE TUNE: " + encounter:name).
        ui_kv("current pe", round(encounter:periapsis) + " m", 4).
        set tgt_periapsis to read_number("Target periapsis (m)", 15000, 6).
        set dv_step to read_number("Dv step per iteration (m/s)", 0.01, 7).
    }
    if tgt_periapsis < 0 {
        print "---error--- invalid periapsis.".
    } else {
        tune_node(tgt_periapsis, dv_step).
    }
}
