// accessories/lego_side.scad (7/23)
// K151 body side LEGO(Technic)-compatible holes -> tiny event accessories.
// All parts print LYING FLAT (pin axis in the bed plane -> strong layers).
//   PART = "pintest"  : 3 pins (4.6/4.8/5.0) on a handle plate - fit test first!
//   PART = "flag"     : pin + pole + flag plate embossed "LT!"
//   PART = "penlight" : pin + short glow-stick shape (print in a bright colour)
// Technic hole nominal: 4.8. Pick the pin dia that snaps in from the test.

PIN_D   = 4.8;         // chosen after the pintest
pin_len = 7.4;         // Technic hole depth ~7.8
slit_w  = 1.1;         // flex slit

module pin(d) {
    difference() {
        union() {
            rotate([0, 90, 0]) cylinder(d = d, h = pin_len, $fn = 32);
            // small stop collar
            rotate([0, 90, 0]) cylinder(d = d + 2.4, h = 1.6, $fn = 32);
        }
        // flex slit through the pin tip
        translate([2.2, -slit_w/2, -d]) cube([pin_len, slit_w, d * 2]);
    }
}

module pintest() {
    // handle plate with three test pins, dia labels embossed
    dias = [4.6, 4.8, 5.0];
    difference() {
        translate([-3, -8, -3]) cube([3, 46, 6]);
        for (i = [0 : 2])
            translate([-2.4, i * 15 - 2.5, 2.2])
                rotate([90, 0, 90]) linear_extrude(0.6)
                    text(str(dias[i]), size = 4, halign = "left");
    }
    for (i = [0 : 2]) translate([0, i * 15, 0]) pin(dias[i]);
}

module flag() {
    pin(PIN_D);
    // pole continuing from the collar
    rotate([0, -90, 0]) cylinder(d = 4, h = 38, $fn = 24);
    // flag plate in the pin-axis plane -> vertical when mounted
    translate([-38, -1.5, 0]) {
        difference() {
            translate([0, 0, -11]) cube([30, 1.6, 22]);
            translate([3.5, 1.61, -8]) rotate([90, 0, 0])
                linear_extrude(0.7) text("LT!", size = 12, halign = "left");
        }
    }
}

module penlight() {
    pin(PIN_D);
    // stick with a rounded tip (hull of cylinder + sphere), lying flat
    hull() {
        rotate([0, -90, 0]) cylinder(d = 6, h = 26, $fn = 32);
        translate([-28, 0, 0]) sphere(d = 6, $fn = 32);
    }
}

PART = "pintest";
if (PART == "flag")          flag();
else if (PART == "penlight") penlight();
else                         pintest();
