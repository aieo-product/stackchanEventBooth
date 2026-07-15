// params.scad
// Single source of truth for all dimensions and tolerances.
// Ferris wheel (docs/ferris-wheel.md) + photo booth (docs/photobooth.md).
// All units are millimetres.

// ---------------------------------------------------------------------------
// Global rendering resolution
// ---------------------------------------------------------------------------
$fn = 96;          // default facet count for curved surfaces

// ---------------------------------------------------------------------------
// Print tolerances (initial version = safe / loose side; retune after 7/15 test)
// ---------------------------------------------------------------------------
tol          = 0.30;   // generic hole enlargement over nominal (0.2..0.4)
tol_dovetail = 0.15;   // per-side clearance on dovetail joints
tol_snap     = 0.20;   // snap-fit clearance (diffuser over rim)

// Common fastener nominal sizes
m3_clear   = 3.4;      // M3 clearance hole
m3_insert  = 4.0;      // heat-set insert press hole (M3)
m3_thread  = 2.5;      // self-tapping / thread-forming pilot for M3

// ---------------------------------------------------------------------------
// Build volume guard (Bambu X2D style plate); every part must stay under this
// ---------------------------------------------------------------------------
max_part = 250;

// ===========================================================================
// FERRIS WHEEL
// ===========================================================================

// --- Rim (Ø300, quarter arcs, 4 per disc x 2 discs = 8) --------------------
rim_outer_d   = 300;                 // wheel outer diameter
rim_outer_r   = rim_outer_d / 2;     // 150
rim_radial_w  = 20;                  // radial width of the rim band
rim_inner_r   = rim_outer_r - rim_radial_w;   // 130
rim_depth     = 20;                  // axial thickness of the rim
rim_seg_angle = 90;                  // quarter arc

// LED groove on outer periphery (for 10 mm SK6812 tape)
led_groove_w  = 10.5;                // axial width
led_groove_d  = 2.0;                 // radial depth

// Spokes: 2 per segment, 8 per disc total, evenly spaced (45 deg)
spoke_count_per_seg = 2;
spoke_width   = 8;                   // tangential width of a spoke beam
spoke_depth   = 12;                  // axial thickness of a spoke beam
spoke_mount_r = 30;                  // radius at which spoke bolts to hub
spoke_pad_d   = 14;                  // diameter of the bolt pad at spoke tip

// --- Diffuser (U-channel cover snapping over rim outer band) ----------------
// Rim outer band is rim_depth (20) wide axially; cover wraps it.
diff_inner_w  = rim_depth + tol_snap * 2;   // internal width to clear rim (10.7 spec is for tape only)
diff_wall     = 1.6;                  // cover wall thickness
diff_lip      = 1.2;                  // snap lip that hooks the rim inner corner
diff_cover_t  = 2.0;                  // radial thickness of the outer cover shell
// Note: spec calls out an internal tape width of 10.7; the tape sits in the
// rim LED groove, the diffuser wraps the whole 20 mm band. See README.

// --- Hub (Ø80 x 25) --------------------------------------------------------
hub_d         = 80;
hub_r         = hub_d / 2;           // 40
hub_h         = 25;
shaft_d       = 8;                   // nominal 8 mm shaft
shaft_hole_d  = 8.2;                 // through bore for shaft
hub_boltring_r = spoke_mount_r;      // 30, matches spoke pads
hub_bolt_count = 8;                  // spoke bolt holes
hub_bolt_a0   = 22.5;                // first hole angle (matches spoke layout)
hub_set_count = 2;                   // radial set-screw insert bosses
hub_set_insert_d = m3_insert;        // 4.0 press hole for M3 insert

// --- Gondola ---------------------------------------------------------------
gon_in_x      = 75;                  // inner clear width
gon_in_y      = 75;                  // inner clear depth
gon_in_z      = 85;                  // inner clear height
gon_wall      = 2.0;
gon_out_x     = gon_in_x + gon_wall * 2;    // 79
gon_out_y     = gon_in_y + gon_wall * 2;    // 79
gon_out_z     = gon_in_z + gon_wall;        // 87 (open top), hooks add height
gon_guard_h   = 40;                  // front guard height (front upper open above)
gon_hook_d    = 3.4;                 // hook hole for Ø3 mm swing axle
gon_axle_hole_d = 3.2;               // rim through-hole for the Ø3 rod (E-ring retained)
gon_axle_r    = rim_inner_r + rim_radial_w/2;  // 140: rod centreline radius on the rim band
gon_axle_seg_angle = 45;             // one rod hole per segment, mid-arc -> 4 rods per wheel
gon_hook_r    = 8;                   // hook outer radius / arm size
gon_hook_rise = 14;                  // how far hooks rise above the box top
gon_rib_h     = 1.2;                 // bottom anti-slip rib height
gon_rib_w     = 1.6;
gon_rib_n     = 5;                   // number of floor ribs

// --- Tower (A-frame, total H280, split upper/lower) ------------------------
tower_total_h = 280;
tower_overlap = 30;                  // splice overlap length
tower_split_h = 170;                 // each printed half <= 170
tower_leg_w   = 18;                  // leg cross-section (in-plane)
tower_leg_t   = 22;                  // leg thickness (out-of-plane, axial-ish)
tower_base_span = 150;              // A-frame foot spread
bearing_d     = 22.2;                // 608 outer diameter pocket
bearing_h     = 7.2;                 // 608 pocket depth
bearing_lip   = 1.2;                 // retention lip overhang
bearing_bore  = 9.0;                 // clearance for shaft through bearing region
splice_dowel  = 8;                   // square dowel side (male on lower, socket on upper)
splice_bolt_n = 2;                   // M3 x2 at the splice
foot_tab_w    = 18;                  // insertion tab into base slot
foot_tab_t    = 10;
foot_tab_h    = 15;                  // tab depth into base
thumb_hole_d  = m3_clear;            // M3 thumbscrew through hole at foot

// --- Base (250 x 175 x 15, two boards joined on long edge -> 250 x 350) ----
base_x        = 250;                 // width of one board (shared long edge = 250)
base_y        = 175;                 // depth of one board
base_t        = 15;                  // thickness
base_slot_w   = foot_tab_w + tol;    // tower foot slot width
base_slot_t   = foot_tab_t + tol;
base_slot_d   = foot_tab_h + 1;      // slot depth
crank_bearing_d = 8.5;               // shaft pass-through at crank side (outside tower)
crank_boss_d  = 20;                  // boss around the crank bearing hole
crank_boss_h  = 14;

// --- Crank handle ----------------------------------------------------------
crank_arm_len = 60;                  // pivot-to-grip arm length
crank_arm_w   = 14;
crank_arm_t   = 10;
crank_hub_d   = 20;                  // hub around shaft
crank_shaft_d = shaft_hole_d;        // 8.2 fit onto shaft end
crank_set_insert_d = m3_insert;      // set-screw insert to lock onto shaft
grip_d        = 20;                  // free-spinning grip
grip_h        = 40;
grip_bore_d   = 5.2;                 // grip spins on a 5 mm post / screw
grip_post_d   = 5.0;

// --- Friction damper (C-clip that lightly pinches the shaft) ---------------
damper_bore_d = shaft_d;             // nominal grip on shaft (slight interference)
damper_gap    = 2.5;                 // mouth opening of the C
damper_wall   = 3.5;
damper_w      = 12;                  // axial width
damper_mount_hole = m3_clear;        // screws to base/tower

// ===========================================================================
// PHOTO BOOTH
// ===========================================================================

// --- Floor tile (150 x 150 x t3) -------------------------------------------
tile_x        = 150;
tile_y        = 150;
tile_t        = 3;
plank_w       = 25;                  // wood plank width
groove_d      = 0.6;                 // plank seam depth
groove_w      = 0.6;                 // plank seam width

// --- Wall panel (150 x 125 x t5), 3 variants -------------------------------
wall_x        = 150;
wall_y        = 125;
wall_t        = 5;
wall_frame    = 8;                   // frame border width
wall_tab_w    = 20;                  // stand insertion tab at bottom
wall_tab_t    = 6;
wall_tab_h    = 12;

// blackboard variant
bb_recess_d   = 1.0;                 // shallow concave for green paper

// window variant
win_mullion   = 4;                   // window bar thickness
win_inset     = 2;                   // rebate depth for backing paper

// board (cork) variant
cork_frame    = 6;
pin_grid      = 5;                   // pin hole grid count per axis
pin_hole_d    = 2.0;
pin_hole_depth = 1.5;

// --- Stand / clips (100 x 80 x t8 triangle) --------------------------------
stand_x       = 100;                 // base length
stand_y       = 80;                  // height
stand_t       = 8;
stand_slot_w  = wall_t + tol;        // panel slot width
stand_slot_d  = 18;                  // panel insert depth
clip_len      = 30;                  // panel-to-panel connecting clip
marker_d      = 24;                  // standing-position marker disc

// ---------------------------------------------------------------------------
// Dovetail default profile (shared by rim arcs, base boards, floor tiles)
// ---------------------------------------------------------------------------
dt_len        = 8;                   // protrusion length of the tenon
dt_base_w     = 8;                   // narrow (root) width
dt_neck_w     = 12;                  // wide (tip) width -> self-locking flare
