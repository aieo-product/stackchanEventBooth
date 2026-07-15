// joint_test.scad
// Small coupons cut from the rim segment ends to test the dovetail fit
// (and the M3 joint bosses) without printing two full 2.2 h segments.
// Prints in ~15 min: piece A = 0 deg end (mortise + insert boss),
// piece B = 90 deg end (tenon + clearance lug), laid side by side.

include <../params.scad>
use <../lib/dovetail.scad>
use <rim_segment.scad>

coupon = 45;   // cube side of the cut region around each joint end

module end_coupon_0deg() {
    // region around the 0 deg end: rim band sits near (rim_outer_r, 0)
    intersection() {
        rim_segment();
        translate([rim_inner_r - 12, -coupon/2 + 10, -1])
            cube([rim_radial_w + 30, coupon, rim_depth + 2]);
    }
}

module end_coupon_90deg() {
    // region around the 90 deg end: rim band sits near (0, rim_outer_r)
    intersection() {
        rim_segment();
        translate([-coupon/2 + 10, rim_inner_r - 12, -1])
            cube([coupon, rim_radial_w + 30, rim_depth + 2]);
    }
}

// lay both coupons flat, side by side
translate([-rim_inner_r + 5, 0, 0]) end_coupon_0deg();
rotate([0, 0, -90])
    translate([-5 - rim_inner_r - 60, rim_inner_r - 100, 0])
        end_coupon_90deg();
