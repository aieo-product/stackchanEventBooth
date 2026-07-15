// ferris/tower.scad
// A-frame support post, total height 280, printed in two halves.
//   part = "lower" : feet (base slot tabs + M3 thumbscrew) + splice dowels (male)
//   part = "upper" : apex with 608 bearing pocket + splice sockets (female)
// Select at CLI:  openscad -D 'part="upper"' -o tower-upper.stl tower.scad
// Splice = square dowel + M3 x2 (one per leg). Bearing axis is Y (toward wheel).

include <../params.scad>;
use <../lib/dovetail.scad>;

part = "lower";               // overridden from the Makefile

depth    = 30;                // Y depth of the frame
foot_x   = 48;               // foot centre offset
foot_zc  = 10;
apex_zc  = tower_total_h - 22;   // 258, apex block centre
split_z  = 135;              // horizontal split plane (keeps both halves <=170)
// leg centreline x at the split (linear foot->apex interpolation)
split_x  = foot_x + (0 - foot_x) * (split_z - foot_zc) / (apex_zc - foot_zc);
dowel    = splice_dowel;     // 8 mm square dowel
boss_d   = bearing_d + 8;    // 30 mm bearing boss

module leg(sx) {
    hull() {
        translate([sx * foot_x, depth/2, foot_zc]) cube([26, depth, 20], center = true);
        translate([0, depth/2, apex_zc])           cube([42, depth, 44], center = true);
    }
}

module frame_solid() {
    leg(1); leg(-1);
    // base crossbar between feet
    translate([-foot_x, 0, 0]) cube([foot_x * 2, depth, 18]);
    // mid crossbar for A-frame rigidity (stays in the lower half)
    translate([-30, 0, 122]) cube([60, depth, 16]);
    // apex bearing boss (axis Y)
    translate([0, 0, apex_zc]) rotate([-90, 0, 0]) cylinder(d = boss_d, h = depth);
}

module bearing_features() {
    // subtract from the inner face (y = depth) going outward
    translate([0, depth + 0.01, apex_zc]) rotate([90, 0, 0]) {
        cylinder(d = bearing_d - 2 * bearing_lip, h = 1.2 + 0.02);           // lip mouth
        cylinder(d = bearing_d, h = bearing_h + 1.2);                        // bearing pocket
    }
    // shaft through bore
    translate([0, -1, apex_zc]) rotate([-90, 0, 0]) cylinder(d = bearing_bore, h = depth + 2);
}

module foot_tabs() {
    for (sx = [-1, 1])
        translate([sx * foot_x - foot_tab_w/2, depth/2 - foot_tab_t/2, -foot_tab_h])
            cube([foot_tab_w, foot_tab_t, foot_tab_h + 2]);
}

module thumb_holes() {
    for (sx = [-1, 1])
        translate([sx * foot_x, -1, 8]) rotate([-90, 0, 0])
            cylinder(d = thumb_hole_d, h = depth + 2);
}

module splice_dowels_male() {
    for (sx = [-1, 1])
        translate([sx * split_x, depth/2, split_z])
            translate([-dowel/2, -dowel/2, 0]) cube([dowel, dowel, 18]);
}

module splice_sockets() {
    for (sx = [-1, 1])
        translate([sx * split_x, depth/2, split_z - 0.01])
            translate([-(dowel + tol)/2, -(dowel + tol)/2, 0])
                cube([dowel + tol, dowel + tol, 20]);
}

module splice_bolts() {
    for (sx = [-1, 1])
        translate([sx * split_x, -1, split_z + 9]) rotate([-90, 0, 0])
            cylinder(d = m3_clear, h = depth + 2);
}

module tower(part) {
    if (part == "lower") {
        difference() {
            union() {
                intersection() {
                    frame_solid();
                    translate([-100, -1, -foot_tab_h - 1]) cube([200, depth + 2, split_z + foot_tab_h + 1]);
                }
                foot_tabs();
                splice_dowels_male();
            }
            thumb_holes();
            splice_bolts();
        }
    } else {
        difference() {
            intersection() {
                frame_solid();
                translate([-100, -1, split_z]) cube([200, depth + 2, tower_total_h - split_z + 2]);
            }
            bearing_features();
            splice_sockets();
            splice_bolts();
        }
    }
}

tower(part);
