include <pegboard.scad>

reel_thickness = 5;
reel_spacing = 30;
reel_border = 30;
border_radius = 4;

inner_radius = 20;

$fn = 60;

module reel_top_shape() {
    minkowski() {
        polygon(
            points=[
                [border_radius, border_radius],
                [reel_thickness - border_radius, border_radius],
                [reel_thickness - border_radius, reel_spacing + border_radius],
                [reel_thickness + reel_border - border_radius, reel_spacing + border_radius],
                [reel_thickness + reel_border - border_radius, reel_spacing + reel_thickness - border_radius],
                [border_radius, reel_spacing + reel_thickness - border_radius],
                ]
            );

        circle(r=border_radius);
    }

    square(reel_thickness);
}

module reel_top() {
    rotate_extrude() {
        translate([inner_radius, 0, 0]) {
            reel_top_shape();
        }
    }
}

module reel() {
    width = (reel_thickness + reel_border + inner_radius) * 2;
    intersection() {
        rotate([0, 45, 0]) {
            base(width, width);
            translate([0, 1, 1] * width / 2)rotate([0, 90, 0]) reel_top();
        }
        translate([-width*2, 0, 0]) cube(width * 4);
    }
}

reel();

