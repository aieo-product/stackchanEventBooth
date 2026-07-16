// mate_check.scad - review-only: two adjacent rim segments as assembled.
// MODE=0 -> boolean intersection (must be empty), MODE=1 -> assembled view.
include <../params.scad>
use <rim_segment.scad>
MODE = 1;
if (MODE == 0)
    intersection() { rim_segment(); rotate([0,0,90]) rim_segment(); }
else {
    color("gold") rim_segment();
    color("skyblue") rotate([0,0,90]) rim_segment();
}
