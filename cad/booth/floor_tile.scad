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

floor_tile();
