// booth/lt_podium.scad
// LT-meetup diorama props (7/23): single-colour fast prints, assembled later.
//   PART = "podium" : lectern the K151 stands behind (slanted reading top,
//                     front recess for a paper logo card 44 x 26)
//   PART = "stage"  : 150 x 100 x 8 riser plate with chamfered front edge
// Select at CLI:  openscad -D 'PART="stage"' -o stage.stl lt_podium.scad

include <../params.scad>;

PART = "podium";

module podium() {
    difference() {
        // outer block with slanted top (front high -> back low, robot side)
        hull() {
            cube([pod_w, pod_d, 1]);
            translate([0, 0, pod_h_front - 1]) cube([pod_w, 1, 1]);
            translate([0, pod_d - 1, pod_h_back - 1]) cube([pod_w, 1, 1]);
        }
        // NOTE: intentionally solid - a modelled hollow would close into a
        // ~59 mm unsupported bridge under the slanted top. Sparse slicer
        // infill (8-10%) keeps it fast instead.
        // front logo-card recess (paper 44 x 26)
        translate([(pod_w - pod_logo_w) / 2, -0.01, 8])
            cube([pod_logo_w, pod_logo_d, pod_logo_h]);
    }
}

module stage() {
    // riser plate, chamfered on the front (audience) edge
    hull() {
        translate([0, stage_chamfer, 0]) cube([stage_x, stage_y - stage_chamfer, stage_t]);
        translate([0, 0, stage_t - stage_chamfer])
            cube([stage_x, stage_y, stage_chamfer]);
        cube([stage_x, 1, 1]);
    }
}

if (PART == "stage") stage();
else                 podium();
