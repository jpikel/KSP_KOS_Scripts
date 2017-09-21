// Filename: autop.ks
// Description: the beginnings of an autopilot
// at this time it only holds on a particular heading and altitude

@lazyglobal off.


declare function autop(){
    local cur_alt to altitude.
    local hd to 



    lock cur_pitch to 90 - vang(up:vector, ship:facing:forevector).
