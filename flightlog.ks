//Filename: flightlog.ks
//Description: appends launch statistics to 0:/flightlog.csv on the archive -
//one row per flight, so ascent tuning becomes a dataset instead of a memory.
//Include with runoncepath("flightlog.ks") and call log_flight(...).
//Open the csv in any spreadsheet; lower dv_to_orbit = better gravity turn.

@LAZYGLOBAL OFF.

declare function log_flight {
    parameter dv_used.
    parameter elapsed.
    parameter ltwr.
    parameter mtwr.

    local f to "0:/flightlog.csv".
    if not exists(f) {
        log "date,ship,body,ap_km,pe_km,inc_deg,dv_to_orbit,elapsed_s,liftoff_twr,max_twr" to f.
    }
    log ("Y" + time:year + " D" + time:day + " " + time:clock) + ","
        + ship:name:replace(",", " ") + ","
        + body:name + ","
        + round(ship:orbit:apoapsis / 1000, 1) + ","
        + round(ship:orbit:periapsis / 1000, 1) + ","
        + round(ship:orbit:inclination, 2) + ","
        + round(dv_used) + ","
        + round(elapsed) + ","
        + ltwr + ","
        + mtwr
        to f.
}
