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

// --- Gondola (chair-type open gondola, redesign #18) ------------------------
// Carries one M5Stack CoreS3/K151 unit (official base 48.0x56.0xh11.1, whole
// 54.0x70.5x61.5, 187.2 g). Open front so the screen/body is visible; the unit
// is loaded from the top and sits in a two-stage nested floor pocket.
gon_floor_x   = 74;                  // seat plate width  (X): posts inner gap 60 > unit 54 (+3/side)
gon_floor_y   = 86;                  // seat plate depth (Y): clears the 70.5 envelope + top-loading corridor
gon_floor_t   = 6;                   // seat plate thickness

// two-stage nested floor pockets (both measured down from the seat top)
gon_pocket_o  = 62;                  // outer pocket (square) - generic/Takao base + gel tape
gon_pocket_o_d = 1.5;                // outer pocket depth
k151_base_x   = 48.0;                // official K151 base footprint (X)
k151_base_y   = 56.0;                // official K151 base footprint (Y)
gon_pocket_fit = 0.3;                // clearance per side for the K151 base
gon_pocket_i_x = k151_base_x + 2 * gon_pocket_fit;   // 48.6 inner pocket
gon_pocket_i_y = k151_base_y + 2 * gon_pocket_fit;   // 56.6 inner pocket
gon_pocket_i_d = 2.0;                // inner pocket depth (deeper -> locates the base)

gon_side_h    = 25;                  // side rail + backrest height above the seat
gon_wall_t    = 4;                   // rail / backrest thickness
gon_backrest_h = 25;                 // low back wall height

gon_post_x    = 6;                   // hanger post cross-section (X)
gon_post_y    = 18;                  // hanger post cross-section (Y)
gon_post_cx   = 33;                  // post centre offset: inner faces at +/-30 -> 6 mm total clearance over the 54-wide unit
gon_pivot_z   = 73;                  // swing-axle centre height (raised for the Ø6.5 J-slot: 2.75 mm wall under the seat while bridge_bot 67 keeps 3 mm head clearance)
gon_bridge_y  = 30;                  // hanger-bridge length in Y (grips the axle over 30 mm)

gon_bar_d     = 6;                   // front safety bar diameter (D-section, flat underside)
gon_bar_rise  = 22;                  // bar height above the seat top

// Swing axle: PRINTED Ø6 PLA axle (the user has no rod-cutting tools), replacing
// the Ø3 metal rod. No E-ring needed - a push cap retains it. The ordered Ø3
// steel rod / E-rings are repurposed for other builds.
gon_axle_d    = 6.0;                 // printed Ø6 axle nominal
gon_hook_d    = 6.7;                 // J-slot width (printed holes shrink ~0.2; 7/19 test)
gon_axle_hole_d = 6.8;               // rim/disc through-hole (7/19 test: 6.4 was too tight on the printed axle)
gon_axle_r    = rim_inner_r + rim_radial_w/2;  // 140: axle centreline radius on the rim band
gon_axle_seg_angle = 45;             // one axle hole per segment, mid-arc -> 4 axles per wheel
// assembly note: the rim inner gap must clear the gondola DEPTH (gon_floor_y=86,
// the front-back axis that runs along the axle), not its width -> gap 90 below.

// --- Printed axle (cad/ferris/axle.scad) -----------------------------------
axle_rim_gap   = 90;                 // clear gap between rim discs (> gondola depth 84 + clearance)
axle_thru_len  = axle_rim_gap + 2 * rim_depth;   // 120: through both 20 mm rims
axle_protrude  = 6;                  // shaft past the far rim for the cap to grab
axle_shaft_len = axle_thru_len + axle_protrude;  // 126
axle_head_d    = 10;                 // integral flange head
axle_flat      = 0.4;                // D-flat depth (print-flat orientation)
axle_head_t    = 3;
axle_total_len = axle_head_t + axle_shaft_len;   // 129 (~128 target)
axle_cap_d     = 10;                 // push-cap outer diameter
axle_cap_h     = 6;
axle_cap_bore  = gon_axle_d;         // 6.0: printed bore shrinks ~0.2-0.3 -> effective light press fit (7/19 tune)
axle_count     = 4;                  // one per gondola
axle_spares    = 1;                  // print a spare axle
cap_spares     = 2;                  // and a couple of spare caps

// --- Swing test rig (cad/ferris/swing_test_rig.scad) -----------------------
// Pre-hardware bench test (before the metal shaft 7/18 & 608 bearings 7/20-22):
// dummy shaft -> mini rim discs -> printed axle -> gondola, verify the gondola
// stays level while the wheel turns. Plain bushings (friction OK), tool-free.
rig_disc_d     = 100;                // mini disc diameter
rig_disc_t     = 6;                  // mini disc thickness
rig_shaft_d    = 8;                  // dummy shaft (D-section, print flat)
rig_shaft_flat = 3.2;               // D-flat chord distance from the shaft axis
rig_bore_d     = 8.6;               // disc centre D-hole (7/19: +0.4 for printed-shaft reality)
rig_bore_flat  = 3.6;               // disc D-hole flat (7/19: +0.4 clearance)
rig_bush_d     = 9.0;               // stand plain bushing bore (7/19: +0.4; friction OK)
rig_axle_r     = 40;                // gondola axle hole radius on the mini disc
rig_gap        = axle_rim_gap;      // 90: same gap as production (clears gondola depth 84)
rig_bush_z     = 126;              // shaft centre height (gondola 70 below axle + orbit 40 + clear 10 over base); keeps stand <=150
rig_shaft_len  = rig_gap + 2 * rig_disc_t + 2 * 14 + 2;   // ~132
rig_stand_span = 34;               // stand foot half-span (X); feet stay within the 80-wide base
rig_stand_t    = 8;                // stand plate thickness (Y)
rig_stand_y    = rig_shaft_len/2 - 8;   // 58: stand positions along the shaft
rig_base_x     = 80;               // base width (across the A-frame feet)
rig_base_y     = 150;              // base length (along the shaft)
rig_base_t     = 6;
rig_foot_tab_w = 16;               // stand foot tab into the base slot
rig_foot_tab_h = 8;                // tab depth into the base (keeps stand height <=150)

// --- Mini ferris adapter (#19: Artec wooden kit 055521) --------------------
// Drop-in bucket that replaces one wooden gondola. Values are PLACEHOLDERS
// pending caliper measurement (arm-ring slot, pitch, wheel dia, seat tab).
mini_tab_w    = 10;                  // insertion tab width (into the arm-ring slot)
mini_tab_t    = 3;                   // insertion tab thickness
mini_tab_l    = 12;                  // insertion tab length
mini_wall     = 1.6;                 // bucket wall thickness
mini_atomcat_in = 42;               // bucket inner floor for Atom-cat (square)
mini_minimal_in = 46;               // bucket inner floor for minimal unit (square)
mini_depth    = 12;                  // bucket inner depth
mini_guard_h  = 15;                  // front guard height (low, unit is light 30-60 g)
mini_floor_t  = 2;                   // bucket floor thickness

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
