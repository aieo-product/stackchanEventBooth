// booth/assembly.scad
// Places the LT-meetup photo-booth parts in their assembled position for the
// browser assembly viewer (three.js), same pipeline as ferris/assembly.scad.
//   - origin = centre of the 2x2 floor-tile area, z=0 on the table
//   - audience side = -Y, screen wall at the back (+Y), window wall left (-X)
// 7/23 rev2: walls plug DIRECTLY into socket-curb floor tiles (no stands).
//   back-left tile  = socket -> screen wall
//   back-right tile = socket -> plain wall
//   front-left tile = socket rotated -90 -> window wall on the -X edge
//   front-right     = plain tile
// Export groups (Makefile `viewer-models-booth`, docs/public/models/booth/):
//   floor, stage, podium, robot, screen-wall, plain-wall, window-wall

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
        translate([-tc,  tc, 0]) wall_socket_tile();                      // back-left  (screen L)
        translate([ tc,  tc, 0]) wall_socket_tile();                      // back-right (screen R)
        translate([-tc, -tc, 0]) rotate([0, 0, 90]) wall_socket_tile();   // front-left, curb on -X (window)
        translate([ tc, -tc, 0]) rotate([0, 0, -90]) wall_socket_tile();  // front-right, curb on +X (plain)
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

module a_plain_wall() {
    // right side (front-right tile, curb on +X); faces inward (-X)
    color("gainsboro")
        translate([wall_yp + wall_t/2, 0, wall_z])
            rotate([0, 0, -90]) standing("plain");
}

module a_window_wall() {
    // front-left tile, curb on its -X edge -> wall plane along Y
    color("lightgray")
        translate([-(wall_yp + wall_t/2), -tile_y, wall_z])
            rotate([0, 0, 90]) standing("window");
}

if (PART == "floor")            a_floor();
else if (PART == "stage")       a_stage();
else if (PART == "podium")      a_podium();
else if (PART == "robot")       a_robot();
else if (PART == "screen-l")    a_screen_l();
else if (PART == "screen-r")    a_screen_r();
else if (PART == "plain-wall")  a_plain_wall();
else if (PART == "window-wall") a_window_wall();
else {
    a_floor(); a_stage(); a_podium(); a_robot();
    a_screen_l(); a_screen_r(); a_plain_wall(); a_window_wall();
}
