include <pegboard.scad>

bin_height = 100;
bin_width = 60;
bin_depth = 50;
bin_thickness = 3;

module bin(
    dimensions=[bin_depth, bin_width, bin_height],
    thickness=bin_thickness
) {
    outer_cube = dimensions;
    inner_cube = dimensions - 2 * [thickness, thickness, -epsilon];
    bottom_cube = [dimensions.x / cos(angle) - 2 * thickness * sin(angle), dimensions.y, thickness];
    angle_cube = [dimensions.z * 2, dimensions.y + 2 * epsilon, dimensions.z];

    difference() {
        union() {
            base(dimensions.y, dimensions.z);
            difference() {
                cube(outer_cube);
                translate([thickness, thickness, -epsilon])
                    cube(inner_cube);
            }

            translate([2*thickness * sin(angle), 0 ,0])
                rotate([0, -angle, 0])
                    cube(bottom_cube);
        }

        translate([0, -epsilon, -thickness * sin(angle)])
            rotate([0, 1 * (90 - angle), 0])
                cube(angle_cube);
    }
}

rotate([0, angle, 0]) bin();
