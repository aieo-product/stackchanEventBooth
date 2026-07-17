// ferris/gondola.scad  (redesign #18: chair-type open gondola)
// Carries one M5Stack K151 unit (base 48x56, whole 54x70.5x61.5, 187.2 g).
// Open front + low rails so the screen/body is visible; the unit is loaded from
// the top and sits in a two-stage nested floor pocket (inner = K151 base fit,
// outer = generic/Takao base + gel tape). Hangs from a top bridge whose U-slot
// drops over the Ø3 swing axle; the seat sits well below the pivot so the loaded
// gondola swings as a stable pendulum. Prints floor-down, support-free.
//
// Axes: +X = left/right, +Y = front (open, camera side), Z = up. Seat top z=6.

include <../params.scad>;
use <../lib/dovetail.scad>;

seat_z   = gon_floor_t;                 // 6, top of the seat plate
rail_top = seat_z + gon_side_h;         // 31
bridge_bot = 67;                        // clears the ~65 mm tall unit
bridge_top = gon_pivot_z + gon_hook_d + 2.5;   // 82: full roof (2.5 mm) above the transfer channel

module d_bar(len, d) {
    // horizontal bar (along X) with a flat underside -> bridges support-free
    intersection() {
        rotate([0, 90, 0]) cylinder(d = d, h = len, center = true, $fn = 32);
        translate([0, 0, 1.5]) cube([len + 1, d + 1, d], center = true);
    }
}

module gondola() {
    difference() {
        union() {
            // --- seat plate ---
            translate([0, 0, seat_z/2])
                cube([gon_floor_x, gon_floor_y, gon_floor_t], center = true);
            // --- side rails (+/-X), full depth, low ---
            for (sx = [-1, 1])
                translate([sx * (gon_floor_x/2 - gon_wall_t/2), 0, seat_z + gon_side_h/2])
                    cube([gon_wall_t, gon_floor_y, gon_side_h], center = true);
            // --- backrest wall (-Y) ---
            translate([0, -gon_floor_y/2 + gon_wall_t/2, seat_z + gon_backrest_h/2])
                cube([gon_floor_x, gon_wall_t, gon_backrest_h], center = true);
            // --- hanger posts (+/-X) up to the bridge ---
            for (sx = [-1, 1])
                translate([sx * gon_post_cx, 0, seat_z])
                    translate([-gon_post_x/2, -gon_post_y/2, 0])
                        cube([gon_post_x, gon_post_y, bridge_bot - seat_z + 2]);
            // --- top hanger bridge (holds the swing-axle U-slot) ---
            translate([0, 0, bridge_bot])
                translate([-(gon_post_cx + gon_post_x/2), -gon_bridge_y/2, 0])
                    cube([2 * gon_post_cx + gon_post_x, gon_bridge_y, bridge_top - bridge_bot]);
            // --- front safety bar (at the very front edge, outside the 70.5 envelope) ---
            translate([0, gon_floor_y/2 - gon_bar_d/2, seat_z + gon_bar_rise])
                d_bar(2 * gon_post_cx, gon_bar_d);
        }
        // --- two-stage nested floor pockets ---
        translate([0, 0, seat_z - gon_pocket_o_d])
            cube([gon_pocket_o, gon_pocket_o, gon_pocket_o_d + 0.1], center = true);
        translate([0, 0, seat_z - gon_pocket_i_d])
            cube([gon_pocket_i_x, gon_pocket_i_y, gon_pocket_i_d + 0.1], center = true);
        // --- J-slot (keyhole) for the Ø3 swing axle: drop in at the offset
        // entry, slide sideways, rod settles 1.7 mm down into the seat.
        // Escaping needs lift + sideways shift, so the loaded gondola cannot
        // jump off while the wheel is cranked. Channels extruded along Y.
        translate([0, gon_bridge_y/2 + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(gon_bridge_y + 2)
                    union() {
                        // vertical entry channel (offset +4 in X)
                        translate([4 - gon_hook_d/2, gon_pivot_z])
                            square([gon_hook_d, bridge_top - gon_pivot_z + 1]);
                        // horizontal transfer channel
                        translate([-gon_hook_d/2, gon_pivot_z])
                            square([4 + gon_hook_d, gon_hook_d]);
                        // seat pocket (rod centre at gon_pivot_z)
                        translate([0, gon_pivot_z])
                            circle(d = gon_hook_d);
                        translate([-gon_hook_d/2, gon_pivot_z - gon_hook_d/2])
                            square([gon_hook_d, gon_hook_d/2]);
                    }
    }
}

gondola();
