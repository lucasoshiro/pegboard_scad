include <parameters_pegboard.scad>
include <parameters_pliers_holder.scad>
use <pegboard.scad>

module pliers_support() {
    outer_cube = [
        pliers_holder_internal_space + 2 * pliers_holder_thickness,
        pliers_holder_length,
        pliers_holder_thickness
        ];

    inner_cube = [
        pliers_holder_internal_space,
        pliers_holder_length - 2 * pliers_holder_thickness,
        2 * epsilon + pliers_holder_thickness
        ];

    difference() {
        cube(outer_cube);
         translate([pliers_holder_thickness, pliers_holder_thickness, -epsilon]) cube(inner_cube);
    }
}

module pliers_holder() {
    reinforcement = pliers_holder_internal_space + 0*base_width + 2 * pliers_holder_thickness;
    union() {
        difference() {
            union() {
                rotate([0, angle, 0]) base(pliers_holder_length, pliers_holder_height);
                rotate([0, angle, 0]) {
                    cube([cos(angle) * reinforcement, pliers_holder_thickness, sin(angle) * reinforcement]);
                    translate([0, pliers_holder_length - pliers_holder_thickness, 0])
                        cube([cos(angle) * reinforcement, pliers_holder_thickness, sin(angle) * reinforcement]);
                }
            }

            translate([-epsilon, -epsilon, - 2 * pliers_holder_height])
                cube([2 * pliers_holder_height, pliers_holder_length + 2 * epsilon, 2 * pliers_holder_height]);
        }
        difference() {
            pliers_support();
            rotate([0, angle, 0]) translate([base_width - pin_length, -epsilon, 0])
            cube([pin_length, pliers_holder_length + 2 * epsilon, 2 * pliers_holder_height]);
        }
    }
}

pliers_holder();
/* pliers_support(); */
