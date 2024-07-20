include <parameters_pegboard.scad>
include <parameters_bin.scad>
use <pegboard.scad>


module bin() {
    outer_cube = [bin_depth, bin_width, bin_height];
    inner_cube = [bin_depth - bin_thickness * 2, bin_width - bin_thickness * 2 , bin_height + 2 * epsilon];
    bottom_cube = [bin_depth / cos(angle) - 2 * bin_thickness * sin(angle), bin_width, bin_thickness];
    angle_cube = [bin_depth * 2, bin_width + 2 * epsilon, bin_height];

    difference() {
        union() {
            base(bin_width, bin_height);
            difference() {
                cube(outer_cube);
                translate([bin_thickness, bin_thickness, -epsilon]) cube(inner_cube);
            }
            translate([2*bin_thickness * sin(angle), 0 ,0]) rotate([0, -angle, 0]) cube(bottom_cube);
        }
        translate([0, -epsilon, -bin_thickness * sin(angle)]) rotate([0, 1 * (90 - angle), 0])cube(angle_cube);
    }
}

rotate([0, angle, 0]) bin();
