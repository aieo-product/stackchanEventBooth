// ferris/diffuser.scad
// LED diffuser cover: a U-channel that snaps over the 20 mm rim outer band,
// quarter arc (same span as one rim segment). Print in translucent filament.
// Cross-section wraps the band with two inward snap lips.

include <../params.scad>;

base_r  = rim_outer_r;                 // 150, band outer face
cover_t = diff_cover_t;                // 2.0 radial cover thickness
wall    = diff_wall;                   // 1.6 flange thickness
flange_in_r = base_r - 6;              // inner reach of the side flanges (144)
band_w  = rim_depth;                   // 20 axial band width
lip     = 0.6;                         // snap lip height (grips band corners)
lip_r   = flange_in_r + 2.5;           // lip radial extent

// 2D profile in (x=radius, y=z). Union of rectangles for a robust solid.
module profile() {
    // outer cover shell
    translate([base_r, -wall])              square([cover_t, band_w + 2 * wall]);
    // bottom flange
    translate([flange_in_r, -wall])         square([base_r + cover_t - flange_in_r, wall]);
    // top flange
    translate([flange_in_r, band_w])        square([base_r + cover_t - flange_in_r, wall]);
    // bottom snap lip (points up into the channel)
    translate([flange_in_r, 0])             square([lip_r - flange_in_r, lip]);
    // top snap lip (points down into the channel)
    translate([flange_in_r, band_w - lip])  square([lip_r - flange_in_r, lip]);
}

module diffuser() {
    // lift so the lowest face sits on z=0 (profile spans z = -wall .. band+wall)
    translate([0, 0, wall])
        rotate_extrude(angle = rim_seg_angle, $fn = 160)
            profile();
}

diffuser();
