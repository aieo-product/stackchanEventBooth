// ferris/hub.scad
// Central hub Ø80 x 25. Through bore for the Ø8 shaft, 8 axial bolt holes to
// receive the spoke pads (front + rear disc), and 2 radial M3 set-screw insert
// bosses that lock the hub onto the shaft.

include <../params.scad>;
use <../lib/dovetail.scad>;

module hub() {
    difference() {
        union() {
            cylinder(d = hub_d, h = hub_h);
            // radial set-screw bosses (2, 90 deg apart)
            for (a = [0, 90])
                rotate([0, 0, a])
                    translate([hub_r - 1, 0, hub_h/2])
                        rotate([0, -90, 0])
                            cylinder(d = 12, h = 8);   // stub for the insert
        }
        // central shaft bore
        translate([0, 0, -1]) cylinder(d = shaft_hole_d, h = hub_h + 2);
        // 8 axial spoke bolt holes.
        // 7/22: m3_clear -> m3_thread (self-tap pilot). A through-bolt would
        // need M3x50 (pad 20 + hub 25) which a normal assortment lacks; an
        // M3x25 taps ~5 mm into this pilot instead. If M3x50+nut IS on hand,
        // just drill the pilot out to 3.5.
        for (i = [0 : hub_bolt_count - 1])
            rotate([0, 0, hub_bolt_a0 + i * 360 / hub_bolt_count])
                translate([hub_boltring_r, 0, -1])
                    cylinder(d = m3_thread, h = hub_h + 2);
        // 2 radial set-screw insert holes reaching the bore
        for (a = [0, 90])
            rotate([0, 0, a])
                translate([hub_r + 3, 0, hub_h/2])
                    rotate([0, -90, 0])
                        cylinder(d = hub_set_insert_d, h = hub_r + 5);
    }
}

hub();
