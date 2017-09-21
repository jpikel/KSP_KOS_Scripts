// Filename: change_alt.ks
// Description: Script adds a node to change the vessel's altitude
// places the initial maneuver node at either apoapsis or periapsis 
// depending on the target semi major axis.

@LAZYGLOBAL OFF.
//Change orbital altitude
parameter target_alt is 0.
clearscreen.


//function: prints a yes or no message to the terminal.
// if 'y' or 'Y' is recevied returns true otherwise return false.

declare function print_mess {
    local mess to "Execute node and circularization? [y/n]".
    terminal:input:clear().
    print mess.
    local ch to terminal:input:getchar().
    if ch = "y" or ch = "Y" { return true. } 
    else { return false.}
}
//function: target_alt
//description: calculates the dv required to change to a new target semi major axis.
//new target altitude is + or - the current semi major axis.  So if current sma is 
// 100,000 and you pass in 10,000 the new semi major axis is 110,000.
// executes the maneuver with run_node.ks.  Circularizes at the appropriate AP or PE 
// then executes the circulirization maneuver.
//parameters: pass in a valid target altitude that is not 0.

if target_alt <> 0 {
    local rad1 to ship:orbit:semimajoraxis.
    local tgt_sma to ship:body:radius+target_alt.
    local u to ship:body:mu.
    local dv to sqrt((u/rad1))*((sqrt((2*tgt_sma)/(rad1+tgt_sma))) - 1 ).
    local ch to "".
    if tgt_sma > apoapsis {
        add node(time:seconds + eta:periapsis, 0, 0, dv).
        if print_mess() =  true {
            runoncepath("run_node").
            runoncepath("circ_at", "ap").
            runoncepath("run_node").
        }
    } else {
        add node(time:seconds + eta:apoapsis, 0, 0, dv).
        if print_mess() = true {
            runoncepath("run_node").
            runoncepath("circ_at", "pe").
            runoncepath("run_node").
        }
    }
    
} else {
    print "error invalid input".
}
