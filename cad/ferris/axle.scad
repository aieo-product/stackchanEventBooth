// ferris/axle.scad
// PRINTED Ø6 swing axle + push cap (replaces the Ø3 metal rod; the user has no
// rod-cutting tools). One axle per gondola: the head seats against the outer
// face of one rim disc, the shaft runs through both rim holes (Ø6.4) and the
// gondola J-slot (Ø6.5), and a push cap (0.2 mm interference) retains the far end.
//
// Load check (Ø6 PLA, simply-supported, span = rim gap 90 mm, static load
// ~2.8 N = gondola chair + K151 187 g ~= 290 g; x2 dynamic factor for cranking):
//   Z = pi*d^3/32                       = 21.2 mm^3
//   M(static) = P*L/4 = 2.8*90/4        = 63 N*mm   -> sigma ~= 3.0 MPa
//   M(dynamic x2)                        = 126 N*mm  -> sigma ~= 5.9 MPa
//   PLA flexural strength (along layers) ~80 MPa    -> FoS 13 (dynamic) / 27 (static)
//   deflection = P*L^3/(48*E*I), E~3500 = 2.8*90^3/(48*3500*63.6) ~= 0.19 mm
//   creep: 3 MPa sustained for a 4-6 h event is far below the ~10 MPa concern zone.
//
// PRINT ORIENTATION = AS MODELLED (lying flat, D-flat face down, no support):
// layers then run ALONG the axle, the strongest direction for bending. The
// gondola hangs from the TOP of the axle, so the bottom D-flat (3 mm wide chord)
// never touches the bearing surface. Do NOT print this standing (interlayer
// bending strength would halve the margin).

include <../params.scad>;

axle_ctr  = gon_axle_d/2 - axle_flat;   // shaft centreline height above the bed (flat chord ~3 mm)

module axle() {
    // shaft along +X, D-flat on the bed; 4 mm lead-in taper at the free end
    // (7/19 test: square tips jammed in the printed holes)
    intersection() {
        translate([0, 0, axle_ctr])
            rotate([0, 90, 0])
                union() {
                    cylinder(d = gon_axle_d, h = axle_shaft_len - 4, $fn = 48);
                    translate([0, 0, axle_shaft_len - 4])
                        cylinder(d1 = gon_axle_d, d2 = 4.5, h = 4, $fn = 48);
                }
        translate([-1, -gon_axle_d, 0])
            cube([axle_shaft_len + axle_head_t + 2, gon_axle_d * 2, gon_axle_d]);
    }
    // square head with a 45-deg roof (printable lying, no support)
    head_w = axle_head_d;        // 10 wide (Y)
    head_h = axle_head_d - 2;    // 8 tall (Z), chamfered top
    translate([-axle_head_t, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(axle_head_t)
                polygon([[-head_w/2, 0], [head_w/2, 0],
                         [head_w/2, head_h - 3], [0, head_h],
                         [-head_w/2, head_h - 3]]);
}

module axle_cap() {
    // push cap: Ø10 x 6 with a Ø5.8 blind bore (0.2 mm interference on the
    // round flanks of the shaft). Printed standing (short part, no issue).
    difference() {
        cylinder(d = axle_cap_d, h = axle_cap_h, $fn = 48);
        translate([0, 0, -0.01])
            cylinder(d = axle_cap_bore, h = axle_cap_h - 1, $fn = 40);
    }
}

// --- single print plate: axles + caps + spares -----------------------------
n_axle = axle_count + axle_spares;   // 5
n_cap  = axle_count + cap_spares;    // 6

for (i = [0 : n_axle - 1])
    translate([0, i * 14, 0]) axle();
for (j = [0 : n_cap - 1])
    translate([j * 16, -24, 0]) axle_cap();
