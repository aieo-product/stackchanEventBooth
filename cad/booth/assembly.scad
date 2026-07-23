// booth/assembly.scad
// Places the LT-meetup photo-booth parts in their assembled position for the
// browser assembly viewer (three.js), same pipeline as ferris/assembly.scad.
//   - origin = centre of the 2x2 floor-tile area, z=0 on the table
//   - audience side = -Y, screen wall at the back (+Y), window wall left (-X)
// 7/23 rev3: 6 walls on a 2x2 floor, all plugged into socket curbs.
//   back-left/right = CORNER tiles (curbs +Y and side) -> screen L/R + 1 side wall each
//   front-left/right = single-socket tiles rotated -> side walls
//   left column = window walls x2, right column = plain walls x2, front open
// Export groups (Makefile `viewer-models-booth`, docs/public/models/booth/):
//   floor, stage, podium, robot, screen-l, screen-r, window-walls, plain-walls

include <../params.scad>;
use <floor_tile.scad>;
use <wall_panel.scad>;
use <lt_podium.scad>;
use <../ferris/k151.scad>;

PART = "all";

floor_top = tile_t;                       // 3
wall_z    = sock_h;                       // 13: panel bottom rests on the curb top
wall_yp   = tile_y - sock_w/2;            // 145: wall plane centre from area edge (-150)
stage_y0  = -30;                          // stage front edge (audience side)

// tile centres of the 2x2 grid
tc = tile_x / 2;                          // 75

module a_floor() {
    color("burlywood") {
        translate([-tc,  tc, 0]) corner_socket_tile();                    // back-left: curbs +Y,-X
        translate([ tc,  tc, 0]) rotate([0, 0, -90]) corner_socket_tile();// back-right: curbs +X,+Y
        translate([-tc, -tc, 0]) rotate([0, 0, 90]) wall_socket_tile();   // front-left: curb -X
        translate([ tc, -tc, 0]) rotate([0, 0, -90]) wall_socket_tile();  // front-right: curb +X
    }
}

module a_stage() {
    color("slategray")
        translate([-stage_x/2, stage_y0, floor_top]) stage();
}

module a_podium() {
    color("white")
        translate([-pod_w/2, stage_y0 + 10, floor_top + stage_t]) podium();
}

module a_robot() {
    color("lightsteelblue")
        translate([0, stage_y0 + 10 + pod_d + 26, floor_top + stage_t])
            rotate([0, 0, -90]) k151();   // native +X facing -> turn to the audience (-Y)
}

module standing(v) {
    // panel stood upright (plane X-Z, tabs down)
    rotate([90, 0, 0])
        if (v == "screen-l")      screen_half("L");
        else if (v == "screen-r") screen_half("R");
        else if (v == "window")   window();
        else                      plainwall();
}

module a_screen_l() {
    // back-left socket tile; seam dovetails reach into the R half
    color("ivory")
        translate([-tc - wall_x/2, wall_yp + wall_t/2, wall_z])
            standing("screen-l");
}

module a_screen_r() {
    color("ivory")
        translate([tc - wall_x/2, wall_yp + wall_t/2, wall_z])
            standing("screen-r");
}

module a_plain_walls() {
    // right column x2; face inward (-X)
    color("gainsboro") for (yy = [0, tile_y])
        translate([wall_yp + wall_t/2, yy, wall_z])
            rotate([0, 0, -90]) standing("plain");
}

module a_window_walls() {
    // left column x2; face inward (+X)
    color("lightgray") for (yy = [-tile_y, 0])
        translate([-(wall_yp + wall_t/2), yy, wall_z])
            rotate([0, 0, 90]) standing("window");
}

if (PART == "floor")            a_floor();
else if (PART == "stage")       a_stage();
else if (PART == "podium")      a_podium();
else if (PART == "robot")       a_robot();
else if (PART == "screen-l")    a_screen_l();
else if (PART == "screen-r")    a_screen_r();
else if (PART == "plain-walls")  a_plain_walls();
else if (PART == "window-walls") a_window_walls();
else {
    a_floor(); a_stage(); a_podium(); a_robot();
    a_screen_l(); a_screen_r(); a_plain_walls(); a_window_walls();
}
