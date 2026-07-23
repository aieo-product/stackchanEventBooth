// ferris/base_mini.scad (7/23 v2 - skeletal)
// Minimal foot pad, one per tower, print x2. "工"-shaped skeleton:
//   - two slot bosses (full 15 thick, take the tower foot tabs at +/-48)
//   - a connecting spine and two Y outrigger bars, only 6 thick
// Anti-tip footprint stays 140 x 90 while the volume drops ~60% vs the
// v1 slab (-> ~30-40 min per pad). Crank journal remains dropped.

include <../params.scad>;

boss_x  = 30;                  // slot boss size
boss_y  = 34;
pad_t   = base_t;              // 15: full slot depth
arm_t   = 6;                   // outrigger / spine thickness
arm_w   = 24;                  // outrigger width
pad_y   = 90;                  // anti-tip depth
spine_w = 20;

module base_mini() {
    difference() {
        union() {
            // slot bosses
            for (sx = [-1, 1])
                translate([sx * 48 - boss_x/2, -boss_y/2, 0])
                    cube([boss_x, boss_y, pad_t]);
            // spine between the bosses
            translate([-48, -spine_w/2, 0]) cube([96, spine_w, arm_t]);
            // Y outrigger bars through each boss
            for (sx = [-1, 1])
                translate([sx * 48 - arm_w/2, -pad_y/2, 0])
                    cube([arm_w, pad_y, arm_t]);
        }
        // tower-foot slots (same layout as base.scad)
        for (sx = [-1, 1])
            translate([sx * 48 - base_slot_w/2, -base_slot_t/2, pad_t - base_slot_d + 0.01])
                cube([base_slot_w, base_slot_t, base_slot_d]);
        // horizontal M3 retention holes through the boss walls
        for (sx = [-1, 1])
            translate([sx * 48, -boss_y/2 - 1, 8])
                rotate([-90, 0, 0]) cylinder(d = m3_clear, h = boss_y + 2, $fn = 24);
    }
}

base_mini();
