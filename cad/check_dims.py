#!/usr/bin/env python3
"""Bounding-box dimension check for generated STLs.

Pure standard-library (binary + ASCII STL parser) so it runs without numpy-stl.
Reads every STL under the output dir (default: ../print/files), prints each
part's bounding box (X,Y,Z), and checks:
  - bounding box <= build-volume limit (250 mm)
  - per-part expected design dimension (+/- 1 mm)
  - GROUND check: the lowest face sits on z=0 (+/- 0.01) so no geometry prints
    in mid-air (root cause of the #18 rim spaghetti failure).

Usage:
    python3 check_dims.py [stl_dir]
"""
import sys
import os
import glob
import struct

MAX_PART = 250.0          # build-volume guard (mm)
TOL = 1.0                 # +/- design tolerance for the checked dimension (mm)
GROUND_TOL = 0.01         # the STL's lowest point must be at z=0 +/- this

# part basename -> (dimension, expected_value, label)
# dimension: "X"/"Y"/"Z"/"maxxy" or None (only the <=250 guard is applied).
EXPECTED = {
    "rim-segment":     ("Y", 150.0, "rim outer radius 150 (Y; X carries the tenon)"),
    "diffuser":        (None, None, ""),
    "hub":             ("Z", 25.0, "hub height 25"),
    "gondola":         (None, None, ""),
    "tower-upper":     (None, None, ""),
    "tower-lower":     (None, None, ""),
    "base":            ("X", 250.0, "board width 250"),
    "crank":           (None, None, ""),
    "floor-tile":      ("Z", 3.0, "tile thickness t3 (X/Y 150 body + 8 dovetail)"),
    "wall-blackboard": ("X", 150.0, "panel 150"),
    "wall-window":     ("X", 150.0, "panel 150"),
    "wall-board":      ("X", 150.0, "panel 150"),
    "stand-clips":     (None, None, ""),
    "mini-adapter-atomcat": (None, None, ""),
    "mini-adapter-minimal": (None, None, ""),
    "rig-disc":  ("X", 100.0, "mini disc Ø100"),
    "rig-shaft": (None, None, ""),
    "rig-stand": (None, None, ""),
    "rig-base":  ("Y", 150.0, "rig base length 150"),
}


def bbox(path):
    with open(path, "rb") as fh:
        head = fh.read(5)
        fh.seek(0)
        data = fh.read()
    lo = [float("inf")] * 3
    hi = [float("-inf")] * 3

    def acc(x, y, z):
        for i, v in enumerate((x, y, z)):
            if v < lo[i]:
                lo[i] = v
            if v > hi[i]:
                hi[i] = v

    is_ascii = head == b"solid" and b"facet" in data[:1024]
    if is_ascii:
        for line in data.decode("ascii", "ignore").splitlines():
            parts = line.split()
            if len(parts) == 4 and parts[0] == "vertex":
                acc(float(parts[1]), float(parts[2]), float(parts[3]))
    else:
        (ntri,) = struct.unpack_from("<I", data, 80)
        off = 84
        for _ in range(ntri):
            # skip normal (12 bytes), read 3 vertices (36 bytes)
            vx = struct.unpack_from("<9f", data, off + 12)
            acc(vx[0], vx[1], vx[2])
            acc(vx[3], vx[4], vx[5])
            acc(vx[6], vx[7], vx[8])
            off += 50
    return (hi[0] - lo[0], hi[1] - lo[1], hi[2] - lo[2], lo[2])


def main():
    stl_dir = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
        os.path.dirname(__file__), "..", "print", "files")
    files = sorted(glob.glob(os.path.join(stl_dir, "**", "*.stl"), recursive=True))
    if not files:
        sys.exit(f"no STL files found under {stl_dir}")

    print(f"{'part':<22}{'X':>8}{'Y':>8}{'Z':>8}  {'<=250':>5} {'grounded':>8}  check")
    print("-" * 84)
    all_ok = True
    for f in files:
        name = os.path.splitext(os.path.basename(f))[0]
        dx, dy, dz, minz = bbox(f)
        fits = max(dx, dy, dz) <= MAX_PART
        grounded = abs(minz) <= GROUND_TOL
        ok = fits and grounded
        note = ""
        exp = EXPECTED.get(name)
        if exp and exp[0] is not None:
            idx, val, label = exp
            actual = {"X": dx, "Y": dy, "Z": dz, "maxxy": max(dx, dy)}[idx]
            if val is not None:
                within = abs(actual - val) <= TOL
                ok = ok and within
                note = f"{label}: {actual:.2f} vs {val:.1f} {'OK' if within else 'FAIL'}"
        if not fits:
            note = (note + "  >250!").strip()
        if not grounded:
            note = (note + f"  FLOATING minz={minz:.2f}").strip()
        all_ok = all_ok and ok
        print(f"{name:<22}{dx:>8.2f}{dy:>8.2f}{dz:>8.2f}  "
              f"{'yes' if fits else 'NO':>5} {'yes' if grounded else 'NO':>8}  {note}")
    print("-" * 84)
    print("ALL OK" if all_ok else "SOME CHECKS FAILED")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
