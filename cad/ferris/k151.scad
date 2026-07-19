// ferris/k151.scad
// Official M5Stack K151 StackChan structure STLs (MIT, see cad/vendor/k151/),
// composed into one module: bottom-center at the origin, facing +Y.
//
// Ground-contact analysis (parsed from StackChan-Base.stl, 2026-07-19):
//   the FEET are integral to the Base part; the whole ground outline
//   (slab + feet) is FLAT at z=0 and spans exactly 48.0 x 56.0 - so the unit
//   sits flush in a rectangular pocket that clears 48x56. Assembled height
//   per official spec: 61.5 (shell top; the servo unit hides inside the shell).

K151_DIR = "../vendor/k151";   // relative to this file's directory

module k151() {
  rotate([0, 0, 180])   // face (screen opening / feet) toward +Y = the safety-bar side
  union() {
    // base plate incl. FEET at the front edge (bbox 82.7..130.7 / -352.5..-296.6 / -32.6..-21.5)
    color("#8a8a92")
        translate([-106.7, 324.55, 32.6])
            import(str(K151_DIR, "/StackChan-Base.stl"));
    // servo unit (rotating core, hidden inside the shell) - bbox 206.2../-343.6../-22.3..
    color("#6d6d75")
        translate([0, 0, 8])
            translate([-229.45, 320.6, 22.3])
                import(str(K151_DIR, "/StackChan-ServoBody.stl"));
    // main body shell (encloses the servo; top = official 61.5)
    color("#e8e8e8")
        translate([0, 0, 61.5 - 54.0])
            translate([-475.7, 328.65, 17.7])
                import(str(K151_DIR, "/StackChan-MainBody.stl"));
  }
}

k151();
