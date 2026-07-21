// ferris/swing_test_rig.scad
// Pre-hardware bench rig (test 7/17, before the metal shaft 7/18 & 608 bearings
// 7/20-22). Verifies the whole hanging chain: dummy shaft -> mini rim discs ->
// printed axle -> gondola, and that the gondola stays level while the wheel is
// turned. Plain bushings (friction is fine here). Tool-free (push-fit only) and
// uses the SAME axle-hole diameters as production so the fit is representative.
//
// PART selects a single export; PART="all" is the assembled review render.
//   disc   -> mini_disc  (print x2)      shaft -> dummy_shaft (x1)
//   stand  -> stand      (print x2)      base  -> base        (x1)
// Reuse ferris/axle.stl (axle + cap) and ferris/gondola.stl as-is.
//
// Print estimate (PLA 0.2 mm, ~15% infill), all support-free, each <=150 mm:
//   mini_disc  x2  ~0.8 h ea = 1.6 h   (lightened)
//   dummy_shaft x1 ~0.5 h
//   stand      x2  ~0.7 h ea = 1.4 h
//   base       x1  ~0.9 h
//   -> rig total ~4.4 h  (+ reuse existing axle plate ~0.6 h and one gondola ~1.8 h
//      already printed) -> well within the 5 h budget for new rig parts.

include <../params.scad>;
use <gondola.scad>;
use <axle.scad>;

PART = "all";

foot_tab_h = rig_foot_tab_h;

// D-shaped cutter: a circle clipped to y >= -flat (the flat becomes the D face).
module d_cut(bore, flat, h) {
    intersection() {
        cylinder(d = bore, h = h, $fn = 48);
        translate([-bore, -flat, -0.01]) cube([2 * bore, bore + flat, h + 0.02]);
    }
}

// --- 1. mini disc (x2) -----------------------------------------------------
module mini_disc() {
    difference() {
        cylinder(d = rig_disc_d, h = rig_disc_t, $fn = 96);
        // centre D-hole: mates the dummy-shaft D-flat so the disc co-rotates
        translate([0, 0, -0.01]) d_cut(rig_bore_d, rig_bore_flat, rig_disc_t + 0.02);
        // gondola axle hole, same Ø as production
        translate([rig_axle_r, 0, -0.01])
            cylinder(d = gon_axle_hole_d, h = rig_disc_t + 0.02, $fn = 32);
        // lightening holes (kept clear of the axle hole)
        for (a = [30 : 60 : 359])
            translate([28 * cos(a), 28 * sin(a), -0.01])
                cylinder(d = 13, h = rig_disc_t + 0.02, $fn = 32);
    }
}

// --- 2. dummy shaft (x1) : Ø8 D-section, printed flat (D-flat on the bed) ---
module dummy_shaft() {
    intersection() {
        translate([0, 0, rig_shaft_flat]) rotate([0, 90, 0])
            cylinder(d = rig_shaft_d, h = rig_shaft_len, $fn = 48);
        translate([-1, -50, 0]) cube([rig_shaft_len + 2, 100, 100]);   // keep z>=0
    }
}

// --- 3. stand (x2) : A-frame, plain top bushing with a drop-in U-slot ------
// Modelled standing (feet + tabs at the bottom, grounded). A-frame narrows
// upward so it prints support-free; may also be laid flat on a face.
module stand_raw() {
    apex_z = rig_bush_z;
    difference() {
        union() {
            // two legs (foot -> apex)
            for (sx = [-1, 1])
                hull() {
                    translate([sx * rig_stand_span - 8, 0, 0]) cube([16, rig_stand_t, 14]);
                    translate([-13, 0, apex_z - 16]) cube([26, rig_stand_t, 16]);
                }
            // base crossbar
            translate([-rig_stand_span - 8, 0, 0]) cube([2 * rig_stand_span + 16, rig_stand_t, 12]);
            // apex bushing block around the closed bore
            translate([-16, 0, apex_z - 16]) cube([32, rig_stand_t, 16 + rig_bush_d/2 + 5]);
            // foot tabs (down into the base)
            for (sx = [-1, 1])
                translate([sx * rig_stand_span - rig_foot_tab_w/2, 0, -foot_tab_h])
                    cube([rig_foot_tab_w, rig_stand_t, foot_tab_h + 1]);
        }
        // plain CLOSED bushing bore (v3, 7/21: hooks/slots are less reliable
        // than a full hole - the shaft is simply threaded through both stands
        // and the discs at assembly). Teardrop top = support-free print.
        translate([0, rig_stand_t + 1, apex_z]) rotate([90, 0, 0])
            linear_extrude(rig_stand_t + 2)
                union() {
                    circle(d = rig_bush_d, $fn = 40);
                    polygon([[-rig_bush_d/2 + 0.6, rig_bush_d/2 - 1.5],
                             [ rig_bush_d/2 - 0.6, rig_bush_d/2 - 1.5],
                             [ 0, rig_bush_d/2 + 2.0]]);
                }
    }
}
module stand() { translate([0, 0, foot_tab_h]) stand_raw(); }   // ground the tabs to z=0

// --- 4. base (x1) : slots for the two stands -------------------------------
module base() {
    difference() {
        translate([-rig_base_x/2, -rig_base_y/2, 0]) cube([rig_base_x, rig_base_y, rig_base_t]);
        // two slots per stand (at +/-span, at each stand Y position)
        for (sy = [-1, 1], sx = [-1, 1])
            translate([sx * rig_stand_span, sy * rig_stand_y, -0.01])
                translate([-(rig_foot_tab_w + tol)/2, -(rig_stand_t + tol)/2, 0])
                    cube([rig_foot_tab_w + tol, rig_stand_t + tol, rig_base_t + 0.02]);
    }
}

// --- assembled review ------------------------------------------------------
module assembled() {
    sz = rig_bush_z;                       // shaft height
    color("silver") base();
    // two stands (A-frame plane = X-Z; thickness along Y), bushings on the shaft
    for (sy = [-1, 1])
        color("dimgray") translate([0, sy * rig_stand_y - rig_stand_t/2, 0]) stand();
    // dummy shaft along Y through both bushings
    color("gainsboro")
        translate([0, -rig_shaft_len/2, sz - rig_shaft_flat]) rotate([0, 0, 90]) dummy_shaft();
    // two mini discs in the X-Z plane, inner faces +/- gap/2
    color("ivory") translate([0,  rig_gap/2, sz]) rotate([-90, 0, 0]) mini_disc();
    color("ivory") translate([0, -rig_gap/2, sz]) rotate([ 90, 0, 0]) mini_disc();
    // printed axle through the r=40 holes (3-o'clock) + gondola hung below it
    color("gold")
        translate([rig_axle_r, -rig_shaft_len/2 + 4, sz]) rotate([-90, 0, 0]) axle();
    color("lightpink")
        translate([rig_axle_r, 0, sz - gon_pivot_z]) gondola();
}

// --- dispatch --------------------------------------------------------------
if (PART == "disc")       mini_disc();
else if (PART == "shaft") dummy_shaft();
else if (PART == "stand") stand();
else if (PART == "bearing") {
    // bearing-only test coupon: the stand apex (last ~35 mm) re-grounded on a pad
    translate([0, 0, -(rig_bush_z + foot_tab_h - 30)])
        intersection() {
            stand();
            translate([-500, -500, rig_bush_z + foot_tab_h - 30]) cube([1000, 1000, 200]);
        }
    translate([-16, -10, 0]) cube([32, 28, 2]);   // stabilising pad
}
else if (PART == "base")  base();
else                      assembled();
