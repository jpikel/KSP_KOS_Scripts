//Filename: fc.ks
//Description: FLIGHT COMPUTER - mission-control front end for the whole
//script suite. Shows ship status, offers the actions that make sense in the
//current situation, and dispatches to the specialist scripts (which handle
//their own prompts). Stays running until you exit, so a whole mission can be
//flown from one menu.
//
// Usage: run fc.

@LAZYGLOBAL OFF.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

//----- KAL 9000 personality core -----
declare function pick {
    parameter l.
    return l[floor(random() * l:length)].
}

local quips_pad to list(
    "All systems nominal. Probably.",
    "Checklist complete. I checked it twice, unlike engineering.",
    "The rocket looks structurally optimistic today.",
    "I have a good feeling about attempt number this-one.",
    "Gravity is undefeated. Let's change that.").
local quips_surface to list(
    "Lovely spot. Terrible parking.",
    "Scenery rated 4/5. Would land again.",
    "The ground and I have reached an understanding.",
    "Dust levels: acceptable. Snack levels: unknown.",
    "This rock isn't going anywhere. Unlike us, ideally.").
local quips_space to list(
    "Orbiting: falling, but with commitment.",
    "Space remains large. Fuel remains finite.",
    "All quiet. The correct amount of quiet.",
    "I've run the numbers. The numbers ran back.",
    "The stars are lovely. Focus, though.",
    "Everything is fine. I am 87 percent sure.").
local quips_air to list(
    "Air detected. Wings recommended.",
    "Altitude is a suggestion until it isn't.",
    "Lift is just the sky agreeing with you.").
local quips_bye to list(
    "KAL signing off. Try not to press the wrong stage.",
    "Powering down the sass module. Goodnight.",
    "I'll be here. Watching. Calculating. Mostly waiting.",
    "Fly safe. Or at least fly memorably.").

declare function kal_says {
    parameter mood.
    print ("KAL: " + pick(mood)):padright(50) at (0, 3).
}

declare function pause_key {
    print "-- any key and KAL resumes the watch --" at (0, terminal:height - 1).
    wait until terminal:input:haschar.
    terminal:input:clear().
}

declare function dispatch {
    parameter path.
    clearscreen.
    runpath(path).
    pause_key().
}

declare function status_block {
    ui_kv("situation", ship:status + " @ " + body:name, 4).
    if ship:status = "ORBITING" or ship:status = "SUB_ORBITAL" or ship:status = "ESCAPING" {
        ui_kv("orbit", round(ship:orbit:apoapsis / 1000, 1) + " x "
              + round(ship:orbit:periapsis / 1000, 1) + " km, "
              + round(ship:orbit:inclination, 1) + " deg", 5).
    } else {
        ui_kv("position", "lat " + round(ship:geoposition:lat, 2)
              + " lng " + round(ship:geoposition:lng, 2), 5).
    }
    local tname to "none".
    if hastarget {
        set tname to target:name.
    }
    ui_kv("target", tname, 6).
    local dvnote to "".
    if ship:deltav:vacuum < 200 and ship:status = "ORBITING" {
        set dvnote to "  (emotionally concerning)".
    } else if ship:deltav:vacuum > 3000 {
        set dvnote to "  (comfortable)".
    }
    ui_kv("dv", round(ship:deltav:current) + " m/s this stage, "
          + round(ship:deltav:vacuum) + " total" + dvnote, 7).
    if hasnode {
        ui_kv("node", round(nextnode:deltav:mag, 1) + " m/s in " + ui_time(nextnode:eta), 8).
    } else {
        ui_kv("node", "none", 8).
    }
    if ship:elements:length > 1 {
        ui_kv("docked", ship:elements:length + " elements. Snack-sharing enabled.", 9).
    }
}

declare function prox_menu {
    clearscreen.
    ui_header("PROXIMITY OPS").
    status_block().
    local c to read_menu("Which operation?", list(
        "rendezvous with a vessel",
        "dock with target",
        "grapple target (Klaw)",
        "transfer fuel (while docked)",
        "back"), 11).
    if c = 0 { dispatch("0:/rendezvous"). }
    else if c = 1 { dispatch("0:/dock"). }
    else if c = 2 { dispatch("0:/grapple"). }
    else if c = 3 { dispatch("0:/transfer_fuel"). }
}

declare function land_menu {
    clearscreen.
    ui_header("LANDING").
    status_block().
    local c to read_menu("Land where?", list(
        "next to a base (landat)",
        "under current position (hop)",
        "back"), 11).
    if c = 0 { dispatch("0:/landat"). }
    else if c = 1 { dispatch("0:/hop"). }
}

declare function maneuver_menu {
    clearscreen.
    ui_header("MANEUVER PLANNING").
    status_block().
    local c to read_menu("Plan what?", list(
        "transfer to moon/vessel (hohmann)",
        "transfer to planet (interplanet)",
        "match planes with target",
        "capture at periapsis",
        "circularize (adds node + burns)",
        "tune node periapsis (node_tune)",
        "change orbital altitude (change_alt)",
        "spaceplane: deorbit + autoland KSC (planeland)",
        "back"), 10).
    if c = 0 { dispatch("0:/hohmann"). }
    else if c = 1 { dispatch("0:/interplanet"). }
    else if c = 2 { dispatch("0:/matchplanes"). }
    else if c = 3 { dispatch("0:/capture"). }
    else if c = 4 {
        clearscreen.
        local w to read_menu("Circularize at:", list("apoapsis", "periapsis"), 0).
        runpath("0:/circat", choose "ap" if w = 0 else "pe").
        runpath("0:/node").
        pause_key().
    }
    else if c = 5 { dispatch("0:/node_tune"). }
    else if c = 6 { dispatch("0:/change_alt"). }
    else if c = 7 { dispatch("0:/planeland"). }
}

local done to false.
until done {
    clearscreen.
    ui_header("KAL 9000 // " + ship:name).

    if ship:status = "PRELAUNCH" or (ship:status = "LANDED" and body = kerbin) {
        kal_says(quips_pad).
    } else if ship:status = "LANDED" or ship:status = "SPLASHED" {
        kal_says(quips_surface).
    } else if ship:status = "FLYING" {
        kal_says(quips_air).
    } else {
        kal_says(quips_space).
    }
    status_block().

    if ship:status = "PRELAUNCH" or (ship:status = "LANDED" and body = kerbin) {
        local c to read_menu("Ready when you are.", list(
            "QUICK rocket launch (defaults, no questions)",
            "QUICK SSTO launch (defaults, no questions)",
            "rocket launch with prompts (rlseq)",
            "SSTO launch with prompts (ssto)",
            "timed launch to meet target (launchwindow)",
            "plane: takeoff + cruise (plane_launch)",
            "science sweep here",
            "refresh status",
            "exit"), 10).
        local defap to max(75000, body:atm:height + 10000).
        if c = 0 {
            clearscreen.
            runpath("0:/rlseq", defap, 90, 1.45, 2.2, 0).
            pause_key().
        }
        else if c = 1 {
            clearscreen.
            runpath("0:/ssto", max(80000, defap), 90, 16000, 80, 35).
            pause_key().
        }
        else if c = 2 { dispatch("0:/rlseq"). }
        else if c = 3 { dispatch("0:/ssto"). }
        else if c = 4 { dispatch("0:/launchwindow"). }
        else if c = 5 { dispatch("0:/plane_launch"). }
        else if c = 6 { dispatch("0:/science"). }
        else if c = 8 { set done to true. }

    } else if ship:status = "LANDED" or ship:status = "SPLASHED" {
        local c to read_menu("On the surface. What now?", list(
            "hop to another site",
            "science sweep here",
            "ascend to orbit (rlseq)",
            "timed launch to meet target (launchwindow)",
            "hover-dock with base port (basedock)",
            "rover cruise / drive to waypoint (rove)",
            "hover (altitude hold)",
            "refresh status",
            "exit"), 10).
        if c = 0 { dispatch("0:/hop"). }
        else if c = 1 { dispatch("0:/science"). }
        else if c = 2 { dispatch("0:/rlseq"). }
        else if c = 3 { dispatch("0:/launchwindow"). }
        else if c = 4 { dispatch("0:/basedock"). }
        else if c = 5 { dispatch("0:/rove"). }
        else if c = 6 { dispatch("0:/hover"). }
        else if c = 8 { set done to true. }

    } else if ship:status = "ORBITING" or ship:status = "ESCAPING" or ship:status = "SUB_ORBITAL" {
        local c to read_menu("In space. What now?", list(
            "plan a maneuver...",
            "execute next node",
            "proximity ops (rendezvous/dock/grapple/fuel)...",
            "land...",
            "science sweep",
            "warp to... (node/Ap/Pe/SOI)",
            "refresh status",
            "exit"), 10).
        if c = 0 { maneuver_menu(). }
        else if c = 1 {
            if hasnode {
                dispatch("0:/node").
            } else {
                ui_kv("node", "none. I cannot execute the void. Plan one first.", 8).
                wait 2.
            }
        }
        else if c = 2 { prox_menu(). }
        else if c = 3 { land_menu(). }
        else if c = 4 { dispatch("0:/science"). }
        else if c = 5 { dispatch("0:/timewarp"). }
        else if c = 7 { set done to true. }

    } else {
        //flying or sub-orbital in atmosphere
        local c to read_menu("In the air (" + ship:status + ").", list(
            "autoland at KSC runway (planeland)",
            "cruise autopilot (plane_launch)",
            "science sweep",
            "refresh status",
            "exit"), 10).
        if c = 0 { dispatch("0:/planeland"). }
        else if c = 1 { dispatch("0:/plane_launch"). }
        else if c = 2 { dispatch("0:/science"). }
        else if c = 4 { set done to true. }
    }
}

clearscreen.
print "KAL: " + pick(quips_bye).
