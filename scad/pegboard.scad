/* pin dimentions */
pin_diameter = 5;
pin_spacing_horizontal = 25;
pin_spacing_vertical = 25;
pin_length = 10;
pin_tip_height = 2;
pin_clearance = 0.4;

/* pegboard width */
pegboard_width = 3;
pegboard_clearance = 0.6;

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

module quarter_torus(r1, r2) {
    /* Note: this could be solved by specifying the angle as 90, but as
       Thingverse customizer has an older OpenSCAD version, we needed to do this
       workaround.
     */

    intersection() {
        torus(r1, r2);
        translate([0, 0, -(r1 + r2)]) cube((r1+r2) * 2);
    }
}

module pin_tip(diameter, height) {
    scale([1, 1, (height * 2 / diameter)])
        sphere(d=diameter);
}

module pin(
    length=pin_length,
    tip_height=pin_tip_height,
    diameter=pin_diameter,
    clearance=pin_clearance
    ) {

    diameter_ = diameter - clearance;

    union() {
        cylinder(h=length - tip_height, r=diameter_/2);
        translate([0, 0, length - tip_height]) pin_tip(diameter_, tip_height);
    }
}

module curvy_pin_old(
    length=pin_length,
    tip_height=pin_tip_height,
    diameter=pin_diameter,
    clearance=pin_clearance,
    pegboard_width=pegboard_width,
    ) {

    diameter_ = diameter - clearance;

    _pegboard_width = pegboard_width + pegboard_clearance;

    torus_outer_radius = length - _pegboard_width;
    torus_r1 = diameter_/2;
    torus_r2 = torus_outer_radius - torus_r1;

    union() {
        translate([0, 0, 0])
            cylinder(h=_pegboard_width, r=diameter_/2);

        translate([torus_outer_radius/2 - torus_r1,
                   0,
                   torus_outer_radius/2 + _pegboard_width])
            rotate([90, 0, 0])
                translate([torus_outer_radius/2, -torus_outer_radius/2, 0])
                    rotate([0, 0, 90])
                        quarter_torus(r1=torus_r1, r2=torus_r2);

        translate([torus_outer_radius-torus_r1, 0, length - diameter_/2])
            scale([(tip_height*2/diameter_), 1, 1])
                sphere(d=diameter_);
    }
}

module curvy_pin(
    length=pin_length,
    tip_height=pin_tip_height,
    diameter=pin_diameter,
    clearance=pin_clearance,
    pegboard_width=pegboard_width,
    ) {

    diameter_ = diameter - clearance;
    
    cylinder(d=diameter_, h=pegboard_width);

    torus_radius = length + tip_height - pegboard_width - diameter_;

    translate([torus_radius, 0, pegboard_width]) {
        rotate([90, 0, 180]) {
            quarter_torus(r1=diameter_/2, r2=torus_radius);
        }
    }

    translate([torus_radius, 0, torus_radius + pegboard_width])
        rotate([0, 90, 180]) pin_tip(diameter_, tip_height);
}


module pin_pair(spacing=pin_spacing_vertical + pin_clearance) {
    translate([0, pin_diameter_/2, pin_diameter_/2])
        rotate([0, -90, 0])
            union() {
                pin();
                translate([spacing, 0, 0]) curvy_pin();
        }
}

module fill_with_pin_pairs(width, height) {
    spacing_between_horizontal = pin_spacing_horizontal - pin_diameter_;
    spacing_between_vertical = pin_spacing_vertical - pin_diameter_;

    pin_count_horizontal = floor(
        (width + spacing_between_horizontal) / (pin_diameter_ + spacing_between_horizontal)
        );

    padding_horizontal = (
        width - (pin_count_horizontal * pin_diameter_ +
                 (pin_count_horizontal - 1) * spacing_between_horizontal)
        ) / 2;

    pin_count_vertical = floor(
        (height + spacing_between_vertical) / (pin_diameter_ + spacing_between_vertical)
        );

    spacing_vertical = (pin_count_vertical - 1) * pin_spacing_vertical;
    padding_vertical = (height - spacing_vertical - pin_diameter_) / 2;

    echo(pin_count_vertical);

    translate([0, padding_horizontal, padding_vertical]) {
        for (i = [1:pin_count_horizontal]) {
            translate([0, (i-1) * pin_spacing_horizontal + pin_clearance, 0])
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

