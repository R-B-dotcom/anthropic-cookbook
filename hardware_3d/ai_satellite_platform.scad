// AI Satellite Platform with Robotic Module Interfaces
// Units: millimeters

$fn = 72;

module panel(length = 120, width = 80, thickness = 2.4) {
    cube([length, width, thickness], center = true);
}

module truss(length = 120, radius = 2.0) {
    rotate([0, 90, 0]) cylinder(h = length, r = radius, center = true);
}

module docking_ring(outer = 18, inner = 12, thickness = 4) {
    difference() {
        cylinder(h = thickness, r = outer/2, center = true);
        cylinder(h = thickness + 0.2, r = inner/2, center = true);
    }
}

module arm_segment(len = 35, w = 8, h = 6) {
    hull() {
        translate([-len/2, 0, 0]) cube([4, w, h], center = true);
        translate([len/2, 0, 0]) cube([4, w*0.7, h*0.7], center = true);
    }
}

module ai_satellite_platform() {
    union() {
        // Central avionics bus
        color("lightgray") cube([60, 60, 50], center = true);

        // AI processor core canister
        color("darkslategray") translate([0, 0, 8]) cylinder(h = 30, r = 16, center = true);

        // Antenna mast
        color("silver") translate([0, 0, 40]) cylinder(h = 30, r = 3, center = true);
        color("gainsboro") translate([0, 0, 56]) sphere(r = 9);

        // Solar panel wings with truss supports
        for (side = [-1, 1]) {
            color("royalblue") translate([side * 95, 0, 0]) panel(120, 80, 2.2);
            color("gray") translate([side * 50, 0, 0]) truss(80, 1.8);
            color("gray") translate([side * 50, 25, 0]) truss(80, 1.2);
            color("gray") translate([side * 50, -25, 0]) truss(80, 1.2);
        }

        // Robotic docking ports (4 radial)
        for (angle = [0, 90, 180, 270]) {
            rotate([0, 0, angle]) {
                color("orange") translate([42, 0, -8]) docking_ring(20, 13, 6);
                color("darkorange") translate([54, 0, -8]) arm_segment(22, 9, 7);
                color("orange") translate([66, 0, -8]) sphere(r = 5);
            }
        }

        // Thruster pods
        for (x = [-24, 24])
            for (y = [-24, 24]) {
                color("black") translate([x, y, -28]) cylinder(h = 10, r = 5, center = true);
                color("dimgray") translate([x, y, -33]) cylinder(h = 3, r = 3.2, center = true);
            }

        // Instrument bay (front)
        color("slategray") translate([0, 34, 6]) cube([34, 10, 14], center = true);
        color("aqua") translate([0, 39, 6]) cube([22, 2, 9], center = true);
    }
}

ai_satellite_platform();
