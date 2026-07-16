// mini/adapter_gondola.scad  (#19: Artec wooden ferris kit 055521)
// Drop-in bucket that replaces one wooden gondola. A back peg (tab) mimics the
// wooden seat's protrusion that plugs into the arm-ring's outer hole, so the
// kit is not modified (reversible). Two variants for the ride-along figures.
//   variant = "atomcat"  : inner floor 42x42
//   variant = "minimal"  : inner floor 46x46
// Select at CLI: openscad -D 'variant="minimal"' -o mini-adapter-minimal.stl ...
//
// NOTE: tab/pitch/wheel/seat dimensions are PLACEHOLDERS pending caliper
// measurement (see params.scad mini_* and issue #19). Parametric: change the
// numbers in params.scad and regenerate.
//
// Prints back-face-down (the tab then points up) or floor-down with a tiny
// support under the peg. Modelled floor-down so the STL sits on z=0.

include <../params.scad>;
use <../lib/dovetail.scad>;

variant = "atomcat";     // overridden from the Makefile

inner  = (variant == "minimal") ? mini_minimal_in : mini_atomcat_in;
outer  = inner + 2 * mini_wall;

module adapter_gondola() {
    difference() {
        union() {
            // bucket: floor + back/side walls (mini_depth) + taller front guard
            difference() {
                translate([-outer/2, -outer/2, 0])
                    cube([outer, outer, mini_floor_t + max(mini_depth, mini_guard_h)]);
                // hollow the cavity (open top)
                translate([-inner/2, -inner/2, mini_floor_t])
                    cube([inner, inner, mini_depth + mini_guard_h + 1]);
            }
            // back peg that plugs into the arm-ring outer hole
            translate([-mini_tab_w/2, -outer/2 - mini_tab_l, mini_floor_t + 2])
                cube([mini_tab_w, mini_tab_l + 1, mini_tab_t]);
        }
        // lower the side + back walls to mini_depth (front stays as guard)
        translate([-inner/2 - mini_wall - 1, -outer/2 - 1, mini_floor_t + mini_depth])
            cube([outer + 2, outer - mini_wall, mini_guard_h + 2]);   // back+sides cut
    }
}

adapter_gondola();
