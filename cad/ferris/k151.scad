// ferris/k151.scad
// Official M5Stack K151 StackChan structure STLs (MIT, see cad/vendor/k151/),
// composed into one module: bottom-center at the origin, facing +Y.
// Base 48.0 x 55.9 x 11.1, MainBody 54.0 x 46.7 x 54.0; the body overlaps the
// base joint so the assembled height matches the official 61.5 mm spec.

K151_DIR = "../vendor/k151";   // relative to this file's directory

module k151() {
  rotate([0, 0, 180])   // face (screen opening) toward +Y = the safety-bar side
  union() {
    // base plate: recentre (bbox 82.7..130.7 / -352.5..-296.6 / -32.6..-21.5)
    color("#c8c8c8")
        translate([-106.7, 324.55, 32.6])
            import(str(K151_DIR, "/StackChan-Base.stl"));
    // main body: recentre (bbox 448.7..502.7 / -352.0..-305.3 / -17.7..36.3)
    // seat it so the assembled top lands at the official 61.5 mm
    color("#e8e8e8")
        translate([0, 0, 61.5 - 54.0])
            translate([-475.7, 328.65, 17.7])
                import(str(K151_DIR, "/StackChan-MainBody.stl"));
  }
}

k151();
