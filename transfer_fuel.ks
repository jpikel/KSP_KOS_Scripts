//Filename: transfer_fuel.ks
//Description: move resources between DOCKED craft (elements) from a menu -
//the missing last step of a tanker run: launchwindow -> rendezvous -> dock
//-> transfer_fuel. Shows per-element tanks, transfers all or an amount.
//
// Usage (while docked): run transfer_fuel.

@LAZYGLOBAL OFF.

runoncepath("lib_input.ks").
runoncepath("lib_ui.ks").

clearscreen.
ui_header("FUEL TRANSFER").

declare function amount_of {
    parameter elem.
    parameter resname.
    local total to 0.
    for p in elem:parts {
        for r in p:resources {
            if r:name = resname {
                set total to total + r:amount.
            }
        }
    }
    return total.
}

if ship:elements:length < 2 {
    print "Not docked to anything - only one element aboard.".
} else {
    //pick source and destination elements
    local names to list().
    for e in ship:elements {
        names:add(e:name).
    }
    local si to read_menu("Transfer FROM:", names, 4).
    local di to read_menu("Transfer TO:", names, 4).
    if si = di {
        print "Source and destination are the same element.".
    } else {
        local src to ship:elements[si].
        local dst to ship:elements[di].

        //offer whatever transferable resources are actually aboard the source
        local resnames to list().
        for p in src:parts {
            for r in p:resources {
                if not resnames:contains(r:name)
                   and r:name <> "ElectricCharge" and r:name <> "SolidFuel"
                   and resnames:length < 8 {
                    resnames:add(r:name).
                }
            }
        }
        if resnames:length = 0 {
            print "Source element has no transferable resources.".
        } else {
            local reslabels to list().
            for rn in resnames {
                reslabels:add(rn + "  (" + round(amount_of(src, rn), 1) + " -> "
                              + round(amount_of(dst, rn), 1) + ")").
            }
            local ri to read_menu("Which resource?", reslabels, 4).
            local rn to resnames[ri].

            clearscreen.
            ui_header("FUEL TRANSFER: " + rn).
            ui_kv("from", src:name + " (" + round(amount_of(src, rn), 1) + ")", 4).
            ui_kv("to", dst:name + " (" + round(amount_of(dst, rn), 1) + ")", 5).
            local have to amount_of(src, rn).
            local how to read_menu("How much?", list(
                "all that fits",
                "half of the source (" + round(have / 2, 1) + ")",
                "custom amount"), 7).

            local xfer to 0.
            if how = 0 {
                set xfer to transferall(rn, src, dst).
            } else if how = 1 {
                set xfer to transfer(rn, src, dst, have / 2).
            } else {
                local amt to read_number("Amount", round(have / 4, 1), 12).
                set xfer to transfer(rn, src, dst, amt).
            }
            set xfer:active to true.
            //note: CREW moves are not scriptable in stock kOS - use the
            //game's hatch transfer dialog once docked.

            until xfer:status = "Finished" or xfer:status = "Failed" or xfer:status = "Inactive" {
                ui_kv("from", src:name + " (" + round(amount_of(src, rn), 1) + ")   ", 4).
                ui_kv("to", dst:name + " (" + round(amount_of(dst, rn), 1) + ")   ", 5).
                ui_kv("status", xfer:status, 8).
                wait 0.25.
            }
            ui_kv("from", src:name + " (" + round(amount_of(src, rn), 1) + ")   ", 4).
            ui_kv("to", dst:name + " (" + round(amount_of(dst, rn), 1) + ")   ", 5).
            ui_kv("status", xfer:status + " - done", 8).
        }
    }
}
