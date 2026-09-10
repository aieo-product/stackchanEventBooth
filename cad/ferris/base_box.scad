// ferris/base_box.scad (v7.1 embedded variant, 2026-09-10)
// Motor-side base pad as a hollow box: tower foot slots on top (same +/-48
// layout as base_mini), the 80x60 control PCB + AtomS3R inside, AtomS3R
// window on top, E-stop / pot / RUN-STOP on the TOP face (front strip, -y),
// cable exits on the rear wall (+y toward the wheel), removable bottom lid.
//   PART="box" : printed upside down? No - printed upright (open bottom on the
//                bed would trap supports); the box is printed with the OPEN
//                BOTTOM UP (top face on the bed): flat top, no bridges.
//   PART="lid" : bottom lid, 4 x M3 self-tap into the corner bosses,
//                PCB standoffs (Ø2.9 pilots) on its inner face.
// Coordinates: box centre at origin, z up (top face at z = bb_z), tower feet
// along x, shaft axis along y (wheel side = +y).

include <../params.scad>;

PART = "box";

in_x = bb_x - 2*bb_wall;  in_y = bb_y - 2*bb_wall;  in_z = bb_z - bb_wall;   // cavity below the top plate
lid_in = bb_lid_t;
pcb_cx = 0;  pcb_cy = bb_pcb_oy;
atom_cx = pcb_cx + (pcb_atom_cx - pcb_x/2);   // -20
atom_cy = pcb_cy - (pcb_atom_cy - pcb_y/2);   // PCB's +y (connector edge) faces the wheel (+y); atom at board y=30 -> centre
boss = 8;

module foot_slots() {
    for (sx = [-1, 1])
        translate([sx * 48 - base_slot_w/2, -base_slot_t/2, bb_z - base_slot_d + 0.01])
            cube([base_slot_w, base_slot_t, base_slot_d + 1]);
}

module box_body() {
    difference() {
        union() {
            translate([-bb_x/2, -bb_y/2, 0]) cube([bb_x, bb_y, bb_z]);
        }
        // cavity, open at the bottom
        difference() {
            translate([-in_x/2, -in_y/2, -1]) cube([in_x, in_y, in_z + 1]);
            // keep solid blocks under the foot slots (30 x 34 like base_mini) so the tabs bite into material
            for (sx = [-1, 1]) translate([sx * 48 - 15, -17, bb_z - base_slot_d - 10]) cube([30, 34, base_slot_d + 11]);
            // corner bosses for the lid screws
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (in_x/2 - boss/2), sy * (in_y/2 - boss/2), 0]) cube([boss, boss, in_z], center = false);
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (in_x/2 - boss/2) - boss/2, sy * (in_y/2 - boss/2) - boss/2, -1]) cube([boss, boss, in_z + 1]);
        }
        foot_slots();
        // AtomS3R window on top
        translate([atom_cx - bb_atom_win/2, atom_cy - bb_atom_win/2, bb_z - bb_wall - 1]) cube([bb_atom_win, bb_atom_win, bb_wall + 2]);
        // panel parts on the top face (front strip)
        for (h = [[bb_estop_pos, panel_estop_hole_d], [bb_pot_pos, panel_pot_hole_d], [bb_btn_pos, panel_btn_hole_d]])
            translate([h[0][0], h[0][1], bb_z - bb_wall - 1]) cylinder(d = h[1], h = bb_wall + 2, $fn = 48);
        // rear wall cable exits (+y): motor, LED x2, 12V
        for (x = [-45, -30, 30, 45])
            translate([x, bb_y/2 - bb_wall - 1, 12]) rotate([-90, 0, 0]) cylinder(d = bb_cable_hole_d, h = bb_wall + 2, $fn = 24);
        // lid screw pilots in the corner bosses
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (in_x/2 - boss/2), sy * (in_y/2 - boss/2), -1]) cylinder(d = m3_thread, h = 14, $fn = 20);
        // vent slots on the side walls
        for (sx = [-1, 1], k = [0 : 5])
            translate([sx * (bb_x/2 - bb_wall/2), -35 + k * 14, 25]) cube([bb_wall + 2, 2, 14], center = true);
    }
}

module box() { translate([0, 0, bb_z]) mirror([0, 0, 1]) box_body(); }   // top face on the bed

// plain riser for the other tower (same height, foot slots only, hollow to save filament)
module box_plain_body() {
    difference() {
        translate([-bb_x/2, -bb_y/2, 0]) cube([bb_x, bb_y, bb_z]);
        difference() {
            translate([-in_x/2, -in_y/2, -1]) cube([in_x, in_y, in_z + 1]);
            for (sx = [-1, 1]) translate([sx * 48 - 15, -17, bb_z - base_slot_d - 10]) cube([30, 34, base_slot_d + 11]);
            // cross ribs for stiffness
            translate([-in_x/2, -3, -1]) cube([in_x, 6, in_z + 1]);
            translate([-3, -in_y/2, -1]) cube([6, in_y, in_z + 1]);
        }
        foot_slots();
    }
}
module box_plain() { translate([0, 0, bb_z]) mirror([0, 0, 1]) box_plain_body(); }

module lid() {
    difference() {
        union() {
            translate([-in_x/2 + 0.3, -in_y/2 + 0.3, 0]) cube([in_x - 0.6, in_y - 0.6, lid_in]);
            // PCB standoffs
            translate([0, 0, lid_in - 0.01]) for (sx = [-1, 1], sy = [-1, 1])
                translate([pcb_cx + sx * (pcb_x/2 - pcb_hole_inset), pcb_cy + sy * (pcb_y/2 - pcb_hole_inset), 0]) cylinder(d = 7, h = bb_pcb_standoff, $fn = 32);
        }
        for (sx = [-1, 1], sy = [-1, 1]) translate([pcb_cx + sx * (pcb_x/2 - pcb_hole_inset), pcb_cy + sy * (pcb_y/2 - pcb_hole_inset), 1]) cylinder(d = m3_thread, h = 20, $fn = 20);
        // corner clearance for the bosses + screw holes
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * (in_x/2 - boss/2), sy * (in_y/2 - boss/2), -1]) cylinder(d = m3_clear, h = lid_in + 2, $fn = 24);
    }
}

if (PART == "box") box();
else if (PART == "box-plain") box_plain();
else if (PART == "lid") lid();
