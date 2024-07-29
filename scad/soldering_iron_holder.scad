include <pegboard.scad>

soldering_iron_diameter = 20;
thickness = 5;
height = 50;
opening_angle = 90;

$fn = 60;

module hook() {
    rotate([0, 0, opening_angle / 2]) {
        rotate_extrude(angle = 360 - opening_angle) {
            translate([soldering_iron_diameter / 2, 0, 0]) {
                square([thickness, height]);
            }
        }
    }
}

module soldering_iron() {
    hook_width = soldering_iron_diameter + 2 * thickness;
    intersection() {
        rotate([0, 45, 0]) {
            union() {
                base(hook_width, height);
                translate([1, 1, 0] * hook_width / 2) hook();
            }
        }

        cube([base_width + hook_width, hook_width, height] * 2);
    }
}

soldering_iron();
