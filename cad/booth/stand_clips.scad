// booth/stand_clips.scad
// Wall-panel stand (100 x 80, t8) + panel connecting clip + position marker,
// laid out for a single print.
//   stand  : a channel foot the panel bottom edge drops into, braced by two
//            triangular end gussets (support-free: slot opens upward).
//   clip   : H-section clip that joins two panel edges side by side.
//   marker : Ø24 floor disc marking Stack-chan's photo spot (raised footprint).

include <../params.scad>;
use <../lib/dovetail.scad>;

rail_h   = 20;               // channel rail height
gusset_d = 40;               // gusset depth (Y)

module stand() {
    slot_w = wall_t + tol;   // panel thickness slot
    difference() {
        union() {
            // channel rail (panel drops into the top slot)
            translate([0, (stand_t - 0)/2, 0])
                translate([0, -8, 0])
                    cube([stand_x, 16, rail_h]);
            // two triangular end gussets in Y-Z, bracing the panel back
            for (ex = [0, stand_x - stand_t])
                translate([ex, -8, 0])
                    rotate([90, 0, 90])
                        linear_extrude(stand_t)
                            polygon([[0, 0], [gusset_d, 0], [0, stand_y]]);
        }
        // upward-open panel slot along the full rail length
        translate([-1, -slot_w/2 - 8 + 8, rail_h - 15])
            cube([stand_x + 2, slot_w, 16]);
    }
}

module clip() {
    // H-section: two channels (each wall_t + tol) back to back
    ch = wall_t + tol;
    difference() {
        cube([clip_len, 2 * ch + 3, 10]);
        translate([-1, 1.5, -1]) cube([clip_len + 2, ch, 7]);          // upper channel
        translate([-1, 1.5, 4]) cube([clip_len + 2, ch, 7]);           // lower channel offset
    }
}

module marker() {
    difference() {
        union() {
            cylinder(d = marker_d, h = 2);
            // raised footprint outline (two small pads = where Stack-chan stands)
            for (sx = [-1, 1])
                translate([sx * 5, 0, 2]) cylinder(d = 6, h = 1);
        }
        // arrow notch pointing to the camera
        translate([0, marker_d/2 - 2, -1]) cylinder(d = 4, h = 5, $fn = 3);
    }
}

stand();
translate([0, 60, 0]) clip();
translate([70, 60, 0]) marker();
