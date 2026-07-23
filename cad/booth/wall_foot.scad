// booth/wall_foot.scad (7/23 - facade mode)
// Dead-simple foot block for the wall panels: a chamfered brick with one
// slot. Two per wall, pushed onto the bottom edge -> the wall stands alone.
// ~10 min each (vs 40 min for the full stand+clip plate). No floor needed.

include <../params.scad>;

foot_x = 60;                  // along the wall
foot_y = 40;                  // depth (anti-tip)
foot_h = 14;
slot_d = 12;                  // wall bottom tab is 12 tall -> flush

module wall_foot() {
    difference() {
        hull() {
            translate([0, 0, 0]) cube([foot_x, foot_y, foot_h - 4]);
            translate([4, 4, 0]) cube([foot_x - 8, foot_y - 8, foot_h]);
        }
        // slot for the panel (fits both the tab and the plain bottom edge)
        translate([-1, foot_y/2 - (wall_t + 0.8)/2, foot_h - slot_d])
            cube([foot_x + 2, wall_t + 0.8, slot_d + 1]);
    }
}

wall_foot();
