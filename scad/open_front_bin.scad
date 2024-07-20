include <parameters_pegboard.scad>
include <parameters_open_front_bin.scad>
use <pegboard.scad>


module open_front_bin() {
    outer_cube = [
        open_front_bin_depth,
        open_front_bin_width,
        open_front_bin_height
        ];

    inner_cube = [
        open_front_bin_depth - open_front_bin_thickness * 2,
        open_front_bin_width - open_front_bin_thickness * 2 ,
        open_front_bin_height + 2 * epsilon
        ];

    bottom_cube = [
        open_front_bin_depth / cos(angle) - 2 * open_front_bin_thickness * sin(angle),
        open_front_bin_width,
        open_front_bin_thickness
        ];

    angle_cube = [
        open_front_bin_depth * 2,
        open_front_bin_width + 2 * epsilon,
        open_front_bin_height
        ];

    opening_cube = [
        open_front_bin_thickness + 2 * epsilon,
        open_front_bin_opening_width,
        open_front_bin_opening_height
        ];

    difference() {
        union() {
            base(open_front_bin_width, open_front_bin_height);

            difference() {
                cube(outer_cube);
                translate(
                    [
                        open_front_bin_thickness,
                        open_front_bin_thickness,
                        -epsilon
                        ]
                    )
                    cube(inner_cube);

                translate(
                    [
                        open_front_bin_depth - open_front_bin_thickness - epsilon,
                        open_front_bin_width / 2 - open_front_bin_opening_width / 2,
                        open_front_bin_height - open_front_bin_opening_height + epsilon
                        ]
                    )
                    color("yellow")cube(opening_cube);
            }


            translate(
                [
                    2*open_front_bin_thickness * sin(angle),
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
               -open_front_bin_thickness * sin(angle)
               ]
           ) {
           rotate([0, 1 * (90 - angle), 0])
               cube(angle_cube);
       }
    }
}

rotate([0, angle, 0]) open_front_bin();
