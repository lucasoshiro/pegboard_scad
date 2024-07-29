/* pin dimentions */
pin_diameter = 5;
pin_spacing = 25;
pin_length = 10;
pin_tip_height = 2;
pin_clearance = 1;

/* pegboard width */
pegboard_width = 3;

/* base width */
base_width = 3;

/* angle */
angle = 30;

/* DON'T TOUCH BELOW HERE! Internal values! */
epsilon = 0.1;
pin_diameter_ = pin_diameter - pin_clearance;


module torus(r1, r2, angle=360) {
    rotate_extrude(angle=angle) translate([r2, 0, 0]) circle(r=r1);
}

module pin() {
    union() {
        cylinder(h=pin_length - pin_tip_height, r=pin_diameter_/2);
        translate([0, 0, pin_length - pin_tip_height])
            scale([1, 1, (pin_tip_height * 2 / pin_diameter_)])
                sphere(d=pin_diameter_);
    }
}

module curvy_pin() {
    torus_outer_radius = pin_length - pegboard_width;
    torus_r1 = pin_diameter_/2;
    torus_r2 = torus_outer_radius - torus_r1;

    union() {
        translate([0, 0, 0])
            cylinder(h=pegboard_width, r=pin_diameter_/2);

        translate([torus_outer_radius/2 - torus_r1,
                   0,
                   torus_outer_radius/2 + pegboard_width])
            rotate([90, 0, 0])
                translate([torus_outer_radius/2, -torus_outer_radius/2, 0])
                    rotate([0, 0, 90])
                        torus(r1=torus_r1, r2=torus_r2, angle=90);

        translate([torus_outer_radius-torus_r1 + 0*pegboard_width/2, 0, pin_length - pin_diameter_/2])
            scale([(pin_tip_height*2/pin_diameter_), 1, 1])
                sphere(d=pin_diameter_);
    }
}

module pin_pair(spacing=pin_spacing + pin_clearance) {
    translate([0, pin_diameter_/2, pin_diameter_/2])
        rotate([0, -90, 0])
            union() {
                pin();
                translate([spacing, 0, 0]) curvy_pin();
        }
}

module fill_with_pin_pairs(width, height) {
    spacing_between = pin_spacing - pin_diameter_;

    pin_count_horizontal = floor((width + spacing_between) / (pin_diameter_ + spacing_between));
    padding_horizontal = (width - (pin_count_horizontal * pin_diameter_ + (pin_count_horizontal - 1) * spacing_between)) / 2;

    pin_count_vertical = floor((height + spacing_between) / (pin_diameter_ + spacing_between));
    spacing_vertical = (pin_count_vertical - 1) * pin_spacing;
    padding_vertical = (height - spacing_vertical - pin_diameter_) / 2;

    translate([0, padding_horizontal, padding_vertical]) {
        for (i = [1:pin_count_horizontal]) {
            translate([0, (i-1) * pin_spacing + pin_clearance, 0])
                pin_pair(spacing_vertical + pin_clearance);
        }
    }
}

module base(width, height) {
    union(){
        cube([base_width, width, height]);
        fill_with_pin_pairs(width, height);
    }
}


