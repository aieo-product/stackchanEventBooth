// lib/dovetail.scad
// Shared joinery modules: dovetail tenon/mortise, M3 insert boss, rounded box.
// Depends on values in params.scad (include it in the calling file).

// A dovetail tenon: a flared prism that grows wider toward its tip so it locks
// against a matching mortise when slid in along +y.
//   len   : protrusion length (along +y)
//   base_w: width at the root (x, near the part)
//   tip_w : width at the tip (x, wider -> self locking)
//   h     : height (z)
// Literal defaults keep this library self-contained under `use <>` (which does
// not import the caller's params). Callers pass explicit sizes where needed.
module dovetail_tenon(len = 8, base_w = 8, tip_w = 12, h = 10) {
    linear_extrude(height = h)
        polygon(points = [
            [-base_w/2, 0],
            [ base_w/2, 0],
            [ tip_w/2,  len],
            [-tip_w/2,  len],
        ]);
}

// Matching mortise volume (subtract this). Enlarged by tol_dovetail per side.
module dovetail_mortise(len = 8, base_w = 8, tip_w = 12, h = 10, clr = 0.15) {
    // extend slightly beyond both faces so the cut is clean
    translate([0, -0.01, -0.01])
        linear_extrude(height = h + 0.02)
            polygon(points = [
                [-(base_w/2 + clr), 0],
                [ (base_w/2 + clr), 0],
                [ (tip_w/2 + clr),  len + 0.02],
                [-(tip_w/2 + clr),  len + 0.02],
            ]);
}

// Cylindrical boss with a blind hole for a heat-set insert.
//   boss_d : outer diameter of the boss
//   boss_h : height
//   hole_d : insert press-hole diameter (params: m3_insert)
//   hole_depth : blind hole depth (0 = through)
module insert_boss(boss_d = 8, boss_h = 8, hole_d = 4.0, hole_depth = 0) {
    difference() {
        cylinder(d = boss_d, h = boss_h);
        translate([0, 0, hole_depth == 0 ? -0.01 : boss_h - hole_depth])
            cylinder(d = hole_d, h = hole_depth == 0 ? boss_h + 0.02 : hole_depth + 0.01);
    }
}

// Rounded rectangular box shell (open top) used by gondola / recesses.
module rounded_box(x, y, z, r = 2) {
    hull() {
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * (x/2 - r), sy * (y/2 - r), 0])
                cylinder(r = r, h = z);
    }
}

// A simple rectangular slot cutter (for tabs), centered on x, open along z.
module slot(w, t, d) {
    translate([-w/2, -t/2, -0.01])
        cube([w, t, d + 0.02]);
}
