// accessories/ear_band.scad (7/23)
// Snap-on headband accessories for the K151 head unit (MainBody 54.0 wide,
// measured from cad/vendor/k151/StackChan-MainBody.stl). Prints LYING FLAT.
//   PART = "cat"    : cat ears
//   PART = "bunny"  : tall bunny ears
//   PART = "ribbon" : ribbon / bow
// The U-band clips over the top of the head; small lips snap on the sides.

head_w  = 54.0;
fit     = 0.6;          // opening play
band_t  = 2.4;          // band thickness (in plane)
band_w  = 6;            // band width (print height, lies flat)
arm_len = 14;           // side arm length
lip     = 0.6;          // snap lip at the arm tips

iw = head_w + fit;      // 54.6 inner span

module band() {
    // top bar + two side arms with inward lips (2D in X-Z, extruded in Y)
    linear_extrude(band_w) {
        // top bar
        translate([-iw/2 - band_t, 0]) square([iw + 2 * band_t, band_t]);
        for (sx = [-1, 1]) scale([sx, 1]) {
            // arm
            translate([iw/2, -arm_len]) square([band_t, arm_len]);
            // snap lip
            translate([iw/2 - lip, -arm_len]) square([band_t/2 + lip, 1.6]);
        }
    }
}

module cat_ear() {
    // triangle with a small inner-ear notch
    difference() {
        polygon([[-9, 0], [9, 0], [0, 16]]);
        polygon([[-4.5, 1.2], [4.5, 1.2], [0, 11]]);
    }
}

module cat()   { band();
    for (sx = [-1, 1]) scale([sx, 1, 1])
        translate([iw/2 - 10, 0, 0]) rotate([0, 0, 8])
            translate([0, band_t - 0.01, 0]) linear_extrude(band_w) cat_ear();
}

module bunny_ear() {
    hull() {
        translate([0, 24]) scale([1, 1.6]) circle(d = 11, $fn = 40);
        translate([0, 2]) circle(d = 9, $fn = 40);
    }
}

module bunny() { band();
    for (sx = [-1, 1]) scale([sx, 1, 1])
        translate([iw/2 - 12, band_t - 0.01, 0]) rotate([0, 0, -6])
            linear_extrude(band_w) bunny_ear();
}

module ribbon() { band();
    translate([0, band_t - 0.01, 0]) linear_extrude(band_w) {
        // two bow wings + centre knot
        for (sx = [-1, 1]) scale([sx, 1])
            polygon([[3, 1], [20, 12], [20, 0.5], [3, -1.5]]);
        translate([-4, -2]) square([8, 15]);
    }
}

PART = "cat";
if (PART == "bunny")       bunny();
else if (PART == "ribbon") ribbon();
else                       cat();
