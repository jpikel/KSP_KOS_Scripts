//Filename: lib_input.ks
//Description: terminal input helpers for interactive scripts.
//To include in another script: runoncepath("lib_input.ks").
//
// read_number(prompt, default, row) - type a number, BACKSPACE to correct,
//                                     ENTER to accept (empty input = default)
// read_menu(title, options, row)    - numbered menu, returns chosen index (0-based)

@LAZYGLOBAL OFF.

declare function read_number {
    parameter prompt.
    parameter default_val.
    parameter row.

    local buf to "".
    local done to false.
    until done {
        print prompt + " [" + default_val + "]: " + buf + "_   " at (0, row).
        wait until terminal:input:haschar.
        local ch to terminal:input:getchar().
        if ch = terminal:input:enter {
            set done to true.
        } else if ch = terminal:input:backspace {
            if buf:length > 0 {
                set buf to buf:substring(0, buf:length - 1).
            }
        } else if "0123456789.-":contains(ch) {
            set buf to buf + ch.
        }
    }
    print prompt + " [" + default_val + "]: " + buf + "    " at (0, row).
    if buf = "" {
        return default_val.
    }
    return buf:tonumber(default_val).
}

declare function read_menu {
    parameter title.
    parameter options.  //list of strings
    parameter row.

    print title at (0, row).
    local i to 1.
    for opt in options {
        print "  " + i + ") " + opt at (0, row + i).
        set i to i + 1.
    }
    print "press a number key..." at (0, row + i).

    local choice to -1.
    until choice >= 1 and choice <= options:length {
        wait until terminal:input:haschar.
        set choice to terminal:input:getchar():tonumber(-1).
    }
    print "chose: " + options[choice - 1] + "        " at (0, row + i).
    return choice - 1.
}
