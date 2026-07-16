// ferris/assembly.scad
// Places every ferris-wheel part in its assembled position for the browser
// assembly viewer (three.js). Coordinate system:
//   - origin = centre of the base underside (z=0 on the table)
//   - wheel axle runs along Y at height z = shaft_z, in front of the camera
//   - PART selects a single export group; PART="all" renders the whole wheel.
// Export groups (see Makefile `viewer-models`, docs/public/models/ferris/):
//   base, tower-front, tower-rear, shaft, hubs, rim-front, rim-rear,
//   diffusers, axles, gondola-1..4, crank
//
// The STL of each group is written already positioned in world coordinates, so
// the viewer just loads it at the origin. `explode` vectors live in manifest.json.

include <../params.scad>;
use <rim_segment.scad>;
use <diffuser.scad>;
use <hub.scad>;
use <gondola.scad>;
use <tower.scad>;
use <crank.scad>;
use <axle.scad>;
use <base.scad>;

PART = "all";

// --- assembled geometry constants ------------------------------------------
apex_zc   = tower_total_h - 22;          // 258: bearing centre in tower-local z
base_top  = base_t;                      // 15: top of the base plate
shaft_z   = base_top + apex_zc;           // 273: wheel axle height
disc_in   = axle_rim_gap / 2;            // 45: inner face of each rim disc
tower_y   = disc_in + rim_depth + 33;     // 98: outer tower so inner face clears the disc
gon_ang   = [45, 135, 225, 315];         // gondola / axle angular positions

// --- part groups -----------------------------------------------------------
module a_base() {
    color("silver") {
        translate([0, -base_y, 0]) base_board();
        translate([0,  base_y, 0]) rotate([0, 0, 180]) base_board();
    }
}

module tower_full() {
    difference() {
        union() { frame_solid(); foot_tabs(); }
        bearing_features();
        thumb_holes();
    }
}

module a_tower_front() {
    color("dimgray")
        translate([0, tower_y, base_top]) rotate([0, 0, 180]) tower_full();
}
module a_tower_rear() {
    color("dimgray")
        translate([0, -tower_y, base_top]) tower_full();
}

module a_shaft() {
    color("gainsboro")
        translate([0, -tower_y - 8, shaft_z]) rotate([-90, 0, 0])
            cylinder(d = shaft_d, h = 2 * tower_y + 40, $fn = 32);
}

module one_disc() {          // full ring in local XY, depth 0..rim_depth in +z
    for (k = [0 : 3]) rotate([0, 0, k * 90]) rim_segment();
}
module a_rim_front() {
    color("ivory")
        translate([0, disc_in, shaft_z]) rotate([-90, 0, 0]) one_disc();
}
module a_rim_rear() {
    color("ivory")
        translate([0, -disc_in, shaft_z]) rotate([90, 0, 0]) one_disc();
}

module one_diffuser_ring() { for (k = [0 : 3]) rotate([0, 0, k * 90]) diffuser(); }
module a_diffusers() {
    color("palegreen") {
        translate([0, disc_in, shaft_z]) rotate([-90, 0, 0]) one_diffuser_ring();
        translate([0, -disc_in, shaft_z]) rotate([90, 0, 0]) one_diffuser_ring();
    }
}

module a_hubs() {
    color("slategray") {
        translate([0, disc_in - 3, shaft_z]) rotate([-90, 0, 0]) hub();
        translate([0, -disc_in + 3, shaft_z]) rotate([90, 0, 0]) hub();
    }
}

module a_axles() {
    color("gainsboro")
        for (a = gon_ang)
            translate([gon_axle_r * cos(a), -(tower_y - 8), shaft_z + gon_axle_r * sin(a) - (gon_axle_d/2 - axle_flat)])
                rotate([0, 0, 90]) axle();   // new lying-flat model: +X -> +Y, centreline re-zeroed
}

gon_colors = ["lightpink", "khaki", "lightskyblue", "white"];
module a_gondola(i) {
    a = gon_ang[i];
    color(gon_colors[i])
        translate([gon_axle_r * cos(a), 0, shaft_z + gon_axle_r * sin(a) - gon_pivot_z])
            gondola();
}

module a_crank() {
    color("gold")
        translate([0, tower_y + 14, shaft_z]) rotate([-90, 0, 0]) crank_body();
}

// --- dispatch --------------------------------------------------------------
if (PART == "all") {
    a_base(); a_tower_front(); a_tower_rear(); a_shaft(); a_hubs();
    a_rim_front(); a_rim_rear(); a_diffusers(); a_axles();
    for (i = [0:3]) a_gondola(i);
    a_crank();
}
else if (PART == "base")          a_base();
else if (PART == "tower-front")   a_tower_front();
else if (PART == "tower-rear")    a_tower_rear();
else if (PART == "shaft")         a_shaft();
else if (PART == "hubs")          a_hubs();
else if (PART == "rim-front")     a_rim_front();
else if (PART == "rim-rear")      a_rim_rear();
else if (PART == "diffusers")     a_diffusers();
else if (PART == "axles")         a_axles();
else if (PART == "crank")         a_crank();
else if (PART == "gondola-1")     a_gondola(0);
else if (PART == "gondola-2")     a_gondola(1);
else if (PART == "gondola-3")     a_gondola(2);
else if (PART == "gondola-4")     a_gondola(3);
