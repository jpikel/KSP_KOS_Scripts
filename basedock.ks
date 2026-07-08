//Filename: basedock.ks
//Description: HOVER DOCKING with a surface base, no wheels. Two geometries,
//auto-detected from the base port's orientation:
//  SIDE mode: base port faces outward horizontally -> your rocket needs a
//    RADIAL (sideways) port; we hover at port height and slide in sideways.
//  TOP mode: base port faces UP -> your rocket needs a BOTTOM-mounted port
//    (facing down); we hover over the port and descend onto it - landing
//    on top of the base.
//The main engine hovers, RCS translates, throttle cuts the instant the
//magnets capture. AG9 aborts and lands you gently straight down.
//
// Requirements: RCS with translation authority, local TWR > 1.2, base
// loaded (within ~200 m - use landat first). TOP mode: watch your engine
// layout - a center engine right next to the bottom port will torch the base;
// outboard engines are ideal.
//
// Usage: run basedock.    (from landed beside the base, or hovering)

@LAZYGLOBAL OFF.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("BASE DOCK (hover)").

//signed angle from a to b around axis
declare function sang {
    parameter a.
    parameter b.
    parameter axis.
    local ang to vang(a, b).
    if vdot(vcrs(a, b), axis) < 0 {
        return -ang.
    }
    return ang.
}

local glocal to body:mu / body:position:mag^2.

if not hastarget {
    print "Target the base (or its docking port) first.".
} else if ship:availablethrust / (ship:mass * glocal) < 1.2 {
    print "Local TWR under 1.2 - cannot hover here.".
} else if not target:istype("DockingPort") and not target:loaded {
    print "Base not loaded - get within ~200 m first (landat).".
} else {
    local upv0 to up:vector.

    //----- pick the BASE port (menu if it has several free ones) -----
    local tport to 0.
    if target:istype("DockingPort") {
        set tport to target.
    } else {
        local frees to list().
        local labels to list().
        for p in target:dockingports {
            if p:state = "Ready" {
                frees:add(p).
                local vd to vdot(p:portfacing:forevector, upv0).
                local ori to "side".
                if vd > 0.6 { set ori to "TOP (land on it)". }
                else if vd < -0.6 { set ori to "down?!". }
                labels:add(p:nodetype + " port, faces " + ori).
            }
        }
        if frees:length = 1 {
            set tport to frees[0].
        } else if frees:length > 1 {
            set tport to frees[read_menu("Which base port?", labels, 12)].
        }
    }

    if tport = 0 {
        print "No free docking port on the base.".
    } else {
        //----- detect geometry from the base port -----
        local vd to vdot(tport:portfacing:forevector, upv0).
        local vertical to vd > 0.6.
        if not vertical and abs(vd) > 0.4 {
            print "Base port is tilted " + round(vang(tport:portfacing:forevector, upv0))
                + " deg from vertical - neither side nor top mode fits.".
        } else {
            //----- pick OUR port to match the geometry -----
            //TOP mode wants a bottom mount (faces opposite the hull nose);
            //SIDE mode wants a radial mount (perpendicular to the hull)
            local myport to 0.
            for p in ship:dockingports {
                if p:state = "Ready" and myport = 0 {
                    local a to vdot(p:portfacing:forevector, ship:facing:forevector).
                    if (vertical and a < -0.5 and p:nodetype = tport:nodetype)
                       or ((not vertical) and abs(a) < 0.5 and p:nodetype = tport:nodetype) {
                        set myport to p.
                    }
                }
            }
            if myport = 0 { //same search, any node size
                for p in ship:dockingports {
                    if p:state = "Ready" and myport = 0 {
                        local a to vdot(p:portfacing:forevector, ship:facing:forevector).
                        if (vertical and a < -0.5) or ((not vertical) and abs(a) < 0.5) {
                            set myport to p.
                        }
                    }
                }
            }

            if myport = 0 {
                if vertical {
                    print "TOP mode needs a free BOTTOM-mounted port on this rocket.".
                } else {
                    print "SIDE mode needs a free RADIAL (sideways) port on this rocket.".
                }
            } else {
                local stop to false.
                on ag9 { set stop to true. }
                rcs on.
                sas off.

                //SIDE mode: fixed roll offset between hull top and our port
                local rolloff to 0.
                if not vertical {
                    set rolloff to sang(ship:facing:topvector,
                                        vxcl(ship:facing:forevector, myport:portfacing:forevector),
                                        ship:facing:forevector).
                }

                local thr to 0.
                lock throttle to thr.
                local standoff to choose 8 if vertical else 12.
                local tau to 2.5.
                local rollcheck_t to time:seconds + 25. //self-correct a flipped roll sign
                ui_kv("mode", choose "TOP - descending onto base port" if vertical
                      else "SIDE - sliding onto base port", 3).

                until stop or myport:state <> "Ready" {
                    local upv to up:vector.
                    set glocal to body:mu / body:position:mag^2.

                    //approach axis: straight up in TOP mode, the port's
                    //horizontal facing in SIDE mode
                    local axis to tport:portfacing:forevector:normalized.
                    if not vertical {
                        set axis to vxcl(upv, tport:portfacing:forevector):normalized.
                    }

                    //attitude: hull vertical; SIDE mode also rolls the port
                    //onto the base port (TOP mode: roll doesn't matter)
                    if vertical {
                        lock steering to lookdirup(upv, vxcl(upv, north:vector)).
                    } else {
                        lock steering to lookdirup(upv, angleaxis(-rolloff, upv) * (-axis)).
                    }

                    local aimpt to tport:nodeposition + axis * standoff.
                    local err to aimpt - myport:nodeposition.
                    local err_up to vdot(err, upv).
                    local err_h to vxcl(upv, err).

                    //vertical channel: hover feedforward + velocity command
                    local vz_des to min(2, max(-2, err_up / 4)).
                    local a_up to glocal + (vz_des - ship:verticalspeed) / tau.
                    set thr to min(1, max(0, a_up / max(0.1, ship:availablethrust / ship:mass))).

                    //horizontal channel: RCS velocity control (base is fixed)
                    local vh to vxcl(upv, ship:velocity:surface).
                    local v_des to v(0, 0, 0).
                    if err_h:mag > 0.05 {
                        set v_des to err_h:normalized * min(1.2, err_h:mag / 6).
                    }
                    local cmd to (v_des - vh) * 1.5.
                    set ship:control:top to min(1, max(-1, vdot(cmd, ship:facing:topvector))).
                    set ship:control:starboard to min(1, max(-1, vdot(cmd, ship:facing:starvector))).

                    //if the hull has settled but the port still points wrong,
                    //the roll-offset sign was backwards - flip it once
                    if not vertical and time:seconds > rollcheck_t {
                        set rollcheck_t to time:seconds + 25.
                        if vang(myport:portfacing:forevector, -tport:portfacing:forevector) > 15
                           and vang(ship:facing:forevector, up:vector) < 5 {
                            set rolloff to -rolloff.
                            ui_kv("note", "flipped roll sign - realigning", 10).
                        }
                    }

                    //creep in only when parked on the axis and pointed right
                    local aligned to vang(myport:portfacing:forevector, -tport:portfacing:forevector) < 6.
                    if aligned and abs(err_up) < 0.35 and err_h:mag < 0.35 and standoff > -0.3 {
                        set standoff to max(-0.3, standoff - 0.006). //press slightly past 0
                    }

                    ui_kv("standoff", round(max(0, standoff), 1) + " m"
                          + (choose "  CLOSING" if aligned else "  aligning"), 4).
                    ui_kv("offset", round(err_h:mag, 2) + " m horiz, "
                          + round(err_up, 2) + " m vert", 5).
                    ui_kv("port angle", round(vang(myport:portfacing:forevector,
                          -tport:portfacing:forevector), 1) + " deg", 6).
                    ui_kv("hover", "throttle " + round(thr, 2), 7).
                    wait 0.02.
                }

                //captured (or aborted): engine OFF immediately either way
                set thr to 0.
                set ship:control:neutralize to true.
                unlock throttle.
                set ship:control:pilotmainthrottle to 0.

                if myport:state <> "Ready" {
                    unlock steering.
                    ui_kv("status", "CAPTURE! docked to " + tport:ship:name, 9).
                    rcs off.
                } else {
                    //abort: settle straight down from wherever we are
                    ui_kv("status", "ABORT - landing in place", 9).
                    lock steering to lookdirup(up:vector, ship:facing:topvector).
                    local thr2 to 0.
                    lock throttle to thr2.
                    until ship:status = "LANDED" {
                        local vtgt to -min(3, max(0.6, alt:radar / 12)).
                        set thr2 to min(1, max(0, (body:mu / body:position:mag^2
                            + (vtgt - ship:verticalspeed) / 2) / max(0.1, ship:availablethrust / ship:mass))).
                        wait 0.02.
                    }
                    set thr2 to 0.
                    unlock throttle.
                    unlock steering.
                    set ship:control:pilotmainthrottle to 0.
                    sas on.
                }
            }
        }
    }
}
