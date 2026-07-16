// fit_test_kit.scad
// Thin fit-test slices for quick print-time checks (#18 retest).
// Geometry only - no durability. Each PART is a horizontal slice of the real
// model so every X-Y fit (dovetail, axle hole, K151 pocket, post clearance,
// J-slot) can be verified in a fraction of the print time.
//   PART = "rim"    -> rim segment z 0..6   (dovetail profile + axle hole + boss)
//   PART = "floor"  -> gondola  z 0..14     (K151 base pocket + rail/post stubs)
//   PART = "bridge" -> gondola  z 60..77    (J-slot on the Ø3 rod), re-grounded

include <../params.scad>
use <rim_segment.scad>
use <gondola.scad>

PART = "rim";
slab_rim   = 6;    // rim slice height
slab_floor = 14;   // gondola floor + stub height
bridge_z0  = 60;   // gondola bridge slice start

module slab(z0, z1) {
    translate([-500, -500, z0]) cube([1000, 1000, z1 - z0]);
}

if (PART == "rim")
    intersection() { rim_segment(); slab(0, slab_rim); }
else if (PART == "floor")
    intersection() { gondola(); slab(0, slab_floor); }
else if (PART == "bridge")
    translate([0, 0, -bridge_z0])          // re-ground the slice on the bed
        intersection() { gondola(); slab(bridge_z0, 100); }
