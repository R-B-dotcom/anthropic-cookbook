// AI Chip Compute Module - printable concept model
// Units: millimeters

$fn = 64;

module rounded_plate(length, width, height, radius) {
    hull() {
        for (x = [radius, length - radius])
            for (y = [radius, width - radius])
                translate([x, y, 0]) cylinder(h = height, r = radius);
    }
}

module mounting_hole(x, y, r = 1.6, h = 12) {
    translate([x, y, -0.1]) cylinder(h = h, r = r);
}

module bga_pad_array(cols = 10, rows = 10, pitch = 2.0, pad = 1.0, z = 1.6) {
    for (i = [0:cols-1])
        for (j = [0:rows-1])
            translate([
                20 + i * pitch,
                20 + j * pitch,
                z
            ])
                cylinder(h = 0.4, r = pad/2);
}

module fin_stack(origin = [0,0,0], count = 8, spacing = 2.2, length = 18, height = 8, thickness = 1) {
    for (i = [0:count-1])
        translate([origin[0] + i * spacing, origin[1], origin[2]])
            cube([thickness, length, height]);
}

module ai_chip_module() {
    base_l = 60;
    base_w = 60;
    base_h = 1.6;

    difference() {
        union() {
            // Substrate
            color("forestgreen") rounded_plate(base_l, base_w, base_h, 2.2);

            // Compute die package
            color("black") translate([16, 16, base_h]) cube([28, 28, 2.5]);

            // Interposer ring
            color("dimgray") difference() {
                translate([12.5, 12.5, base_h]) cube([35, 35, 1.2]);
                translate([16, 16, base_h - 0.1]) cube([28, 28, 1.5]);
            }

            // Memory stacks
            for (x = [8, 46])
                for (y = [20, 32])
                    color("navy") translate([x, y, base_h]) cube([6, 8, 3.5]);

            // Heatsink frame
            color("silver") translate([10, 10, base_h + 4]) cube([40, 40, 1.8]);
            color("gainsboro") fin_stack([13, 13, base_h + 5.8], 14, 2.3, 34, 10, 0.9);

            // Edge connector shelf
            color("gold") translate([18, -4, 0.8]) cube([24, 4, 1.8]);

            // BGA underside markers (for print reference)
            color("gold") bga_pad_array(10, 10, 2.0, 0.9, 0.0);
        }

        // Mounting holes in corners
        mounting_hole(4, 4);
        mounting_hole(56, 4);
        mounting_hole(4, 56);
        mounting_hole(56, 56);

        // Connector slot
        translate([22, -4.2, 1.0]) cube([16, 4.5, 1.2]);
    }
}

ai_chip_module();
