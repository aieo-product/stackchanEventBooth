// ferris/axle.scad
// PRINTED Ø6 swing axle + push cap (replaces the Ø3 metal rod; the user has no
// rod-cutting tools). One axle per gondola: the flange head seats against the
// outer face of one rim disc, the shaft runs through both rim holes (Ø6.4) and
// the gondola J-slot, and a push cap (0.2 mm interference) retains the far end.
//
// Load check (Ø6 PLA, simply-supported, span = rim gap 80 mm, load ~3 N =
// gondola 74x84 chair + K151 187 g ~= 290 g):
//   I = pi*d^4/64 = pi*6^4/64        = 63.6 mm^4
//   M = P*L/4 = 3*80/4               = 60 N*mm
//   sigma = M*(d/2)/I = 60*3/63.6    ~= 2.8 MPa   (PLA yield ~50 MPa -> FoS ~18)
//   deflection = P*L^3/(48*E*I), E~3500 MPa = 3*80^3/(48*3500*63.6) ~= 0.14 mm
// -> ample margin; a printed axle is fine at these loads.
//
// Print orientation: lay flat in the slicer (rotate 90 deg) with a brim, or
// print vertical head-down. Modelled vertical (head on the bed) so the STL and
// check_dims ground check are clean.

include <../params.scad>;

module axle() {
    // flange head (bottom) + Ø6 shaft (up)
    cylinder(d = axle_head_d, h = axle_head_t, $fn = 48);
    translate([0, 0, axle_head_t - 0.01])
        cylinder(d = gon_axle_d, h = axle_shaft_len + 0.01, $fn = 40);
}

module axle_cap() {
    // push cap: Ø10 x 6 with a Ø5.8 blind bore (0.2 mm interference on the shaft)
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
    translate([i * 18, 0, 0]) axle();
for (j = [0 : n_cap - 1])
    translate([j * 16, 30, 0]) axle_cap();
