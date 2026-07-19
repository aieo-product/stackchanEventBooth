// ferris/gondola.scad  (redesign v3, #18: side-arm open-top gondola)
// Carries one M5Stack K151 unit (base 48x56, whole 54x70.5x61.5, 187.2 g).
//
// v3 lesson (7/19 test): a central top bridge blocks EVERY loading path -
// the robot could not be placed at all. The bridge is gone; the axle is now
// held by TWO hook towers at the front/back edges (outside the robot's 70.5
// footprint), so the top is fully open and the unit drops straight in from
// above into the nested floor pockets. Same as the izakaya drink-wheel that
// inspired the build.
//
// Loading corridor (numeric): unit 54(X) x 70.5(Y), descends from above.
//   side rails inner  +/-37  vs unit +/-27    -> 10.0 mm/side
//   hook towers inner +/-37(Y) vs unit +/-35.25 -> 1.75 mm/side
//   front bar inner    +37   vs unit +35.25   -> 1.75 mm
//   backrest inner     -39   vs unit -35.25   -> 3.75 mm
//
// Axes: +X = left/right, +Y = wheel axis (hook towers), Z = up. Seat top z=6.

include <../params.scad>;

seat_z    = gon_floor_t;                        // 6, top of the seat plate
tower_top = gon_pivot_z + gon_hook_d + 2.5;     // 82.2: 2.5 mm roof over the transfer channel
tower_w   = 16;                                 // hook tower width (X)
tower_t   = 6;                                  // hook tower thickness (Y)

module d_bar(len, d) {
    // horizontal bar (along X) with a flat underside -> bridges support-free
    intersection() {
        rotate([0, 90, 0]) cylinder(d = d, h = len, center = true, $fn = 32);
        translate([0, 0, 1.5]) cube([len + 1, d + 1, d], center = true);
    }
}

module j_slot_2d() {
    // keyhole profile in the X-Z plane; rod centre rests at (0, gon_pivot_z).
    // Drop in at the +4 offset entry, slide sideways, settle ~3 mm down.
    union() {
        translate([4 - gon_hook_d/2, gon_pivot_z])
            square([gon_hook_d, tower_top - gon_pivot_z + 1]);   // entry
        translate([-gon_hook_d/2, gon_pivot_z])
            square([4 + gon_hook_d, gon_hook_d]);                // transfer
        translate([0, gon_pivot_z]) circle(d = gon_hook_d);      // seat
        translate([-gon_hook_d/2, gon_pivot_z - gon_hook_d/2])
            square([gon_hook_d, gon_hook_d/2]);
    }
}

module hook_tower(y_out) {
    // tower standing on the floor edge, J-slot cut through its 6 mm thickness
    difference() {
        translate([-tower_w/2, y_out - tower_t, 0])
            cube([tower_w, tower_t, tower_top]);
        translate([0, y_out + 1, 0])
            rotate([90, 0, 0])
                linear_extrude(tower_t + 2)
                    j_slot_2d();
    }
}

module gondola() {
    difference() {
        union() {
            // --- seat plate ---
            translate([0, 0, seat_z/2])
                cube([gon_floor_x, gon_floor_y, gon_floor_t], center = true);
            // --- side rails (+/-X), low, leave the top open ---
            for (sx = [-1, 1])
                translate([sx * (gon_floor_x/2 - gon_wall_t/2), 0, seat_z + gon_side_h/2])
                    cube([gon_wall_t, gon_floor_y, gon_side_h], center = true);
            // --- backrest wall (-Y) ---
            translate([0, -gon_floor_y/2 + gon_wall_t/2, seat_z + gon_backrest_h/2])
                cube([gon_floor_x, gon_wall_t, gon_backrest_h], center = true);
            // --- hook towers on the front/back edges (axle along Y) ---
            hook_tower(gon_floor_y/2);                    // front (+Y)
            mirror([0, 1, 0]) hook_tower(gon_floor_y/2);  // back  (-Y)
            // --- front safety bar (merges into the front tower) ---
            translate([0, gon_floor_y/2 - gon_bar_d/2, seat_z + gon_bar_rise])
                d_bar(2 * gon_post_cx, gon_bar_d);
        }
        // --- two-stage nested floor pockets ---
        translate([0, 0, seat_z - gon_pocket_o_d])
            cube([gon_pocket_o, gon_pocket_o, gon_pocket_o_d + 0.1], center = true);
        translate([0, 0, seat_z - gon_pocket_i_d])
            cube([gon_pocket_i_x, gon_pocket_i_y, gon_pocket_i_d + 0.1], center = true);
    }
}

gondola();
