//Filename: lib_orbit.ks
//Description: analytic Kepler propagation for vessels.
//WHY: POSITIONAT(vessel, t) mixes reference frames for far-future t - the
//result drifts by the parent body's own orbital motion (verified in flight:
//a 680 km orbit radius read as 2.74e6 km across a 13-day gap, exactly
//Kerbin's solar chord). Body-vs-body POSITIONAT is fine; vessel prediction
//is not. So vessel positions are propagated from orbital elements instead.
//Elliptical orbits only.
//
// relpos_at(obj, t): position of obj RELATIVE TO THE BODY IT ORBITS, at time t.

@LAZYGLOBAL OFF.

//----- propagate an ORBIT STRUCTURE (e.g. a predicted post-node patch) -----
//Reconstructs the orbit's frame from its elements (LAN/inc/AoP), with the
//angleaxis rotation signs CALIBRATED against a live reference object whose
//position, velocity, and elements we can all measure (pass an inclined one,
//e.g. the target planet - a 0-inclination orbit is degenerate for this).

declare function orbit_frame_cal {
    parameter refobj.
    local o to refobj:orbit.
    local pos to refobj:position - o:body:position.
    local realnorm to vcrs(pos, refobj:velocity:orbit):normalized.

    //s0 flips the hemisphere: kOS's left-handed vcrs measures prograde orbit
    //normals pointing SOUTH-ish, while rotations of celestial north can only
    //make north-ish vectors - without this flip no sign combo can match
    //(seen in flight as a ~163 deg residual).
    local b0 to 1.
    local b1 to 1.
    local b2 to 1.
    local best to 1e9.
    for s0 in list(1, -1) {
        for s1 in list(1, -1) {
            for s2 in list(1, -1) {
                local an to angleaxis(s1 * o:lan, v(0, 1, 0)) * solarprimevector.
                local n to ((angleaxis(s2 * o:inclination, an) * v(0, 1, 0)) * s0):normalized.
                local e to vang(n, realnorm).
                if e < best {
                    set best to e.
                    set b0 to s0.
                    set b1 to s1.
                    set b2 to s2.
                }
            }
        }
    }
    local an to angleaxis(b1 * o:lan, v(0, 1, 0)) * solarprimevector.
    local n to ((angleaxis(b2 * o:inclination, an) * v(0, 1, 0)) * b0):normalized.
    local b3 to 1.
    local beste to 1e9.
    for s3 in list(1, -1) {
        local pdir to angleaxis(s3 * o:argumentofperiapsis, n) * an.
        local rdir to angleaxis(s3 * o:trueanomaly, n) * pdir.
        local e to vang(rdir, pos:normalized).
        if e < beste {
            set beste to e.
            set b3 to s3.
        }
    }
    return lexicon("s0", b0, "s1", b1, "s2", b2, "s3", b3,
                   "resid", max(best, beste)).
}

//solve Kepler's equation: mean anomaly (rad) -> list(true anomaly deg, radius)
declare function kepler_r_nu {
    parameter mrad.
    parameter ecc.
    parameter a.
    local ea to mrad.
    from { local i is 0. } until i = 12 step { set i to i + 1. } do {
        local edeg to ea * 180 / constant():pi.
        set ea to ea - (ea - ecc * sin(edeg) - mrad) / (1 - ecc * cos(edeg)).
    }
    local edeg to ea * 180 / constant():pi.
    local nu to 2 * arctan2(sqrt(1 + ecc) * sin(edeg / 2),
                            sqrt(1 - ecc) * cos(edeg / 2)).
    return list(nu, a * (1 - ecc * cos(edeg))).
}

//position (relative to the orbit's body) of an Orbit STRUCTURE at time t
declare function orbit_relpos_at {
    parameter o.    //Orbit structure (e.g. nextnode:orbit:nextpatch)
    parameter cal.  //signs from orbit_frame_cal
    parameter t.

    local an to angleaxis(cal["s1"] * o:lan, v(0, 1, 0)) * solarprimevector.
    local n to ((angleaxis(cal["s2"] * o:inclination, an) * v(0, 1, 0)) * cal["s0"]):normalized.
    local pdir to (angleaxis(cal["s3"] * o:argumentofperiapsis, n) * an):normalized.

    local twopi to 2 * constant():pi.
    local mm to sqrt(o:body:mu / o:semimajoraxis^3).
    local m to o:meananomalyatepoch * constant():pi / 180 + mm * (t - o:epoch).
    set m to mod(m, twopi).
    if m < 0 { set m to m + twopi. }

    local sol to kepler_r_nu(m, o:eccentricity, o:semimajoraxis).
    return (angleaxis(cal["s3"] * sol[0], n) * pdir) * sol[1].
}

declare function relpos_at {
    parameter obj.
    parameter t.

    local o to obj:orbit.
    local ecc to o:eccentricity.
    local a to o:semimajoraxis.
    local mu to o:body:mu.
    local twopi to 2 * constant():pi.

    local pos_now to obj:position - o:body:position.
    local vel_now to obj:velocity:orbit.
    local hn to vcrs(pos_now, vel_now):normalized.

    //which angleaxis sense about hn matches the direction of motion
    local rotsign to 1.
    if vdot((angleaxis(1, hn) * pos_now:normalized) - pos_now:normalized, vel_now) < 0 {
        set rotsign to -1.
    }

    //current mean anomaly from the current true anomaly
    local nu_now to o:trueanomaly. //deg
    local e_now to 2 * arctan2(sqrt(1 - ecc) * sin(nu_now / 2),
                               sqrt(1 + ecc) * cos(nu_now / 2)). //deg
    local m_now to e_now * constant():pi / 180 - ecc * sin(e_now). //rad

    //advance mean anomaly to t, solve Kepler's equation for the new position
    local n to sqrt(mu / a^3).
    local m to m_now + n * (t - time:seconds).
    set m to mod(m, twopi).
    if m < 0 { set m to m + twopi. }

    local ea to m. //radians; kOS trig wants degrees, hence the conversions
    from { local i is 0. } until i = 12 step { set i to i + 1. } do {
        local edeg to ea * 180 / constant():pi.
        set ea to ea - (ea - ecc * sin(edeg) - m) / (1 - ecc * cos(edeg)).
    }
    local edeg to ea * 180 / constant():pi.
    local nu to 2 * arctan2(sqrt(1 + ecc) * sin(edeg / 2),
                            sqrt(1 - ecc) * cos(edeg / 2)). //deg
    local r to a * (1 - ecc * cos(edeg)).

    //swing today's radial direction forward by the change in true anomaly
    return (angleaxis(rotsign * (nu - nu_now), hn) * pos_now:normalized) * r.
}
