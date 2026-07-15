// ferris/rim_segment.scad
// Quarter (90 deg) rim arc with integrated spokes, outer LED groove,
// end dovetails and tangential M3 insert bosses.
// 8 of these make the two discs (4 per disc). All segments are identical;
// segment B = segment A rotated +90 deg, so the tenon on the 90 deg end mates
// with the mortise on the next segment's 0 deg end.

include <../params.scad>;
use <../lib/dovetail.scad>;

dt_h = 12;              // dovetail height (z), centred in the 20 mm band
dt_z = (rim_depth - dt_h) / 2;   // = 4
boss_side = 8;         // tangential + radial size of the joint boss
boss_z = 12;
boss_r_out = rim_inner_r;        // boss hangs inward from the inner rim face
boss_r_in  = rim_inner_r - boss_side;
boss_hole_r = (boss_r_out + boss_r_in) / 2;   // radius at which the bolt runs

module spoke() {
    // radial beam from the mount pad out to the inner rim, plus a bolt pad
    beam_r0 = spoke_mount_r - 2;
    beam_r1 = rim_inner_r + 2;   // overlap into rim for a clean union
    difference() {
        union() {
            translate([(beam_r0 + beam_r1)/2, 0, rim_depth/2])
                cube([beam_r1 - beam_r0, spoke_width, spoke_depth], center = true);
            translate([spoke_mount_r, 0, rim_depth/2])
                cylinder(d = spoke_pad_d, h = spoke_depth, center = true);
        }
        // M3 clearance to bolt onto the hub face
        translate([spoke_mount_r, 0, -1])
            cylinder(d = m3_clear, h = rim_depth + 2);
    }
}

module joint_boss(hole_d) {
    // block hanging inward from the inner rim, with a tangential bolt hole.
    // Modelled at the 0 deg end (face on the x-z plane, y=0), protruding +y.
    difference() {
        translate([boss_r_in, 0, (rim_depth - boss_z)/2])
            cube([boss_side, boss_side, boss_z]);
        // tangential hole along +y at radius boss_hole_r, mid height
        translate([boss_hole_r, -0.1, rim_depth/2])
            rotate([-90, 0, 0])
                cylinder(d = hole_d, h = boss_side + 0.2);
    }
}

module rim_segment() {
    difference() {
        union() {
            // --- annular band, first-quadrant 90 deg wedge ---
            intersection() {
                linear_extrude(rim_depth)
                    difference() { circle(rim_outer_r); circle(rim_inner_r); }
                translate([0, 0, -1])
                    cube([rim_outer_r + 5, rim_outer_r + 5, rim_depth + 2]);
            }
            // --- spokes at 22.5 and 67.5 deg ---
            rotate([0, 0, 22.5]) spoke();
            rotate([0, 0, 67.5]) spoke();
            // --- dovetail tenon on the 90 deg end (protrudes -x, tip wider) ---
            translate([0, rim_outer_r - rim_radial_w/2, dt_z])
                rotate([0, 0, 90])
                    dovetail_tenon(h = dt_h);
            // --- insert boss on 0 deg end, clearance-lug on 90 deg end ---
            joint_boss(m3_insert);                       // 0 deg end (insert)
            mirror([1, -1, 0]) joint_boss(m3_clear);     // 90 deg end (clearance)
        }
        // --- LED groove on the outer periphery ---
        translate([0, 0, (rim_depth - led_groove_w)/2])
            linear_extrude(led_groove_w)
                difference() {
                    circle(rim_outer_r + 5);
                    circle(rim_outer_r - led_groove_d);
                }
        // --- dovetail mortise on the 0 deg end (opens +y) ---
        translate([rim_outer_r - rim_radial_w/2, 0, dt_z])
            dovetail_mortise(h = dt_h);
    }
}

rim_segment();
