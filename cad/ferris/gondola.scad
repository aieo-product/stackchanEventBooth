// ferris/gondola.scad  (redesign v4, #18: robot faces the OPEN +X side)
// Carries one M5Stack K151 unit (base 48x56, whole 54x70.5x61.5, 187.2 g).
//
// v4 lesson (7/21 test): in v3 the robot faced +Y - straight into the front
// hook tower and the safety bar fused to it, so the screen was blocked.
// The hook towers can only sit on the +/-Y edges (the axle runs along Y),
// therefore the ROBOT must face +X: pocket, backrest and bar are rotated 90
// degrees. The +X face now has only the low lap bar; the screen is fully
// visible and the towers are beside the robot, not in front of it.
// Pivot raised 73 -> 80 so the head-to-axle clearance grows 6 -> 13 mm.
//
// Loading corridor (numeric): unit descends from above,
//   footprint 70.5(X) x 54(Y), envelope corners (+/-35.25, +/-27).
//   hook towers inner  +/-31 (Y) vs +/-27      -> 4.0 mm/side
//   backrest inner      -40 (X) vs -35.25      -> 4.75 mm
//   bar corner posts    inner x=+37.5 vs +35.25 -> 2.25 mm
//   above: fully open (no bridge; axle is 13 mm above the head when hung)
//
// Axes: +X = robot facing (open, audience side), +Y = wheel axle. Seat top z=6.

include <../params.scad>;

seat_z    = gon_floor_t;                        // 6, top of the seat plate
tower_top = gon_pivot_z + gon_hook_d + 2.5;     // 89.2: 2.5 mm roof over the transfer channel
tower_w   = 16;                                 // hook tower width (X)
tower_t   = 6;                                  // hook tower thickness (Y)
post_w    = 6;                                  // bar corner post size (X)
post_l    = 8;                                  //   and (Y)

module d_bar_y(len, d) {
    // horizontal bar (along Y) with a flat underside -> bridges support-free
    intersection() {
        rotate([90, 0, 0]) cylinder(d = d, h = len, center = true, $fn = 32);
        translate([0, 0, 1.5]) cube([d + 1, len + 1, d], center = true);
    }
}

module j_slot_2d() {
    // keyhole profile in the X-Z plane; rod centre rests at (0, gon_pivot_z).
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
    // tower standing on the +/-Y floor edge, J-slot cut through its thickness
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
            // --- side rails on the +/-Y edges (low, merge with the towers) ---
            for (sy = [-1, 1])
                translate([0, sy * (gon_floor_y/2 - gon_wall_t/2), seat_z + gon_side_h/2])
                    cube([gon_floor_x, gon_wall_t, gon_side_h], center = true);
            // --- backrest wall on the -X edge (behind the robot) ---
            translate([-gon_floor_x/2 + gon_wall_t/2, 0, seat_z + gon_backrest_h/2])
                cube([gon_wall_t, gon_floor_y, gon_backrest_h], center = true);
            // --- hook towers on the +/-Y edges (axle along Y) ---
            hook_tower(gon_floor_y/2);
            mirror([0, 1, 0]) hook_tower(gon_floor_y/2);
            // --- lap bar across the open +X face, on two corner posts ---
            for (sy = [-1, 1])
                translate([gon_floor_x/2 - post_w - 0.5, sy * (gon_floor_y/2 - gon_wall_t - post_l/2), seat_z])
                    translate([0, -post_l/2, 0])
                        cube([post_w, post_l, gon_bar_rise + gon_bar_d/2]);
            translate([gon_floor_x/2 - post_w/2 - 0.5, 0, seat_z + gon_bar_rise])
                d_bar_y(gon_floor_y - 2 * gon_wall_t, gon_bar_d);
        }
        // --- two-stage nested floor pockets (robot faces +X) ---
        translate([0, 0, seat_z - gon_pocket_o_d])
            cube([gon_pocket_o, gon_pocket_o, gon_pocket_o_d + 0.1], center = true);
        translate([0, 0, seat_z - gon_pocket_i_d])
            cube([gon_pocket_i_x, gon_pocket_i_y, gon_pocket_i_d + 0.1], center = true);
    }
}

gondola();
