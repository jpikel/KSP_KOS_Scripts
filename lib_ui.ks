//Filename: lib_ui.ks
//Description: terminal UI helpers for a consistent cockpit look across scripts.
//To include: runoncepath("lib_ui.ks").
//
// ui_header(title)              boxed title on rows 0-2
// ui_kv(label, value, row)      aligned "label      : value" line
// ui_bar(label, frac, txt, row) progress bar: "label [#####....] txt"
// ui_time(seconds)              "2d 3h 4m 5s" style duration string

@LAZYGLOBAL OFF.

declare function ui_repeat {
    parameter ch.
    parameter n.
    if n <= 0 {
        return "".
    }
    return ("":padleft(n)):replace(" ", ch).
}

declare function ui_header {
    parameter title.
    local w to min(terminal:width - 2, 46).
    local inner to w - 2.
    if title:length > inner {
        set title to title:substring(0, inner).
    }
    print "+" + ui_repeat("-", w) + "+" at (0, 0).
    print "| " + title:padright(inner) + " |" at (0, 1).
    print "+" + ui_repeat("-", w) + "+" at (0, 2).
}

declare function ui_kv {
    parameter label.
    parameter value.
    parameter row.
    print (label:padright(11) + ": " + value):padright(terminal:width - 1) at (0, row).
}

declare function ui_bar {
    parameter label.
    parameter frac.
    parameter valtext.
    parameter row.
    local w to 20.
    local n to max(0, min(w, floor(frac * w + 0.5))).
    print (label:padright(11) + "[" + ui_repeat("#", n) + ui_repeat(".", w - n)
           + "] " + valtext):padright(terminal:width - 1) at (0, row).
}

declare function ui_time {
    parameter secs.
    local hpd to kuniverse:hoursperday.
    local s to max(0, round(secs)).
    local m to floor(s / 60). set s to mod(s, 60).
    local h to floor(m / 60). set m to mod(m, 60).
    local d to floor(h / hpd). set h to mod(h, hpd).
    if d > 0 { return d + "d " + h + "h " + m + "m " + s + "s". }
    if h > 0 { return h + "h " + m + "m " + s + "s". }
    return m + "m " + s + "s".
}
