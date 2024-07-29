use <pegboard.scad>

hammer_spacing_width = 40;
hammer_spacing_depth = 40;

hammer_holder_border = 15;
hammer_holder_height = 50;

hammer_holder_width = hammer_spacing_width + 2 * hammer_holder_border;
hammer_holder_depth = hammer_spacing_depth + hammer_holder_border;

module hammer_support() {
    outer_cube = [hammer_holder_depth, hammer_holder_width, hammer_holder_border];
    inner_cube = [hammer_spacing_width, hammer_spacing_depth + epsilon, hammer_holder_border + 2 * epsilon];
    difference() {
        rotate([0, -angle, 0]) {
            difference() {
                cube(outer_cube);
                translate([hammer_holder_border + epsilon, hammer_holder_border, -epsilon]) cube(inner_cube);
            }
        }
        translate([-hammer_holder_border, -epsilon, 0])
            cube([hammer_holder_border, hammer_holder_width + 2 * epsilon, hammer_holder_border / cos(angle)]);
    }
}

module hammer_holder() {
    reinforcement_cube = [hammer_holder_depth * cos(angle) + base_width, hammer_holder_border, hammer_holder_depth * sin(angle)];
    difference() {
        union() {
            translate([base_width, 0, 0]) hammer_support();
            base(hammer_holder_width, hammer_holder_height);
            cube(reinforcement_cube);
            translate([0, hammer_spacing_width + hammer_holder_border, 0]) cube(reinforcement_cube);
        }
        translate([base_width, 0, 0]) {
            rotate([0, -angle, 0]){
                translate([0, -epsilon, -hammer_holder_depth * sin(angle) * cos(angle)]) {
                    cube([hammer_spacing_depth + hammer_holder_border, hammer_holder_width + 2 * epsilon, hammer_holder_depth * sin(angle) * cos(angle) + epsilon]);
                }
            }
        }
    }
}

rotate([0, angle, 0]) hammer_holder();
