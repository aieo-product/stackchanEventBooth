// ferris/ctrl_box.scad (v7, 2026-09-03)
// Enclosure for the 80 x 60 control board (AtomS3R carrier, EasyEDA/JLCPCB).
// The board outline / hole pattern / Atom position are fixed in params.scad so
// this box can be printed BEFORE the PCB arrives; the layout must follow them.
//   PART="tray" : open-top tray, 4 standoffs (M3 self-tap Ø2.9), connector-edge
//                 wall (+Y) cut down so cables leave under the lid.
//   PART="lid"  : drop-in lid with a lip, window for the AtomS3R (screen/button)
//                 + 4 vent slots.

include <../params.scad>;

PART = "tray";

in_x = pcb_x + 2*box_clear;                 // 83
in_y = pcb_y + 2*box_clear;                 // 63
in_h = box_standoff_h + pcb_t + pcb_atom_h + 2;   // 21.6: Atom is the tallest part
out_x = in_x + 2*box_wall;
out_y = in_y + 2*box_wall;
out_h = in_h + box_floor_t;

module holes2d() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * (pcb_x/2 - pcb_hole_inset), sy * (pcb_y/2 - pcb_hole_inset)]) children();
}

module tray() {
    difference() {
        union() {
            difference() {
                translate([-out_x/2, -out_y/2, 0]) cube([out_x, out_y, out_h]);
                translate([-in_x/2, -in_y/2, box_floor_t]) cube([in_x, in_y, out_h]);
            }
            // standoffs
            translate([0, 0, box_floor_t - 0.01])
                holes2d() cylinder(d = box_standoff_d, h = box_standoff_h + 0.01, $fn = 32);
        }
        // M3 self-tap pilots in the standoffs
        translate([0, 0, 1]) holes2d() cylinder(d = m3_thread, h = box_floor_t + box_standoff_h, $fn = 20);
        // connector-edge (+Y) wall cut
        translate([-box_conn_cut_w/2, out_y/2 - box_wall - 1, out_h - box_conn_cut_h])
            cube([box_conn_cut_w, box_wall + 2, box_conn_cut_h + 1]);
        // 2 x M3 mounting holes in the floor (zip-tie / screw to the base pad)
        for (sx = [-1, 1])
            translate([sx * 25, 0, -1]) cylinder(d = m3_clear, h = box_floor_t + 2, $fn = 24);
    }
}

module lid() {
    difference() {
        union() {
            translate([-out_x/2, -out_y/2, 0]) cube([out_x, out_y, box_wall]);
            // lip that drops inside the tray walls
            translate([-in_x/2 + tol, -in_y/2 + tol, box_wall - 0.01])
                difference() {
                    cube([in_x - 2*tol, in_y - 2*tol, box_lip]);
                    translate([box_wall, box_wall, -1]) cube([in_x - 2*tol - 2*box_wall, in_y - 2*tol - 2*box_wall, box_lip + 2]);
                }
        }
        // AtomS3R window (body 24 x 24 + play)
        translate([pcb_atom_cx - pcb_x/2, pcb_atom_cy - pcb_y/2, -1])
            translate([-(pcb_atom_w + 1)/2, -(pcb_atom_w + 1)/2, 0])
                cube([pcb_atom_w + 1, pcb_atom_w + 1, box_wall + box_lip + 2]);
        // vent slots
        for (i = [0 : 3])
            translate([15 + i * 8, -pcb_y/2 + 8, -1]) cube([3, pcb_y - 16, box_wall + 2]);
    }
}

if (PART == "tray") tray();
else if (PART == "lid") lid();
