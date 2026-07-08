//Filename: science.ks
//Description: one-command science sweep. Runs every experiment aboard that
//doesn't already hold data, then transmits results that lose little value
//over the antenna and keeps the rest stored (for recovery or the MPL lab).
//Run it at every new situation: high/low orbit, and after every landing.
//
// Usage:
//   run science.          interactive (transmit threshold prompt)
//   run science(0.95).    scripted: transmit if >= 95% of value survives
//   run science(2).       scripted: never transmit, keep everything

@LAZYGLOBAL OFF.

parameter transmit_frac is "ask".

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("SCIENCE SWEEP: " + ship:name).

if transmit_frac:istype("String") {
    set transmit_frac to read_number("Transmit if kept fraction >= (2 = never)", 0.95, 4).
}

local mods to ship:modulesnamed("ModuleScienceExperiment").
local ran to 0.
local sent to 0.
local kept to 0.
local row to 8.

for m in mods {
    if not m:inoperable and not m:hasdata {
        //crew reports live on command pods and need a kerbal aboard -
        //skip pod experiments when flying uncrewed (Part has no
        //crewcapacity suffix in kOS; detect pods via ModuleCommand)
        if not (m:part:hasmodule("ModuleCommand") and ship:crew():length = 0) {
            m:deploy.
            local t0 to time:seconds.
            wait until m:hasdata or time:seconds > t0 + 6.
        }
    }
    if m:hasdata {
        set ran to ran + 1.
        local d to m:data[0].
        local line to d:title:substring(0, min(34, d:title:length)).
        if d:sciencevalue > 0.1 and transmit_frac <= 1
           and d:transmitvalue >= transmit_frac * d:sciencevalue {
            m:transmit.
            set sent to sent + 1.
            print (line + " -> transmitting"):padright(46) at (0, row).
            wait 1. //give the antenna queue a beat
        } else {
            set kept to kept + 1.
            print (line + " -> stored"):padright(46) at (0, row).
        }
        set row to row + 1.
        if row > terminal:height - 3 {
            set row to 8.
        }
    }
}

ui_kv("experiments", ran + " with data", 5).
ui_kv("sent / kept", sent + " / " + kept, 6).
if kept > 0 {
    print "stored results: recover, or feed to the MPL lab" at (0, row + 1).
}
