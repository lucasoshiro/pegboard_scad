include <pegboard.scad>

open_front_bin_height = 95;
open_front_bin_width = 127;
open_front_bin_depth = 33;
open_front_bin_thickness = 3;

open_front_bin_opening_width = 108;
open_front_bin_opening_height = 70;

module open_front_bin(
    dimensions=[
        open_front_bin_depth,
        open_front_bin_width,
        open_front_bin_height
        ],

    opening_dimensions=[
        0,
        open_front_bin_opening_width,
        open_front_bin_opening_height
        ],

    thickness=open_front_bin_thickness,
    ) {

    outer_cube = dimensions;

    inner_cube = dimensions - 2 * [thickness, thickness, -epsilon];

    bottom_cube = [
        dimensions.x / cos(angle) - 2 * thickness * sin(angle),
        dimensions.y,
        thickness
        ];

    angle_cube = [
        dimensions.x * 2,
        dimensions.y + 2 * epsilon,
        dimensions.z
        ];

    opening_cube = [thickness + 2 * epsilon, 0, 0] + opening_dimensions;

    difference() {
        union() {
            base(dimensions.y, dimensions.z);

            difference() {
                cube(outer_cube);
                translate(
                    [
                        thickness,
                        thickness,
                        -epsilon
                        ]
                    )
                    cube(inner_cube);

                translate(
                    [
                        dimensions.x - thickness - epsilon,
                        dimensions.y / 2 - opening_dimensions.y / 2,
                        dimensions.z - opening_dimensions.z + epsilon
                        ]
                    )
                    cube(opening_cube);
            }


            translate(
                [
                    2*thickness * sin(angle),
                    0 ,
                    0
                    ]
                ) {
                rotate([0, -angle, 0])
                    cube(bottom_cube);
            }
        }
 
       translate(
           [
               0,
               -epsilon,
               -thickness * sin(angle)
               ]
           ) {

           rotate([0, 1 * (90 - angle), 0])
               cube(angle_cube);
       }
    }
}

rotate([0, angle, 0]) open_front_bin();
