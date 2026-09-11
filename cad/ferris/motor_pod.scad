// ferris/motor_pod.scad (v7.1 embedded variant, 2026-09-10)
//   PART="pod"   : closed motor housing. Tower-side wall (4 x M3 into the tower
//                  pilots, counterbored from inside, Ø12 shaft hole), side walls,
//                  top, outer wall with the JGY-370 flange pattern (screws from
//                  outside into the gearbox). Bottom is OPEN (motor goes in from
//                  below, can hangs into the lower part) and closed by the cover.
//   PART="cover" : slide-in bottom cover (grooves in the side walls).
// Print: pod standing on its TOP wall (open bottom up) -> no bridges.
// Model coords: shaft axis = Y (tower face at y=0, outward = +y), Z up.

include <../params.scad>;

PART = "pod";

in_w = pod_in_w;  ow = in_w + 2*mpod_wall;       // 46
in_h = pod_top - pod_bottom;                    // 93
z0 = pod_bottom - 0;                            // open bottom at z = pod_bottom
z1 = pod_top + mpod_wall;

module pod_body() {
    difference() {
        translate([-ow/2, 0, z0]) cube([ow, pod_len, z1 - z0]);
        // cavity (open at the bottom)
        translate([-in_w/2, mpod_wall, z0 - 1]) cube([in_w, pod_len - 2*mpod_wall, pod_top - z0 + 1]);
        // tower-side wall: shaft hole + 4 x M3 with counterbore from inside
        translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = mb_shaft_clear_d, h = mpod_wall + 2, $fn = 48);
        for (sx = [-1, 1], sz = [-1, 1])
            translate([sx * mb_tower_hole_x, -1, sz * mb_tower_hole_z]) rotate([-90, 0, 0]) {
                cylinder(d = m3_clear, h = mpod_wall + 2, $fn = 24);
                translate([0, 0, mpod_wall + 1]) cylinder(d = 6.5, h = 6, $fn = 24);
            }
        // outer wall: gearbox flange pattern (18 x 33, shaft 9 below the upper row) + boss clearance
        translate([0, pod_len - mpod_wall - 1, 0]) rotate([-90, 0, 0]) cylinder(d = mb_flange_bore_d, h = mpod_wall + 2, $fn = 48);
        for (sx = [-1, 1])
            for (z = [motor_shaft_off - 6, motor_shaft_off - 6 - motor_hole_dz])
                translate([sx * motor_hole_dx/2, pod_len - mpod_wall - 1, z]) rotate([-90, 0, 0]) cylinder(d = motor_hole_d, h = mpod_wall + 2, $fn = 24);
        // vent slots on both side walls (lower part, beside the can)
        for (sx = [-1, 1], k = [0 : 4])
            translate([sx * (in_w/2 + mpod_wall/2), pod_len/2 - 20 + k * 8, pod_bottom + 30]) cube([mpod_wall + 2, pod_vent_w, 24], center = true);
        // cover grooves in the side walls, just above the open bottom
        for (sx = [-1, 1])
            translate([sx * (in_w/2 + 1), mpod_wall - 1, z0 + 3]) 
                translate([-1 - pod_cover_slot, 0, 0]) cube([2 + 2*pod_cover_slot, pod_len - 2*mpod_wall + 2, pod_cover_t + 2*pod_cover_slot]);
        // cover retaining screw (M3 self-tap through the outer wall into the cover edge)
        translate([0, pod_len - mpod_wall - 1, z0 + 3 + pod_cover_t/2]) rotate([-90, 0, 0]) cylinder(d = m3_thread, h = mpod_wall + 2, $fn = 20);
    }
}

module pod() {
    // print orientation: standing on the top wall -> rotate so that +z (top) becomes -z... i.e. flip
    translate([0, 0, z1]) mirror([0, 0, 1]) pod_body();
}

module cover() {
    // plate that slides into the grooves; a slot for the motor cable and a notch
    difference() {
        cube([in_w + 2, pod_len - 2*mpod_wall - 0.5, pod_cover_t], center = false);
        translate([in_w/2 + 1 - 6, 6, -1]) cube([12, 6, pod_cover_t + 2]);          // cable slot
    }
}

if (PART == "pod") pod();
else if (PART == "cover") cover();
