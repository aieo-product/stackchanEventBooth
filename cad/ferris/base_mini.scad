// ferris/base_mini.scad (7/23)
// Minimal foot pad replacing the full 250x183 base boards - one pad per
// tower, print x2. Keeps the same slot geometry (tower foot tabs at +/-48,
// thumbscrew holes) but shrinks the footprint to ~1/3 -> big print-time cut.
// The crank-side journal bracket is dropped (shaft rides in the two tower
// bores; the hand crank is fine cantilevered).

include <../params.scad>;

pad_x   = 140;                 // spans both feet (centres +/-48, foot 26 wide)
pad_y   = 90;                  // anti-tip depth (tower frame is only 30 deep)
pad_t   = base_t;              // 15: full slot depth like the original
cham    = 6;                   // top edge chamfer, saves a little material

module base_mini() {
    difference() {
        // chamfered slab
        hull() {
            translate([-pad_x/2, -pad_y/2, 0]) cube([pad_x, pad_y, pad_t - cham]);
            translate([-pad_x/2 + cham, -pad_y/2 + cham, 0])
                cube([pad_x - 2*cham, pad_y - 2*cham, pad_t]);
        }
        // two tower-foot slots (same layout as base.scad)
        for (sx = [-1, 1])
            translate([sx * 48 - base_slot_w/2, -base_slot_t/2, pad_t - base_slot_d + 0.01])
                cube([base_slot_w, base_slot_t, base_slot_d]);
        // horizontal M3 thumbscrew holes through the slot walls (tower foot
        // thumb holes sit 8 up from the tab bottom -> z = pad_t - 15 + 8)
        for (sx = [-1, 1])
            translate([sx * 48, -pad_y/2 - 1, pad_t - foot_tab_h + 8])
                rotate([-90, 0, 0]) cylinder(d = m3_clear, h = pad_y + 2, $fn = 24);
    }
}

base_mini();
