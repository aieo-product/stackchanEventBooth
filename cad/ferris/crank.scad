// ferris/crank.scad
// Hand crank assembly, laid out side by side for a single print:
//   1. crank body : hub (Ø8.2 shaft fit + M3 set-screw insert) + arm + grip post
//   2. grip       : free-spinning sleeve Ø20 x 40 (E-ring groove on the post)
//   3. damper     : C-clip friction damper that lightly pinches the Ø8 shaft
// Shaft axis = Z (print flat). Arm swings in X-Y; grip spins on the Z post.

include <../params.scad>;
use <../lib/dovetail.scad>;

hub_h_c  = 16;
arm_h    = crank_arm_t;        // 10
post_h   = grip_h + 4;         // post a touch longer than the grip

module crank_body() {
    difference() {
        union() {
            cylinder(d = crank_hub_d, h = hub_h_c);                 // hub
            translate([0, -crank_arm_w/2, 0])
                cube([crank_arm_len, crank_arm_w, arm_h]);          // arm
            translate([crank_arm_len, 0, 0])
                cylinder(d = 12, h = 4);                            // post boss
            translate([crank_arm_len, 0, 0])
                cylinder(d = grip_post_d, h = post_h);              // grip post
        }
        // shaft bore
        translate([0, 0, -1]) cylinder(d = crank_shaft_d, h = hub_h_c + 2);
        // radial M3 set-screw insert to the bore
        translate([crank_hub_d/2 + 2, 0, hub_h_c/2]) rotate([0, -90, 0])
            cylinder(d = crank_set_insert_d, h = crank_hub_d/2 + 3);
        // E-ring groove near the post top
        translate([crank_arm_len, 0, post_h - 4])
            rotate_extrude() translate([grip_post_d/2 - 0.6, 0]) square([0.8, 1.0]);
    }
}

module grip() {
    difference() {
        cylinder(d = grip_d, h = grip_h);
        translate([0, 0, -1]) cylinder(d = grip_bore_d, h = grip_h + 2);
    }
}

module damper() {
    difference() {
        union() {
            cylinder(d = damper_bore_d + 2 * damper_wall, h = damper_w);
            translate([-damper_bore_d/2 - damper_wall, 0, 0])         // mount ear
                cube([4, damper_bore_d/2 + damper_wall + 8, damper_w]);
        }
        translate([0, 0, -1]) cylinder(d = damper_bore_d, h = damper_w + 2);   // shaft grip
        translate([-damper_gap/2, 0, -1]) cube([damper_gap, 20, damper_w + 2]); // C mouth
        // mount screw hole in the ear
        translate([-damper_bore_d/2 - damper_wall + 2, damper_bore_d/2 + damper_wall + 3, damper_w/2])
            rotate([0, 90, 0]) cylinder(d = damper_mount_hole, h = 6);
    }
}

// layout for a single plate
crank_body();
translate([crank_arm_len + 35, 0, 0]) grip();
translate([crank_arm_len + 75, 0, 0]) damper();
