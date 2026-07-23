// ferris/crank.scad (7/23 v2 - steel-rod handle)
// The printed grip post snapped in testing -> the handle is now the SPARE
// 8 mm stainless rod (the shafts came as a 2-pack): a stout boss at the arm
// end takes the rod in a blind 8.2 socket locked by an M3 set screw. A
// test-print sleeve (any 8.2-bore piece) slides over the rod as the grip.
//   1. crank body : hub (8.2 bore + M3 set screw) + arm + rod socket boss
//   2. damper     : C-clip friction damper (optional)
// Shaft axis = Z (print flat).

include <../params.scad>;
use <../lib/dovetail.scad>;

hub_h_c  = 16;
arm_h    = crank_arm_t;        // 10
rod_boss_d = 18;               // handle boss around the rod socket
rod_boss_h = 30;
rod_sock_d = 8.4;              // spare-rod fit (a touch looser than the hub)
rod_sock_depth = 26;           // blind socket from the boss top

module crank_body() {
    difference() {
        union() {
            cylinder(d = crank_hub_d, h = hub_h_c);                 // hub
            translate([0, -crank_arm_w/2, 0])
                cube([crank_arm_len, crank_arm_w, arm_h]);          // arm
            translate([crank_arm_len, 0, 0])
                cylinder(d = rod_boss_d, h = rod_boss_h);           // rod socket boss
        }
        // shaft bore
        translate([0, 0, -1]) cylinder(d = crank_shaft_d, h = hub_h_c + 2);
        // radial M3 set-screw insert to the bore
        translate([crank_hub_d/2 + 2, 0, hub_h_c/2]) rotate([0, -90, 0])
            cylinder(d = crank_set_insert_d, h = crank_hub_d/2 + 3);
        // blind rod socket + radial M3 set screw
        translate([crank_arm_len, 0, rod_boss_h - rod_sock_depth])
            cylinder(d = rod_sock_d, h = rod_sock_depth + 1);
        translate([crank_arm_len + rod_boss_d/2 + 1, 0, rod_boss_h - 12])
            rotate([0, -90, 0]) cylinder(d = m3_thread, h = rod_boss_d/2 + 3);
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

// layout for a single plate (grip sleeve = reuse any 8.2-bore test print)
crank_body();
translate([crank_arm_len + 45, 0, 0]) damper();
