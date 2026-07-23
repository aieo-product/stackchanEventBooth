// booth/assembly.scad
// Places the LT-meetup photo-booth parts in their assembled position for the
// browser assembly viewer (three.js), same pipeline as ferris/assembly.scad.
//   - origin = centre of the 2x2 floor-tile area, z=0 on the table
//   - audience side = -Y (camera front), screen wall at the back (+Y)
// Export groups (Makefile `viewer-models-booth`, docs/public/models/booth/):
//   floor, stage, podium, robot, screen, wall-side, stands

include <../params.scad>;
use <floor_tile.scad>;
use <wall_panel.scad>;
use <stand_clips.scad>;
use <lt_podium.scad>;
use <../ferris/k151.scad>;

PART = "all";

floor_top  = tile_t;                       // 3
panel_lift = 15;                           // panel bottom z in a stand (tabs reach z=3)
stage_y0   = -20;                          // stage front edge (audience side)
scr_y      = stage_y0 + stage_y + 28;      // screen panel plane
side_x     = -tile_x + 18;                 // side wall plane

module a_floor() {
    color("burlywood")
        for (ix = [-1, 0]) for (iy = [-1, 0])
            translate([ix * tile_x, iy * tile_y, 0]) floor_tile();
}

module a_stage() {
    color("slategray")
        translate([-stage_x/2, stage_y0, floor_top]) stage();
}

module a_podium() {
    color("white")
        translate([-pod_w/2, stage_y0 + 12, floor_top + stage_t]) podium();
}

module a_robot() {
    // K151 behind the podium, facing the audience (-Y)
    color("lightsteelblue")
        translate([0, stage_y0 + 12 + pod_d + 28, floor_top + stage_t])
            rotate([0, 0, 180]) k151();   // native +Y facing -> turn to the audience (-Y)
}

module a_screen() {
    // stood upright: rotate X90 -> panel plane X-Z, tabs hang below
    color("whitesmoke")
        translate([-wall_x/2, scr_y, panel_lift])
            rotate([90, 0, 0]) screen();
}

module a_wall_side() {
    // window panel along the left edge (rotated 90 around Z)
    color("lightgray")
        translate([side_x, wall_x/2 - 130, panel_lift])
            rotate([0, 0, 90]) rotate([90, 0, 0]) window();
}

module a_stands() {
    color("gray") {
        for (sx = [-1, 1])                                  // under the screen
            translate([sx * 30 - stand_x/2, scr_y - 2.5, floor_top]) stand();
        translate([side_x + 2.5, wall_x/2 - 130 + wall_x/2 - stand_x/2, floor_top])
            rotate([0, 0, 90]) stand();                     // under the side wall
    }
}

if (PART == "floor")          a_floor();
else if (PART == "stage")     a_stage();
else if (PART == "podium")    a_podium();
else if (PART == "robot")     a_robot();
else if (PART == "screen")    a_screen();
else if (PART == "wall-side") a_wall_side();
else if (PART == "stands")    a_stands();
else {
    a_floor(); a_stage(); a_podium(); a_robot();
    a_screen(); a_wall_side(); a_stands();
}
