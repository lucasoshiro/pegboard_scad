include <pegboard.scad>

padding = 4;

height = pin_diameter + pin_spacing_vertical + padding;
width = pin_diameter + pin_spacing_horizontal + padding;

$fn = 30;

module support() {
    translate([0, base_width, 0]) {
        rotate([90, 0, 0]) {
            linear_extrude(height=base_width) {
                polygon(points=[
                            [0, 0],
                            [height * sin(angle), 0],
                            [height * sin(angle), height * cos(angle)]
                            ]);
            }
        }
    }
}

module sample() {
    intersection() {
        union() {
            rotate([0, angle, 0]) {
                base(width, height);
            }
            translate([base_width * cos(angle), 0, -base_width * sin(angle)]) {
                support();
                translate([0, width - base_width, 0]) support();
            }
        }

        translate([-width*2, 0, 0]) cube(width * 4);
    }
}

sample();
