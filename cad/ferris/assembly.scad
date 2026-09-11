// ferris/assembly.scad
// Places every ferris-wheel part in its assembled position for the browser
// assembly viewer (three.js). Coordinate system:
//   - origin = centre of the base underside (z=0 on the table)
//   - wheel axle runs along Y at height z = shaft_z, in front of the camera
//   - PART selects a single export group; PART="all" renders the whole wheel.
// Export groups (see Makefile `viewer-models`, docs/public/models/ferris/):
//   base, tower-front, tower-rear, shaft, hubs, rim-front, rim-rear,
//   diffusers, axles, gondola-1..4, crank
//
// The STL of each group is written already positioned in world coordinates, so
// the viewer just loads it at the origin. `explode` vectors live in manifest.json.

include <../params.scad>;
use <rim_segment.scad>;
use <diffuser.scad>;
use <hub.scad>;
use <gondola.scad>;
use <tower.scad>;
use <crank.scad>;
use <motor_mount.scad>;
use <ctrl_box.scad>;
use <motor_pod.scad>;
use <base_box.scad>;
include <pcb_parts.scad>;
use <axle.scad>;
use <k151.scad>;
use <base.scad>;

PART = "all";
V71 = false;                              // v7.1 embedded variant (motor pod + base box); towers sit 30 mm higher
lift = V71 ? bb_z - base_t : 0;
module raised() { translate([0, 0, lift]) children(); }

// --- assembled geometry constants ------------------------------------------
apex_zc   = tower_total_h - 22;          // 258: bearing centre in tower-local z
base_top  = base_t;                      // 15: top of the base plate
shaft_z   = base_top + apex_zc;           // 273: wheel axle height
disc_in   = axle_rim_gap / 2;            // 45: inner face of each rim disc
tower_y   = disc_in + rim_depth + 33;     // 98: outer tower so inner face clears the disc
gon_ang   = [45, 135, 225, 315];         // gondola / axle angular positions

// --- part groups -----------------------------------------------------------
module a_base() {
    color("silver") {
        translate([0, -base_y, 0]) base_board();
        translate([0,  base_y, 0]) rotate([0, 0, 180]) base_board();
    }
}

module tower_full() {
    difference() {
        union() { frame_solid(); foot_tabs(); }
        bearing_features();
        thumb_holes();
    }
}

module a_tower_front() {
    color("dimgray")
        translate([0, tower_y, base_top]) rotate([0, 0, 180]) tower_full();
}
module a_tower_rear() {
    color("dimgray")
        translate([0, -tower_y, base_top]) tower_full();
}

module a_shaft() { a_shaft_v7(); }   // v7 (9/3): shaft slid 12 mm rearward (was -tower_y-8 .. +130)

module one_disc() {          // full ring in local XY, depth 0..rim_depth in +z
    for (k = [0 : 3]) rotate([0, 0, k * 90]) rim_segment();
}
module a_rim_front() {
    color("ivory")
        translate([0, disc_in, shaft_z]) rotate([-90, 0, 0]) one_disc();
}
module a_rim_rear() {
    color("ivory")
        translate([0, -disc_in, shaft_z]) rotate([90, 0, 0]) one_disc();
}

module one_diffuser_ring() { for (k = [0 : 3]) rotate([0, 0, k * 90]) diffuser(); }
module a_diffusers() {
    color("palegreen") {
        translate([0, disc_in, shaft_z]) rotate([-90, 0, 0]) one_diffuser_ring();
        translate([0, -disc_in, shaft_z]) rotate([90, 0, 0]) one_diffuser_ring();
    }
}

module a_hubs() {
    color("slategray") {
        translate([0, disc_in - 3, shaft_z]) rotate([-90, 0, 0]) hub();
        translate([0, -disc_in + 3, shaft_z]) rotate([90, 0, 0]) hub();
    }
}

module a_axles() {
    color("gainsboro")
        for (a = gon_ang)
            translate([gon_axle_r * cos(a), -(tower_y - 8), shaft_z + gon_axle_r * sin(a) - (gon_axle_d/2 - axle_flat)])
                rotate([0, 0, 90]) axle();   // new lying-flat model: +X -> +Y, centreline re-zeroed
}

gon_colors = ["lightpink", "khaki", "lightskyblue", "white"];
module a_gondola(i) {
    a = gon_ang[i];
    color(gon_colors[i])
        translate([gon_axle_r * cos(a), 0, shaft_z + gon_axle_r * sin(a) - gon_pivot_z])
            gondola();
}

module a_stackchan() {
    // official K151 riding in gondola 1 (fit/height reference for the viewer)
    a = gon_ang[0];
    translate([gon_axle_r * cos(a), 0, shaft_z + gon_axle_r * sin(a) - gon_pivot_z])
        translate([0, 0, gon_floor_t - gon_pocket_o_d - gon_pocket_i_d])
            k151();
}

// --- v7 (9/3): motor drive on the former crank side (+Y tower) --------------
// Shaft slid 12 mm toward -Y so both ends protrude shaft_protrude (20).
module a_shaft_v7() {
    color("gainsboro")
        translate([0, -(tower_y + shaft_protrude), shaft_z]) rotate([-90, 0, 0])
            cylinder(d = shaft_d, h = 2 * (tower_y + shaft_protrude), $fn = 32);
}
module a_motor_bracket() {
    color("darkorange")
        translate([0, tower_y, shaft_z]) rotate([0, 180, 0]) rotate([-90, 0, 0]) bracket();
}
module a_coupling() {
    color("silver")
        translate([0, tower_y + shaft_protrude - coupling_grip, shaft_z]) rotate([-90, 0, 0])
            cylinder(d = coupling_d, h = coupling_len, $fn = 32);
}
module a_motor() {
    // dummy JGY-370: gearbox block (shaft 15 from the top short end, can hangs down)
    yf = tower_y + motor_standoff;
    color("gray") {
        translate([-motor_gb_w/2, yf, shaft_z - (motor_gb_h - motor_shaft_off)])
            cube([motor_gb_w, motor_gb_t, motor_gb_h]);
        translate([0, yf - 1, shaft_z]) rotate([-90, 0, 0]) cylinder(d = motor_shaft_d, h = motor_shaft_len + 1, $fn = 24);
        // 370 can below the gearbox
        translate([0, yf + motor_gb_t/2, shaft_z - (motor_gb_h - motor_shaft_off) + 0.01])
            rotate([180, 0, 0]) cylinder(d = motor_body_d, h = motor_body_len, $fn = 32);
    }
}
module a_drive_v7() { a_motor_bracket(); a_coupling(); a_motor(); }

// --- v7 control box: on the table just past the base edge on the motor side.
// Box local: PCB centred, connector edge = +Y. Rotated 180° so the connectors
// face the wheel/motor (-Y). Box outer 87 x 67 x 23.6, lid on top.
box_cx   = 0;
box_cy   = base_y + 12 + (pcb_y + 2*box_clear + 2*box_wall)/2;   // 220.5
pcb_ox   = -box_bay_w/2;                                          // PCB sits left of the panel bay
box_h    = box_inner_h + box_floor_t;                             // 47
pcb_z    = box_floor_t + box_standoff_h;                          // 7: PCB underside
module in_box() { translate([box_cx, box_cy, 0]) rotate([0, 0, 180]) children(); }

module a_ctrl_tray() { in_box() color("dimgray") tray(); }
module a_ctrl_lid()  { in_box() color("dimgray", 0.9) translate([0, 0, box_h]) mirror([0, 0, 1]) lid(); }
module a_ctrl_box()  { a_ctrl_tray(); a_ctrl_lid(); }

// PCB with the parts at the ordered positions (fab/PickAndPlace csv -> pcb_parts.scad).
// Board coords (x right, y down from the top-left) -> board-centre model coords.
module pcb_part(d, xb, yb, rot, w, h, z, kind) {
    translate([xb - pcb_x/2, pcb_y/2 - yb, pcb_t]) rotate([0, 0, -rot]) {
        if (kind == "cyl")      color("black") { cylinder(d = w, h = z, $fn = 32); color("silver") translate([0, 0, z]) cylinder(d = w, h = 0.3, $fn = 32); }
        else if (kind == "ic")  color("black") translate([-w/2, -h/2, 0]) cube([w, h, z]);
        else if (kind == "xh")  color("ivory") translate([-w/2, -h/2, 0]) cube([w, h, z]);
        else if (kind == "hdr") color("black") translate([-w/2, -h/2, 0]) cube([w, h, z]);
        else if (kind == "tht") color("black") translate([-w/2, -h/2, 0]) cube([w, h, z]);
        else                    color(d[0] == "R" ? "black" : d[0] == "L" && d != "LED1" ? "gray" : d == "LED1" ? "red" : "tan") translate([-w/2, -h/2, 0]) cube([w, h, z]);
    }
}
module a_ctrl_pcb() {
    in_box() translate([pcb_ox, 0, pcb_z]) {
        color("darkgreen") translate([-pcb_x/2, -pcb_y/2, 0]) cube([pcb_x, pcb_y, pcb_t]);
        for (p = pcb_parts) pcb_part(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    }
}
// AtomS3R plugged into J9A/J9B (body 24 x 24 x 12.9 on the 8.5 mm sockets, screen up, Grove port toward the connector edge)
module a_atom() {
    in_box() translate([pcb_ox + (pcb_atom_cx - pcb_x/2), pcb_y/2 - pcb_atom_cy, pcb_z + pcb_t + 8.5]) {
        color("black") translate([-12, -12, 0]) cube([24, 24, pcb_atom_h]);
        color("deepskyblue") translate([-9, -9, pcb_atom_h]) cube([18, 18, 0.2]);
        color("white") translate([-2.5, 12 - 0.5, 2]) cube([5, 1, 3]);   // Grove port (toward +y = connector edge)
        // pins into the sockets
        color("silver") for (x = [-7.62, 7.62], y = [-7.72, -5.18, -2.64, -0.10, 2.44]) if (!(x > 0 && y > 2)) translate([x, -y, -8.5]) cylinder(d = 0.64, h = 8.5, $fn = 8);
    }
}

module a_ctrl_panel() {
    // panel-mount parts on the lid: E-stop mushroom, speed knob, RUN/STOP button
    in_box() translate([0, 0, box_h]) {                        // panel bay, box-centre coords
        translate([panel_estop[0], panel_estop[1], 0]) {
            color("yellow") cylinder(d = 32, h = 1, $fn = 48);
            color("red") { cylinder(d = 22, h = 6, $fn = 40); translate([0, 0, 6]) cylinder(d = 40, h = 14, $fn = 48); }
            color("black") translate([0, 0, -30]) cylinder(d = 22, h = 30, $fn = 32);   // body under the lid
        }
        color("black")  translate([panel_pot[0], panel_pot[1], 0]) cylinder(d = 16, h = 14, $fn = 32);     // speed knob
        color("limegreen") translate([panel_btn[0], panel_btn[1], 0]) cylinder(d = 14, h = 6, $fn = 32);  // RUN/STOP
    }
}
module a_cables() {
    // motor cable: box connector edge -> gearbox terminals (2 straight runs)
    yf = tower_y + motor_standoff;
    color("black") {
        // (box is rotated 180°: PCB / connectors are on the +X side in world coords)
        hull() { translate([22, box_cy - 33, 24]) sphere(2); translate([22, yf + 10, 24]) sphere(2); }
        hull() { translate([22, yf + 10, 24]) sphere(2); translate([14, yf + 10, shaft_z - 60]) sphere(2); }
        // 12 V lead out to the AC adapter
        hull() { translate([60, box_cy - 33, 24]) sphere(2); translate([60, box_cy - 33, 8]) sphere(2); }
        hull() { translate([60, box_cy - 33, 8]) sphere(2); translate([120, box_cy - 33, 8]) sphere(2); }
    }
}
module a_ctrl_v7() { a_ctrl_tray(); a_ctrl_lid(); a_ctrl_pcb(); a_atom(); a_ctrl_panel(); a_cables(); }

module a_crank() {
    color("gold")
        translate([0, tower_y + 14, shaft_z]) rotate([-90, 0, 0]) crank_body();
}

// --- v7.1 embedded variant ---------------------------------------------------
// Motor-side base box at y = +tower_y (front tower), plain riser at -tower_y.
module a71_base_box()  { color("silver") translate([0, tower_y, 0]) rotate([0, 0, 180]) box_body(); }
module a71_base_lid()  { color("gray")   translate([0, tower_y, 0]) rotate([0, 0, 180]) lid(); }
module a71_base_rear() { color("silver") translate([0, -tower_y, 0]) box_plain_body(); }
// PCB inside the box: box-local (x, y) -> world via the same 180° rotation
module a71_in_box() { translate([0, tower_y, 0]) rotate([0, 0, 180]) children(); }
module a71_pcb() {
    a71_in_box() translate([0, bb_pcb_oy, bb_lid_t + bb_pcb_standoff]) {
        color("darkgreen") translate([-pcb_x/2, -pcb_y/2, 0]) cube([pcb_x, pcb_y, pcb_t]);
        for (p = pcb_parts) pcb_part(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
    }
}
module a71_atom() {
    a71_in_box() translate([(pcb_atom_cx - pcb_x/2), bb_pcb_oy + (pcb_y/2 - pcb_atom_cy), bb_lid_t + bb_pcb_standoff + pcb_t + 8.5]) {
        color("black") translate([-12, -12, 0]) cube([24, 24, pcb_atom_h]);
        color("deepskyblue") translate([-9, -9, pcb_atom_h]) cube([18, 18, 0.2]);
        color("silver") for (x = [-7.62, 7.62], y = [-7.72, -5.18, -2.64, -0.10, 2.44]) if (!(x > 0 && y > 2)) translate([x, -y, -8.5]) cylinder(d = 0.64, h = 8.5, $fn = 8);
    }
}
module a71_panel() {
    // on the top face (box-local), vertical axis
    a71_in_box() translate([0, 0, bb_z]) {
        translate([bb_estop_pos[0], bb_estop_pos[1], 0]) { color("yellow") cylinder(d = 32, h = 1, $fn = 48); color("red") { cylinder(d = 22, h = 6, $fn = 40); translate([0, 0, 6]) cylinder(d = 40, h = 14, $fn = 48); } color("black") translate([0, 0, -30]) cylinder(d = 22, h = 30, $fn = 32); }
        color("black") translate([bb_pot_pos[0], bb_pot_pos[1], 0]) cylinder(d = 16, h = 14, $fn = 32);
        color("limegreen") translate([bb_btn_pos[0], bb_btn_pos[1], 0]) cylinder(d = 14, h = 6, $fn = 32);
    }
}
module a71_cables() {
    yf = tower_y + pod_gb_face_y;
    color("black") {
        // motor cable: rear-wall exit -> up the tower back -> pod bottom
        hull() { translate([-30, tower_y - bb_y/2 - 2, 12]) sphere(2); translate([-30, tower_y + 3, 12]) sphere(2); }
        hull() { translate([-30, tower_y + 3, 12]) sphere(2); translate([-30, tower_y + 3, lift + shaft_z + pod_bottom - 5]) sphere(2); }
        hull() { translate([-30, tower_y + 3, lift + shaft_z + pod_bottom - 5]) sphere(2); translate([0, tower_y + pod_len/2, lift + shaft_z + pod_bottom - 5]) sphere(2); }
        // 12 V lead out of the rear wall toward the wheel side... routed along the base
        hull() { translate([45, tower_y - bb_y/2 - 2, 12]) sphere(2); translate([45, tower_y - bb_y/2 - 60, 12]) sphere(2); }
    }
}
module a71_pod()   { color("darkorange") raised() translate([0, tower_y, shaft_z]) pod_body(); }
module a71_cover() { color("orange") raised() translate([0, tower_y, shaft_z]) translate([-(pod_in_w + 2)/2, mpod_wall, pod_bottom + 3]) cover(); }
module a71_motor() {
    yf = tower_y + pod_gb_face_y;
    color("gray") raised() {
        translate([-motor_gb_w/2, yf, shaft_z - (motor_gb_h - motor_shaft_off)]) cube([motor_gb_w, motor_gb_t, motor_gb_h]);
        translate([0, yf - 1, shaft_z]) rotate([-90, 0, 0]) cylinder(d = motor_shaft_d, h = motor_shaft_len + 1, $fn = 24);
        translate([0, yf + motor_gb_t/2, shaft_z - (motor_gb_h - motor_shaft_off) + 0.01]) rotate([180, 0, 0]) cylinder(d = motor_body_d, h = motor_body_len, $fn = 32);
    }
}
module a71_all() {
    a71_base_box(); a71_base_lid(); a71_base_rear(); a71_pcb(); a71_atom(); a71_panel(); a71_cables();
    raised() { a_tower_front(); a_tower_rear(); a_shaft_v7(); a_hubs(); a_rim_front(); a_rim_rear(); a_axles(); for (i = [0:3]) a_gondola(i); a_stackchan(); a_coupling(); }
    a71_pod(); a71_cover(); a71_motor();
}
module a71_open() {
    a71_base_box(); a71_base_rear(); a71_pcb(); a71_atom(); a71_panel(); a71_cables();
    raised() { a_tower_front(); a_tower_rear(); a_shaft_v7(); a_hubs(); a_rim_front(); a_rim_rear(); a_axles(); for (i = [0:3]) a_gondola(i); a_stackchan(); a_coupling(); }
    a71_motor();
}

// --- dispatch --------------------------------------------------------------
if (PART == "all") { if (V71) a71_all(); else {
    a_base(); a_tower_front(); a_tower_rear(); a_shaft(); a_hubs();
    a_rim_front(); a_rim_rear(); a_diffusers(); a_axles();
    for (i = [0:3]) a_gondola(i);
    a_stackchan();
    a_crank(); } }
else if (PART == "all-v71")       a71_all();
else if (PART == "all-v71-open")  a71_open();
else if (PART == "base")          { if (V71) a71_base_box(); else a_base(); }
else if (PART == "base-lid")      a71_base_lid();
else if (PART == "base-rear")     a71_base_rear();
else if (PART == "tower-front")   raised() a_tower_front();
else if (PART == "tower-rear")    raised() a_tower_rear();
else if (PART == "shaft")         raised() a_shaft();
else if (PART == "hubs")          raised() a_hubs();
else if (PART == "rim-front")     raised() a_rim_front();
else if (PART == "rim-rear")      raised() a_rim_rear();
else if (PART == "diffusers")     raised() a_diffusers();
else if (PART == "axles")         raised() a_axles();
else if (PART == "stackchan")     raised() a_stackchan();
else if (PART == "crank")         raised() a_crank();
else if (PART == "gondola-1")     raised() a_gondola(0);
else if (PART == "gondola-2")     raised() a_gondola(1);
else if (PART == "gondola-3")     raised() a_gondola(2);
else if (PART == "gondola-4")     raised() a_gondola(3);
else if (PART == "shaft-v7")      raised() a_shaft_v7();
else if (PART == "motor-bracket") raised() a_motor_bracket();
else if (PART == "coupling")      raised() a_coupling();
else if (PART == "motor")         { if (V71) a71_motor(); else a_motor(); }
else if (PART == "motor-pod")     a71_pod();
else if (PART == "pod-cover")     a71_cover();
else if (PART == "ctrl-box")      a_ctrl_box();
else if (PART == "ctrl-tray")     a_ctrl_tray();
else if (PART == "ctrl-lid")      a_ctrl_lid();
else if (PART == "ctrl-pcb")      { if (V71) a71_pcb(); else a_ctrl_pcb(); }
else if (PART == "atom")          { if (V71) a71_atom(); else a_atom(); }
else if (PART == "ctrl-panel")    { if (V71) a71_panel(); else a_ctrl_panel(); }
else if (PART == "cables")        { if (V71) a71_cables(); else a_cables(); }
else if (PART == "all-v7") {
    a_base(); a_tower_front(); a_tower_rear(); a_shaft_v7(); a_hubs();
    a_rim_front(); a_rim_rear(); a_axles();
    for (i = [0:3]) a_gondola(i);
    a_stackchan();
    a_drive_v7();
    a_ctrl_v7();
}
else if (PART == "all-v7-open")  { a_base(); a_tower_front(); a_tower_rear(); a_shaft_v7(); a_hubs(); a_rim_front(); a_rim_rear(); a_axles(); for (i = [0:3]) a_gondola(i); a_stackchan(); a_coupling(); a_motor(); a_ctrl_tray(); a_ctrl_pcb(); a_atom(); a_cables(); }
