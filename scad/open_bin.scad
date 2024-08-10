include <pegboard.scad>

open_bin_height = 100;
open_bin_width = 60;
open_bin_depth = 50;
open_bin_thickness = 3;

module open_bin(
    dimensions=[open_bin_depth, open_bin_width, open_bin_height],
    thickness=open_bin_thickness
    ) {
    outer_cube = dimensions;
    inner_cube = dimensions - 2 * [thickness, thickness, -epsilon];
    angle_cube = [dimensions.z * 2, dimensions.y + 2 * epsilon, dimensions.z];

    difference() {
        union() {
            base(dimensions.y, dimensions.z);
            difference() {
                cube(outer_cube);
                translate([thickness, thickness, -epsilon])
                    cube(inner_cube);
            }
        }

        translate([0, -epsilon, -thickness * sin(angle)])
            rotate([0, 1 * (90 - angle), 0])
                cube(angle_cube);
    }
}

rotate([0, angle, 0]) open_bin();
