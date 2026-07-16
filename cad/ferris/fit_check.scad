// fit_check.scad
// Virtual fit check: official K151 StackChan STLs placed in the gondola.
// Not a printed part - review/render only.
//   K151_DIR must point to a directory containing StackChan-Base.stl and
//   StackChan-MainBody.stl (downloaded from m5stack/M5_Hardware GitHub).
// Render: openscad -D 'K151_DIR="/path/to/k151"' -o fit.png fit_check.scad

include <../params.scad>
use <gondola.scad>

K151_DIR = "/tmp/k151";   // override with -D

// gondola (as printed, floor bottom on z=0)
gondola();

// seat surface z: floor top minus pockets
seat_top     = gon_floor_t;                       // 6
pocket_floor = seat_top - gon_pocket_o_d - gon_pocket_i_d;  // 6-1.5-2.0 = 2.5

// --- official base STL, centred in the inner pocket --------------------
color("orange")
    translate([0, 0, pocket_floor])
        translate([-k151_base_x/2, -k151_base_y/2, 0])   // STL likely 0-origin
            import(str(K151_DIR, "/StackChan-Base.stl"));

// --- product envelope 54 x 70.5 x 61.5 (spec) as translucent proxy -----
color("SteelBlue", 0.35)
    translate([-54/2, -70.5/2, pocket_floor])
        cube([54, 70.5, 61.5]);
