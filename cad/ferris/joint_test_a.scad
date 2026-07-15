// joint_test_a.scad
// Coupon A: the 0 deg end of the rim segment (dovetail mortise + M3 insert boss).
// Centered near the origin, flat on the bed. Mates with joint_test_b.

include <../params.scad>
use <../lib/dovetail.scad>
use <rim_segment.scad>

coupon = 45;   // cube side of the cut region around the joint end

// bring the 0 deg end (located near x=rim_outer_r-..150, y=0) back to origin
translate([-(rim_inner_r - 12) - (rim_radial_w + 30)/2, 0, 0])
    intersection() {
        rim_segment();
        translate([rim_inner_r - 12, -coupon/2 + 10, -1])
            cube([rim_radial_w + 30, coupon, rim_depth + 2]);
    }
