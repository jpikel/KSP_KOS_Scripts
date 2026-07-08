//Filename: lib_lambert.ks
//Description: universal-variables Lambert solver (Bate-Mueller-White):
//given two POSITIONS around a body and a time of flight, returns the
//velocities of the connecting orbit. This is the math under every transfer
//window planner - it frees transfers from the 180-degree in-plane Hohmann
//assumption (arbitrary sweep angle, full 3D).
//
// lambert(r1v, r2v, tof, mu, hdir) -> lexicon("ok", bool, "v1", vec, "v2", vec)
//   r1v/r2v : positions relative to the central body
//   tof     : seconds between them
//   hdir    : desired orbit normal (e.g. the departure planet's angular
//             momentum) so "prograde" is physical, not a handedness guess
//kOS trig speaks degrees; radian conversions are explicit. Single-rev only.

@LAZYGLOBAL OFF.

local r2d to 180 / constant():pi.

declare function stumpff_c {
    parameter z.
    if z > 0.000001 {
        return (1 - cos(sqrt(z) * r2d)) / z.
    } else if z < -0.000001 {
        local sz to sqrt(-z).
        return ((constant():e^sz + constant():e^(-sz)) / 2 - 1) / (-z).
    }
    return 0.5.
}

declare function stumpff_s {
    parameter z.
    if z > 0.000001 {
        local sz to sqrt(z).
        return (sz - sin(sz * r2d)) / (sz^3).
    } else if z < -0.000001 {
        local sz to sqrt(-z).
        return ((constant():e^sz - constant():e^(-sz)) / 2 - sz) / (sz^3).
    }
    return 1 / 6.
}

declare function lambert {
    parameter r1v.
    parameter r2v.
    parameter tof.
    parameter mu.
    parameter hdir.

    local r1 to r1v:mag.
    local r2 to r2v:mag.
    local dnu to vang(r1v, r2v).
    if vdot(vcrs(r1v, r2v), hdir) < 0 {
        set dnu to 360 - dnu. //keep the transfer prograde around hdir
    }
    if dnu < 5 or abs(dnu - 180) < 2 {
        return lexicon("ok", false). //degenerate geometry
    }
    local aa to sin(dnu) * sqrt(r1 * r2 / (1 - cos(dnu))).

    declare function tof_z {
        parameter z.
        local c to stumpff_c(z).
        local s to stumpff_s(z).
        if c <= 0 {
            return -1.
        }
        local y to r1 + r2 + aa * (z * s - 1) / sqrt(c).
        if y < 0 {
            return -1.
        }
        return ((y / c)^1.5 * s + aa * sqrt(y)) / sqrt(mu).
    }

    //bisection on z (tof grows monotonically with z); walk the lower bound
    //up out of any invalid (y < 0) region first
    local zlo to -30.
    local zhi to (2 * constant():pi)^2 * 0.98.
    from { local i is 0. } until tof_z(zlo) > 0 or i = 30 step { set i to i + 1. } do {
        set zlo to zlo / 1.6 + 0.4.
    }
    if tof_z(zlo) < 0 or tof_z(zlo) > tof or tof_z(zhi) < tof {
        return lexicon("ok", false). //requested TOF outside single-rev range
    }
    local z to 0.
    from { local i is 0. } until i = 55 step { set i to i + 1. } do {
        set z to (zlo + zhi) / 2.
        local t to tof_z(z).
        if t < 0 or t < tof {
            set zlo to z.
        } else {
            set zhi to z.
        }
    }

    local c to stumpff_c(z).
    local s to stumpff_s(z).
    local y to r1 + r2 + aa * (z * s - 1) / sqrt(c).
    local f to 1 - y / r1.
    local g to aa * sqrt(y / mu).
    local gdot to 1 - y / r2.
    return lexicon("ok", true,
                   "v1", (r2v - r1v * f) * (1 / g),
                   "v2", (r2v * gdot - r1v) * (1 / g)).
}
