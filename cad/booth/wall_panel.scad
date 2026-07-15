// booth/wall_panel.scad
// Wall panel 150 x 125 x 5, shared base + three variants.
//   variant = "blackboard" : framed shallow recess (green paper backing)
//   variant = "window"     : 2x2 window openings + back rebate for sky paper
//   variant = "board"      : cork-style frame + pin-hole grid (bulletin board)
// Select at CLI:  openscad -D 'variant="window"' -o wall-window.stl wall_panel.scad
// Panel lies in X-Y (x=150 wide, y=125 tall, z=5 thick); two stand tabs at the
// bottom edge drop into the stand slots.

include <../params.scad>;
use <../lib/dovetail.scad>;

variant = "blackboard";       // overridden from the Makefile

fx = wall_frame;              // frame width
ix0 = fx; ix1 = wall_x - fx;  // interior x range
iy0 = fx; iy1 = wall_y - fx;  // interior y range

module base_panel() {
    // panel body
    translate([0, 0, 0]) cube([wall_x, wall_y, wall_t]);
    // two stand tabs on the bottom edge (protrude -y)
    for (sx = [-1, 1])
        translate([wall_x/2 + sx * 40 - wall_tab_w/2, -wall_tab_h + 0.01, 0])
            cube([wall_tab_w, wall_tab_h, wall_t]);
}

module blackboard() {
    difference() {
        base_panel();
        // shallow recess on the front for a green paper insert
        translate([ix0, iy0, wall_t - bb_recess_d])
            cube([ix1 - ix0, iy1 - iy0, bb_recess_d + 0.1]);
    }
}

module window() {
    difference() {
        base_panel();
        // 2x2 through openings separated by a cross mullion
        cx = (ix0 + ix1) / 2;
        cy = (iy0 + iy1) / 2;
        for (px = [[ix0, cx - win_mullion/2], [cx + win_mullion/2, ix1]])
            for (py = [[iy0, cy - win_mullion/2], [cy + win_mullion/2, iy1]])
                translate([px[0], py[0], -1])
                    cube([px[1] - px[0], py[1] - py[0], wall_t + 2]);
        // back rebate for the sky-image paper
        translate([ix0 - 2, iy0 - 2, -0.01])
            cube([ix1 - ix0 + 4, iy1 - iy0 + 4, win_inset]);
    }
}

module board() {
    difference() {
        union() {
            base_panel();
            // raised cork frame
            difference() {
                translate([ix0 - cork_frame, iy0 - cork_frame, wall_t])
                    cube([ix1 - ix0 + 2 * cork_frame, iy1 - iy0 + 2 * cork_frame, 1.5]);
                translate([ix0, iy0, wall_t - 0.01])
                    cube([ix1 - ix0, iy1 - iy0, 2]);
            }
        }
        // pin-hole grid (blind holes)
        for (i = [0 : pin_grid - 1])
            for (j = [0 : pin_grid - 1])
                translate([ix0 + (i + 0.5) * (ix1 - ix0) / pin_grid,
                           iy0 + (j + 0.5) * (iy1 - iy0) / pin_grid,
                           wall_t - pin_hole_depth])
                    cylinder(d = pin_hole_d, h = pin_hole_depth + 0.1);
    }
}

if (variant == "window")          window();
else if (variant == "board")      board();
else                              blackboard();
