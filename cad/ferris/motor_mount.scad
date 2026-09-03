// ferris/motor_mount.scad (v7, 2026-09-03 — automatic rotation)
// Parts for the JGY-370 worm-gear motor drive that replaces the hand crank.
//   PART="bracket" : U-box bracket. Tower plate (4 x M3 into the tower-upper-motor
//                    pilots) + 2 side walls + top wall + motor flange (4 x M3 into
//                    the gearbox's threaded holes). Open at the bottom: the 370 can
//                    hangs down there and a hex key reaches the flange screws.
//                    The coupling lives inside the box -> pinch guard for free.
//   PART="coupler" : printed rigid coupler Ø8 (wheel shaft) <-> Ø6 D (motor),
//                    fallback for the aluminium flexible coupling.
//   PART="plate"   : 4 mm shim plate with the same pattern (fine-tune standoff).
// Coordinates (bracket): shaft axis = Z (print axis), z=0 = tower outer face.
//   X across the wheel, +Y = up (world Z). Motor can hangs toward -Y.

include <../params.scad>;

PART = "bracket";

zf = motor_standoff;                 // flange OUTER face (gearbox sits here)
inner_h = mb_top - mb_bottom;        // 58: box inner height (Y)

module box_shell() {
    // tower plate
    translate([-mb_outer_w/2, mb_bottom - mb_wall_t, 0])
        cube([mb_outer_w, inner_h + 2*mb_wall_t, mb_plate_t]);
    // side walls
    for (sx = [-1, 1])
        translate([sx > 0 ? mb_inner_w/2 : -mb_outer_w/2, mb_bottom - mb_wall_t, 0])
            cube([mb_wall_t, inner_h + 2*mb_wall_t, zf]);
    // top wall (closes the box above the coupling)
    translate([-mb_outer_w/2, mb_top, 0])
        cube([mb_outer_w, mb_wall_t, zf]);
    // motor flange
    translate([-mb_outer_w/2, mb_bottom - mb_wall_t, zf - mb_flange_t])
        cube([mb_outer_w, inner_h + 2*mb_wall_t, mb_flange_t]);
    // 45° chamfer strips under the flange along both walls -> shorter bridge
    for (sx = [-1, 1])
        translate([sx * mb_inner_w/2, mb_bottom - mb_wall_t, zf - mb_flange_t])
            rotate([-90, 0, 0])
                linear_extrude(inner_h + 2*mb_wall_t)
                    polygon([[0, 0], [-sx * 6, 0], [0, 6]]);
}

module box_cuts() {
    // shaft bore through the tower plate (coupling starts 4+ mm outside it)
    translate([0, 0, -1]) cylinder(d = mb_shaft_clear_d, h = mb_plate_t + 2);
    // 4 x M3 clearance + counterbore for the tower screws (heads inside the box)
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * mb_tower_hole_x, sy * mb_tower_hole_z, -1]) {
            cylinder(d = m3_clear, h = mb_plate_t + 2, $fn = 24);
            translate([0, 0, mb_plate_t + 1]) cylinder(d = 6.5, h = 10, $fn = 24);
        }
    // motor boss / shaft through the flange
    translate([0, 0, zf - mb_flange_t - 1]) cylinder(d = mb_flange_bore_d, h = mb_flange_t + 2);
    // 4 x M3 through the flange into the gearbox (pattern 18 x 33, shaft 9 below the upper row)
    for (sx = [-1, 1])
        for (y = [motor_shaft_off - 6, motor_shaft_off - 6 - motor_hole_dz])   // +9 / -24
            translate([sx * motor_hole_dx/2, y, zf - mb_flange_t - 1])
                cylinder(d = motor_hole_d, h = mb_flange_t + 2, $fn = 24);
    // side windows: lighten + let a driver / the wires through
    for (sx = [-1, 1])
        translate([sx * (mb_inner_w/2 + mb_wall_t/2), (mb_top + mb_bottom)/2, zf/2 + 2])
            cube([mb_wall_t + 2, 26, zf - 2*mb_plate_t - 12], center = true);
}

module bracket() {
    difference() { box_shell(); box_cuts(); }
}

module coupler() {
    difference() {
        cylinder(d = pc_d, h = pc_len);
        // Ø8 side (bottom): blind round bore
        translate([0, 0, -1]) cylinder(d = pc_bore8, h = pc_depth + 1);
        // Ø6 D side (top): blind D bore
        translate([0, 0, pc_len - pc_depth])
            intersection() {
                cylinder(d = pc_bore6, h = pc_depth + 1);
                translate([-pc_bore6/2, -pc_bore6/2, 0])
                    cube([pc_bore6, pc_flat6, pc_depth + 1]);
            }
        // radial set-screw pilots (one per bore, 90° apart)
        translate([0, 0, pc_depth/2]) rotate([0, 90, 0]) cylinder(d = pc_set_d, h = pc_d, $fn = 20);
        translate([0, 0, pc_len - pc_depth/2]) rotate([-90, 0, 0]) cylinder(d = pc_set_d, h = pc_d, $fn = 20);
    }
}

module plate() {
    difference() {
        translate([-mb_outer_w/2, mb_bottom - mb_wall_t, 0])
            cube([mb_outer_w, inner_h + 2*mb_wall_t, 4]);
        translate([0, 0, -1]) cylinder(d = mb_flange_bore_d, h = 6);
        for (sx = [-1, 1])
            for (y = [motor_shaft_off - 6, motor_shaft_off - 6 - motor_hole_dz])
                translate([sx * motor_hole_dx/2, y, -1]) cylinder(d = motor_hole_d, h = 6, $fn = 24);
    }
}

if (PART == "bracket") bracket();
else if (PART == "coupler") coupler();
else if (PART == "plate") plate();
