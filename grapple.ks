// Filename: grapple.ks
// Description: approach and grab the target with an Advanced Grabbing Unit
// (Klaw). Velocity-controlled RCS approach that measures from the GRABBER,
// not the ship - assumes the Klaw faces forward (nose-mounted).
// Arms the Klaw automatically, detects capture (the target merges into our
// vessel, so HASTARGET going false = success), and retries a missed grab.
//
// Usage: target the debris/asteroid/vessel, close to within ~100 m
//        (rendezvous gets you there), then: run grapple.
// AG9 aborts. AG10 rolls 15 degrees (if the Klaw needs a rotation).

@LAZYGLOBAL OFF.

runoncepath("lib_ui.ks").

clearscreen.
ui_header("GRAPPLE").

declare function translate {
    parameter vec.
    if vec:mag > 1 {
        set vec to vec:normalized.
    }
    set ship:control:fore to vec * ship:facing:forevector.
    set ship:control:starboard to vec * ship:facing:starvector.
    set ship:control:top to vec * ship:facing:topvector.
}

declare function relv {
    return ship:velocity:orbit - target:velocity:orbit.
}

local grabs to ship:partsdubbed("GrapplingDevice").

if not hastarget {
    print "No target. Select the thing to grab first.".
} else if grabs:length = 0 {
    print "No Advanced Grabbing Unit (Klaw) on this ship.".
} else if not target:loaded {
    print "Target not loaded - get within ~200 m first (run rendezvous).".
} else {
    local grabber to grabs[0].

    //arm the jaws - without this you just bonk off the target
    if grabber:hasmodule("ModuleGrappleNode") {
        local gm to grabber:getmodule("ModuleGrappleNode").
        if gm:hasevent("arm") {
            gm:doevent("arm").
            ui_kv("klaw", "armed", 4).
            wait 1.
        } else {
            ui_kv("klaw", "already armed (or no arm event)", 4).
        }
    } else {
        ui_kv("klaw", "no grapple module?! trying anyway", 4).
    }

    local stop to false.
    on ag9 { set stop to true. }
    local roll to 0.
    on ag10 {
        set roll to roll + 15.
        if roll > 360 { set roll to 0. }
        preserve.
    }

    sas off.
    rcs on.

    //crash-proof steering: lock to a variable we only update while the
    //target still exists (it vanishes from HASTARGET the moment we grab it)
    local steerdir to target:position.
    lock steering to lookdirup(steerdir, north:vector) + r(0, 0, roll).
    ui_kv("status", "facing target", 5).
    local t0 to time:seconds.
    wait until stop or vang(ship:facing:forevector, steerdir) < 2 or time:seconds > t0 + 60.

    declare function approach {
        parameter offset.
        parameter speed.
        until stop or not hastarget {
            local tv to target:position - grabber:position.
            if tv:mag < offset {
                break.
            }
            set steerdir to target:position.
            translate(tv:normalized * speed - relv()).
            ui_kv("distance", round(tv:mag, 2) + " m (leg: " + offset + " m @ " + speed + " m/s)", 6).
            ui_kv("rel vel", round(relv():mag, 2) + " m/s", 7).
            wait 0.05.
        }
    }

    local tries to 0.
    until stop or not hastarget or tries >= 3 {
        set tries to tries + 1.
        ui_kv("status", "approach, attempt " + tries + " of 3", 5).
        approach(50, 5).
        approach(30, 5).
        approach(20, 2).
        approach(10, 1).
        approach(3, 0.6).

        //final: keep commanding a slow closing rate INTO contact until the
        //target merges with us (capture) or we clearly bounced off
        ui_kv("status", "closing to grapple", 5).
        local tstart to time:seconds.
        until stop or not hastarget or time:seconds > tstart + 60 {
            local tv to target:position - grabber:position.
            if tv:mag > 8 {
                ui_kv("status", "missed/bounced - re-approaching", 5).
                break.
            }
            set steerdir to target:position.
            translate(tv:normalized * 0.5 - relv()).
            ui_kv("distance", round(tv:mag, 2) + " m", 6).
            ui_kv("rel vel", round(relv():mag, 2) + " m/s", 7).
            wait 0.05.
        }
    }

    translate(v(0, 0, 0)).
    set ship:control:neutralize to true.
    unlock steering.
    sas on.
    rcs off.

    if not hastarget and not stop {
        ui_kv("status", "GRAPPLED - target is now part of this vessel", 5).
        print "release later via the Klaw's right-click menu" at (0, 9).
    } else if stop {
        ui_kv("status", "aborted (AG9)", 5).
    } else {
        ui_kv("status", "no capture after 3 tries - check Klaw arming/angle", 5).
    }
}
