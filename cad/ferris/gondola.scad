// ferris/gondola.scad
// Swing gondola for one Stack-chan unit (approx 54x54x65, ~150 g).
// Inner clear 75x75x85, front guard 40 mm with an upper loading opening,
// bottom anti-slip ribs, and two upward-open hook slots that drop over the
// Ø3 mm swing axle (print open-top-up -> no supports).

include <../params.scad>;
use <../lib/dovetail.scad>;

// axis convention: +X = front (guard), +/-Y = sides (hooks / swing axle in Y), Z = up
floor_t = gon_wall;         // floor thickness = wall
hook_x  = 14;               // hook tab width (X)
hook_y  = 4;                // hook tab thickness (Y)
hook_top = gon_out_z + gon_hook_rise;   // top of hook tab
slot_depth = 10;            // U-slot depth

module gondola() {
    difference() {
        union() {
            rounded_box(gon_out_x, gon_out_y, gon_out_z, r = 3);
            // hook tabs on the two side walls (+/-Y), centred in X
            for (sy = [-1, 1])
                translate([-hook_x/2, sy * (gon_out_y/2 - hook_y/2) - hook_y/2, gon_out_z])
                    cube([hook_x, hook_y, gon_hook_rise]);
            // floor anti-slip ribs (run in Y)
            for (i = [0 : gon_rib_n - 1])
                translate([-gon_in_x/2 + (i + 0.5) * gon_in_x / gon_rib_n - gon_rib_w/2,
                           -gon_in_y/2, floor_t])
                    cube([gon_rib_w, gon_in_y, gon_rib_h]);
        }
        // inner cavity (open top)
        translate([0, 0, floor_t])
            rounded_box(gon_in_x, gon_in_y, gon_out_z, r = 2);
        // front guard: lower the central front wall to guard height (loading opening)
        translate([gon_in_x/2 - 0.5, -28, gon_guard_h])
            cube([gon_wall + 4, 56, gon_out_z]);
        // upward-open hook U-slots (drop over the Ø3 axle)
        for (sy = [-1, 1])
            translate([-gon_hook_d/2, sy * (gon_out_y/2) - 10, hook_top - slot_depth])
                cube([gon_hook_d, 20, slot_depth + 1]);
    }
}

gondola();
