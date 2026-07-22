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
use <hub.scad>
use <crank.scad>
use <tower.scad>
use <base.scad>

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
else if (PART == "hubcore")
    // hub centre core: full-height cylinder around the bore + both set-screw bosses
    intersection() {
        hub();
        union() {
            cylinder(d = 34, h = 100);
            translate([-50, -8, 0]) cube([100, 16, 100]);   // keep the radial bosses
        }
    }
else if (PART == "crankboss")
    // crank hub + a 20 mm arm stub (tests the Ø8.2 shaft fit + M3 set screw)
    intersection() {
        crank_body();
        union() {
            cylinder(d = crank_hub_d + 10, h = 100);
            translate([-5, -crank_arm_w/2 - 1, -1]) cube([25, crank_arm_w + 2, 20]);
        }
    }
// --- 7/22 pre-production joint checks (tower/base/spoke-hub) ---------------
else if (PART == "towerfoot")
    // bottom 45 mm of the lower tower: both foot tabs + thumbscrew holes.
    // Mates with PART="baseslot" to verify the +/-48 slot spacing and tab fit.
    intersection() { tower("lower"); slab(0, 45); }
else if (PART == "baseslot")
    // strip of the base board around both tower-foot slots (full thickness)
    intersection() {
        base_board();
        translate([-80, 62, -1]) cube([160, 50, 30]);
    }
else if (PART == "splicelower")
    // 30 mm below the split + male dowels + M3 splice holes (re-grounded)
    translate([0, 0, -120])
        intersection() { tower("lower"); slab(120, 170); }
else if (PART == "spliceupper")
    // female sockets + M3 splice holes; tower("upper") is already grounded
    // on its split face
    intersection() { tower("upper"); slab(0, 45); }
else if (PART == "spokehub")
    // hub wedge holding two spoke pilot holes 45 deg apart (full 25 mm depth
    // -> real self-tap test). Mates with PART="spokepad" + M3x25.
    intersection() {
        hub();
        rotate([0, 0, 45]) translate([16, -26, -1]) cube([32, 52, 30]);
    }
else if (PART == "spokepad")
    // inner ends of both spokes of one rim segment: two Ø14 pads with M3
    // clearance holes, 45 deg apart (same bolt circle as the hub)
    intersection() { rim_segment(); cylinder(r = 48, h = 100); }
