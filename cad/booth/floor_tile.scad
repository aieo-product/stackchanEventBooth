// booth/floor_tile.scad
// Classroom flooring tile 150 x 150 x 3. Top face carries a wood-plank relief
// (25 mm planks, 0.6 mm seams) that casts shadow lines without painting.
// Edges: dovetails on +X and +Y (male), mortises on -X and -Y (female), so
// identical tiles tile into a grid.

include <../params.scad>;
use <../lib/dovetail.scad>;

nplank   = tile_x / plank_w;    // 6
dt_off   = 40;                  // dovetail offset from centre on each edge
dt_h_t   = tile_t;             // dovetail spans full tile thickness

module planks() {
    // longitudinal seams (run in Y)
    for (i = [1 : nplank - 1])
        translate([-tile_x/2 + i * plank_w - groove_w/2, -tile_y/2 - 1, tile_t - groove_d])
            cube([groove_w, tile_y + 2, groove_d + 0.1]);
    // staggered plank-end seams (run in X, one per plank column)
    for (i = [0 : nplank - 1])
        translate([-tile_x/2 + i * plank_w, (i % 2 == 0 ? 25 : -25) - groove_w/2, tile_t - groove_d])
            cube([plank_w, groove_w, groove_d + 0.1]);
}

variant = "plain";            // "plain" | "wall" (+Y curb) | "corner" (+Y and -X curbs)

module floor_tile() {
    difference() {
        union() {
            translate([-tile_x/2, -tile_y/2, 0]) cube([tile_x, tile_y, tile_t]);
            // male dovetails on +X and +Y edges
            for (o = [-dt_off, dt_off]) {
                translate([o, tile_y/2, 0]) dovetail_tenon(h = dt_h_t);
                translate([tile_x/2, o, 0]) rotate([0, 0, -90]) dovetail_tenon(h = dt_h_t);
            }
        }
        planks();
        // female dovetails on -X and -Y edges
        for (o = [-dt_off, dt_off]) {
            translate([o, -tile_y/2, 0]) rotate([0, 0, 180]) dovetail_mortise(h = dt_h_t);
            translate([-tile_x/2, o, 0]) rotate([0, 0, 90]) dovetail_mortise(h = dt_h_t);
        }
    }
}

// 7/23 LT-diorama: wall panels plug straight into the floor (no stands).
// A raised socket curb on the +Y edge takes the panel's two bottom tabs
// (20 x 5 at +/-40) -> ~12 mm engagement instead of the bare 3 mm tile.
module curb_y() {
    // curb + two tab slots on the +Y edge (panel rests on the curb top at
    // z=13; tabs reach z=1, just above the table)
    difference() {
        translate([-tile_x/2, tile_y/2 - sock_w, 0]) cube([tile_x, sock_w, sock_h]);
        for (o = [-40, 40])
            translate([o - (wall_tab_w + sock_play)/2,
                       tile_y/2 - sock_w/2 - (wall_t + sock_play)/2, -1])
                cube([wall_tab_w + sock_play, wall_t + sock_play, sock_h + 2]);
    }
}

module wall_socket_tile() {
    union() { floor_tile(); curb_y(); }
}

module corner_socket_tile() {
    // curbs on +Y AND -X (the two back corner tiles hold two walls each;
    // the -90 deg rotated copy serves the opposite corner)
    union() {
        floor_tile();
        curb_y();
        rotate([0, 0, 90]) curb_y();    // -X edge
    }
}

if (variant == "wall")        wall_socket_tile();
else if (variant == "corner") corner_socket_tile();
else                          floor_tile();
