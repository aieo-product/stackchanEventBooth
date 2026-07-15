// joint_test_b.scad
// Coupon B: the 90 deg end of the rim segment (dovetail tenon + clearance lug).
// Centered near the origin, flat on the bed. Mates with joint_test_a.

include <../params.scad>
use <../lib/dovetail.scad>
use <rim_segment.scad>

coupon = 45;   // cube side of the cut region around the joint end

// the 90 deg end sits near x=0, y=rim_outer_r; rotate it down to +x axis
// then bring it back to the origin
translate([-(rim_inner_r - 12) - (rim_radial_w + 30)/2, 0, 0])
    rotate([0, 0, -90])
        intersection() {
            rim_segment();
            translate([-coupon/2 + 10, rim_inner_r - 12, -1])
                cube([coupon, rim_radial_w + 30, rim_depth + 2]);
        }
