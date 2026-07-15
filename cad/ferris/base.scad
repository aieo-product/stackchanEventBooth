// ferris/base.scad
// Base board 250 x 175 x 15. Two identical boards join on the long (250) edge
// to give the 350 x 250 footprint. The join edge carries a self-complementary
// dovetail pair (tenon @ +50, mortise @ -50) so two identical prints mate when
// one is rotated 180 deg about the join-edge midpoint, plus M3 thumbscrew holes.
// Each board also has two tower-foot slots and a crank-shaft journal bracket.

include <../params.scad>;
use <../lib/dovetail.scad>;

// board centred in X, y from 0..base_y, join edge at y = base_y
join_y   = base_y;
foot_y   = base_y / 2;        // slot position (one tower per board)
brk_h    = 45;                // crank journal bracket height
brk_x    = 112;              // bracket wall position (stays inside x=125)

module base_board() {
    difference() {
        union() {
            translate([-base_x/2, 0, 0]) cube([base_x, base_y, base_t]);
            // join-edge dovetail tenon @ +50
            translate([50, join_y, 0]) dovetail_tenon(h = base_t);
            // crank-shaft journal bracket (one side; the shaft exits here to the crank)
            translate([brk_x - wall_frame, foot_y - crank_boss_d/2, 0])
                cube([8, crank_boss_d, brk_h]);
        }
        // join-edge dovetail mortise @ -50 (cut into -y)
        translate([-50, join_y, 0]) rotate([0, 0, 180]) dovetail_mortise(h = base_t);
        // two tower-foot slots
        for (sx = [-1, 1])
            translate([sx * 48, foot_y, base_t - base_slot_d + 0.01])
                translate([-base_slot_w/2, -base_slot_t/2, 0])
                    cube([base_slot_w, base_slot_t, base_slot_d]);
        // M3 thumbscrew holes across the seam (symmetric pair)
        for (sx = [-1, 1])
            translate([sx * 30, join_y + 1, base_t/2]) rotate([90, 0, 0])
                cylinder(d = m3_clear, h = 30);
        // crank shaft pass-through in the journal bracket (Ø8.5)
        translate([brk_x - 12, foot_y, brk_h - 8]) rotate([0, 90, 0])
            cylinder(d = crank_bearing_d, h = 16);
    }
}

base_board();
