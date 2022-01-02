
PART = "test"; // ["cage", "rail", "fan_shroud", "test"]
// Select the grill style for the fan shroud.  Use custom and replace the fan_cover_custom.stl with your custom grill (see README.md for more details.)  Select none for an empty hole with an externally mounted grill cover.
grill_style = "fan_cover_web.stl"; // [fan_cover_crosshair.stl:crosshair,fan_cover_crosshex.stl:crosshex,fan_cover_grid.stl:grid,fan_cover_teardrop.stl:teardrop,fan_cover_web.stl:web,fan_cover_custom.stl:custom,fan_cover_none.stl:none]

include_fan_mount = true;

fan_grill_cover_height = 2;
shroud_h = 26;

// How much tolerance to add to the prints.  This primarily impacts the rail channels, but also has some other impacts such as the pins on the rail that plug into the hard drive.
tolerance = .2;

// How much bigger the socket should be than the ball in the hinge.  Need enough tolerance that the ball/socket move freely, but not so much that the ball won't lock into the socket.
hinge_tolerance = 0.5;

bay_h = 41.3 + tolerance;
bay_w = 146.1 + tolerance;

drive_h = 29 + tolerance; // 41 + tolerance;
drive_w = 146 + tolerance;
drive_l = 165 + tolerance;

// See https://toshiba.semicon-storage.com/us/storage/support/faq/storage-holes.html
hdd_a1  =  26.10 + 0;
hdd_a2  = 147.00 + 0;
hdd_a3  = 101.60 + 0;
hdd_a4  =  95.25 + 0;
hdd_a5  =   3.18 + 0;
hdd_a6  =  44.45 + 0;
hdd_a7  =  41.28 + 0;
hdd_a8  =  28.50 + 0;
hdd_a9  = 101.60 + 0;
hdd_a10 =   6.35 + 0;
hdd_a13 =  76.20 + 0;

// See SFF-8551
cd_a1  =  41.53 + 0;
cd_a2  =  42.30 + 0;
cd_a3  = 148.00 + 0;
cd_a4  = 202.80 + 0;
cd_a5  = 146.05 + 0;
cd_a6  = 139.70 + 0;
cd_a7  =   3.18 + 0;
cd_a8  =  79.25 + 0;
cd_a9  =  47.40 + 0;
cd_a10 =  47.40 + 0;
cd_a11 =  79.25 + 0;
cd_a13 =  10.00 + 0;
cd_a14 =  21.84 + 0;
cd_a16 =   6.50 + 0;
cd_a17 =   5.00 + 0;

hdd_h = hdd_a1 + tolerance;
hdd_w = hdd_a3 + tolerance;
hdd_l = hdd_a2 + tolerance;

cage_h = 127 + 0;
cage_w = 147 + 0; // 146;
cage_l = cd_a10 + cd_a11 + 10; // 25.4 * 5;
total_rail_height = 8 + 0;

spacing_w = 4 + 0;

// How thick the hinges are.
hinge_t = 4 + 0;
hinge_l = cage_h/6;

$fn=$preview ? 18 : 120;

module vertical_hdd(l = hdd_l) {
    translate([hdd_h, 0, 0]) {
        rotate([0, -90, 0]) {
            cube([hdd_w, l, hdd_h]);
            translate([-total_rail_height + 0.01, 0, hdd_a10])
                rotate([0, 90, 0])
                    rail(false);
            translate([hdd_w + total_rail_height - 0.01, 0, hdd_a10])
                rotate([0, -90, 0])
                    rail(false);
        }
    }
}

module caged_hdds() {
    hdds_area = cage_w - spacing_w * 2;
    hdd_area = hdds_area / 4;
    for(i = [0 : 1 : 3 ]) {
        translate([i * hdd_area + spacing_w, -1, (cage_h - hdd_w) / 2])
            vertical_hdd(hdd_l + 2);
    }
}

module rail_spacing() {
    rail = 4;
    rail_s = 3;
    offset = sqrt(2 * rail * rail)/2 - rail_s / 2;

    translate([0, 1, -rail_s/2])
        rotate([0, 45, 0])
            cube([rail, cage_l*2, rail], center=true);
    translate([-offset, 1, 0])
        cube([rail_s, cage_l * 2, rail_s], center=true);
    translate([offset, 1, 0])
        cube([rail_s, cage_l * 2, rail_s], center=true);
    translate([0, 1, rail_s/2])
        rotate([0, 45, 0])
            cube([rail, cage_l*2, rail], center=true);
}

module cage() {
    cut = 7;
    difference() {
        // main area
        union () {
            cube([cage_w, cage_l, cage_h]);
            if (include_fan_mount) {
                middle = cage_h/2;
                offset = hinge_l*2;
                translate([hinge_t/2, 0.01, middle + offset])
                    rotate([0, 90, -90])
                        hinge_socket(hinge_l, hinge_t, hinge_t, 1);
                translate([hinge_t/2, 0.01, middle])
                    rotate([0, 90, -90])
                        hinge_socket(hinge_l, hinge_t, hinge_t, 3);
                translate([hinge_t/2, 0.01, middle - offset])
                    rotate([0, 90, -90])
                        hinge_socket(hinge_l, hinge_t, hinge_t, 2);

                translate([cage_w - hinge_t/2, 0.01, cage_h/2])
                    rotate([0, 90, -90])
                        hinge_socket(cage_h, hinge_t, hinge_t, 0);
                translate([cage_w/2, 0.01, hinge_t/2])
                    rotate([0, 90, 0])
                    rotate([0, 90, -90])
                        hinge_socket(cage_w, hinge_t, hinge_t, 0);
                translate([cage_w/2, 0.01, cage_h - hinge_t/2])
                    rotate([0, 90, 0])
                    rotate([0, 90, -90])
                        hinge_socket(cage_w, hinge_t, hinge_t, 0);

                translate([hinge_t/2, 0.01, middle + offset + cage_h/12 + hinge_t])
                    rotate([0, 90, -90])
                        hinge_socket(cage_h/12 + 2, hinge_t, hinge_t, 0);
                translate([hinge_t/2, 0.01, middle - offset - cage_h/12 - hinge_t])
                    rotate([0, 90, -90])
                        hinge_socket(cage_h/12 + 2, hinge_t, hinge_t, 0);
            }
        }
        // cut off harsh corners
        translate([0, cut, 0])
            rotate([0, 45, 0])
                cube([cut, cage_l*2, cut], center=true);
        translate([cage_w, cut, 0])
            rotate([0, 45, 0])
                cube([cut, cage_l*2, cut], center=true);
        translate([0, cut, cage_h])
            rotate([0, 45, 0])
                cube([cut, cage_l*2, cut], center=true);
        translate([cage_w, cut, cage_h])
            rotate([0, 45, 0])
                cube([cut, cage_l*2, cut], center=true);
        // cut out space for bay rails
        translate([cage_w, 0, cage_h*1/3 + 1.5])
            rail_spacing();
        translate([cage_w, 0, cage_h*2/3 + 1.5])
            rail_spacing();
        translate([0, 0, cage_h*1/3 + 1.5])
            rail_spacing();
        translate([0, 0, cage_h*2/3 + 1.5])
            rail_spacing();
        // cut out center stuff
        translate([cage_w/2, cage_l/2, cage_h/2])
            cube([cage_w * .75, cage_l * 2, hdd_w], center=true);
        // cut out the hdd vertical spacing
        translate([spacing_w, 0, 0])
            caged_hdds();
        // cut out 5.25" drive mounting holes.
        mounting_d = 3.0;
        for(drive = [0 : 1 : 2]) {
            drive_offset = drive * (cd_a2 + .5);
            for(set = [0 : 1 : 1]) {
                set_offset = cd_a10 + cd_a11 * set;
                for(mount = [0 : 1 : 1]) {
                    mount_offset = mount ? cd_a13 : cd_a14;
                    translate([-10, set_offset, drive_offset + mount_offset]) {
                        rotate([0, 90, 0]) {
                            cylinder(20, d=mounting_d);
                        }
                    }
                    translate([-10 + cage_w, set_offset, drive_offset + mount_offset]) {
                        rotate([0, 90, 0]) {
                            cylinder(20, d=mounting_d);
                        }
                    }
                }
            }
        }
        // cut out routing for fan power cable.
        center_w = cage_w/2;
        center_h = cage_h/2;
        corner_w = (cage_w - spacing_w*4)/2 - 1;
        corner_h = hdd_w/2 - 1;
//        for(w = [-1 : 2 : 1]) {
// No space on the other side for cable routing.
        for(w = [-1 : 2 : -1]) {
            x = center_w + corner_w * w;
            for(h = [-1 : 2 : 1]) {
                z = center_h + corner_h * h;
                translate([x, cage_l/2, z])
                    rotate([90, 0, 0])
                        cylinder(cage_l + 2, r=3, center=true);
            }
        }
    }
}

module pin(pin_diameter, pin_length) {
    point = pin_diameter / 2;
    body = pin_length - point;

    rotate([0, 90, 0]) {
        translate([0, 0, -point/2]) {
            cylinder(h = body, d=pin_diameter, center=true);
            translate([0, 0, body/2])
                sphere(d = pin_diameter);
        }
    }
}

module clip(height, length, width) {
    angle = 20;

    translate([-width/2, 0, -height]) {
        difference() {
            rotate([angle, 0, 0])
                cube([width, length, height]);
            translate([-1, -2, height])
                cube([width * 2, length * 2, height + 2]);
            translate([-1, -length + 0.01, -0.01])
                cube([width * 2, length, height + 2]);
        }
    }
}

module handle(length, width, height, rail_height, positive=true) {
    t = tolerance;

    s1_l = length / 2;
    s2_angle = 40;
    // math to make the length of section 2 be half the
    // length of section 1.
    s2_l = (s1_l / 2) / cos(s2_angle);
    s2_x = s1_l;
    s3_l = (s1_l / 2);
    s3_z = (s1_l / 2) * tan(s2_angle);
    extension = s2_angle / 90 * height;

    clip_h = 2;
    clip_l = 6;
    clip_w = width / 3;

    if (positive == true) {
        translate([-width/2, s1_l, 0])
            cube([width, s1_l, height]);
        translate([0, s1_l + .5, 0.01])
            clip(clip_h, clip_l, clip_w);
        translate([width/2, s1_l, 0])
            rotate([s2_angle, 0, 180])
                cube([width, s2_l + extension, height]);
        translate([-width/2, 0, s3_z])
            cube([width, s3_l + extension, height]);
        translate([-width/2, 0, s3_z - 2 + height])
            cube([width, height, 2]);
    } else {
        trim = width/2+tolerance*2;
        translate([-clip_w/2, s1_l + .4, -9])
            cube([clip_w + .2, clip_l/2 + .2, 10]);
        translate([-width/2, 0, 0])
            difference() {
                cube([width, length + 8, rail_height]);
                translate([0, length, rail_height - width/2]) rotate([0, 0, 45])
                    cube([trim*2, trim, trim]);;
                translate([width, length, rail_height - width/2]) rotate([0, 0, 45])
                    cube([trim, trim*2, trim]);
            }
    }
}

module rail(positive=true) {
    pin_len = 6;
    pin_d = 2.7 - tolerance; //.1140 * 25.4;
    t = (positive) ? 0 : tolerance * 2;
    top_width = (pin_d > 3) ? pin_d + t: 3 + t;
    top_height=total_rail_height / 3 + t;
    bottom_width= (positive) ? (hdd_a10 - tolerance) * 2 : hdd_a10*2;
    bottom_height=total_rail_height * 2 / 3 + t;
    total_height=top_height + bottom_height;
    top_y = (top_height + bottom_height)/2;
    mid_y = top_y - top_height;
    bottom_y = -top_y;
    
    main_length = 4 * 25.4;
    main_rail_offset = hdd_a2 - hdd_a8 - hdd_a9 - pin_d/2;

    //  A_|_B
    //C /   \D
    //E|_____|F
    points = [
        [-top_width/2, top_y], // A
        [top_width/2, top_y], // B
        [bottom_width/2, mid_y], // D
        [bottom_width/2, bottom_y], // F
        [-bottom_width/2, bottom_y], // E
        [-bottom_width/2, mid_y], // C
    ];
    faces = [[0, 1, 2, 3, 4, 5]];

    echo("main_rail_offset = ", main_rail_offset);
    translate([0, main_rail_offset, -bottom_y]) {
        rotate([90, 0, 180]) 
            linear_extrude(main_length + pin_d)
                polygon(points, faces);
    }
    if (positive) {
        translate([0, main_rail_offset, total_height + pin_len/2-0.01]) {
        translate([0, pin_d/2, 0])
            rotate([0, -90, 0])
                pin(pin_d, pin_len);
        translate([0, main_length + pin_d/2, 0])
            rotate([0, -90, 0])
                pin(pin_d, pin_len);
        }
    }
    handle(main_rail_offset, bottom_width, 1, total_height, positive);
}

module hinge(widthX, depthY, heightZ) {
    top_arch = depthY / 2;
    bottom_square = heightZ - top_arch;
    translate([0, 0, heightZ / 2])
        rotate([0, -90, 0])
            linear_extrude(widthX, center=true) {
                translate([(heightZ - depthY)/2, 0, 0]) circle(d=depthY);
                translate([(-heightZ + bottom_square)/2, 0, 0])
                square([bottom_square, depthY], center = true);
            }
}

// balls = 1 just left side
// balls = 2 just right side
// balls = 3 both sides
module hinge_ball(widthX, depthY, heightZ, balls = 3) {
    ball_diameter = depthY - .25;

    hinge(widthX, depthY, heightZ);
    if ((balls == 1) || (balls == 3)) {
        translate([widthX/2 - depthY/5, 0, heightZ - ball_diameter / 2])
            sphere(d=ball_diameter);
    }
    if ((balls == 2) || (balls == 3)) {
        translate([-(widthX/2 - depthY/5), 0, heightZ - ball_diameter / 2])
            sphere(d=ball_diameter);
    }
}

// sockets = 1 just left side
// sockets = 2 just right side
// sockets = 3 both sides
module hinge_socket(widthX, depthY, heightZ, sockets = 3) {
    socket_diameter = depthY - .5 + hinge_tolerance;
    
    difference() {
        hinge(widthX, depthY, heightZ);
        if ((sockets == 1) || (sockets == 3)) {
            translate([widthX/2 + depthY/5, 0, heightZ - socket_diameter / 2])
                sphere(d=socket_diameter);
        }
        if ((sockets == 2) || (sockets == 3)) {
            translate([-(widthX/2 + depthY/5), 0, heightZ - socket_diameter / 2])
                sphere(d=socket_diameter);
        }
    }
}

module fan_shroud() {
    shroud_t = hinge_t;
    outer_wall = cage_h - 119;

    import(grill_style);
    translate([0, 0, shroud_h/2]) {
        difference() {
            cube([cage_w, cage_h, shroud_h], center=true);
            cube([119, 119, shroud_h + 10], center=true);
            translate([0, 0, fan_grill_cover_height + 2])
            cube([cage_w - outer_wall, 120, shroud_h], center=true);
            
        }

        hinge_x = -cage_w/2 + hinge_t/2;
        hinge_l = cage_h/6 - hinge_tolerance;
        translate([hinge_x, cage_h / 6, shroud_h/2 - 0.05])
            rotate([0, 0, 90])
                hinge_ball(hinge_l, shroud_t, shroud_t);
        translate([hinge_x, -cage_h / 6, shroud_h/2 - 0.05])
            rotate([0, 0, 90])
                hinge_ball(hinge_l, shroud_t, shroud_t);
        }
}

if (PART == "cage") {
    translate([0, 0, cage_l])
        rotate([-90, 0, 0])
            cage();
} else if (PART == "rail") {
    translate([0, 0, total_rail_height*3/4])
        rotate([0, 90, 0])
            rail();
} else if (PART == "fan_shroud") {
    fan_shroud();
} else if (PART == "test") {
    translate([-cage_w/2 + 10, 0, cage_l]) {
        difference() {
            rotate([-90, 0, 0]) {
                cage();
            }
            translate([-hdd_h*1.25-5, -5, -cage_l-10])
                cube([cage_w+10, cage_h+10, cage_l+50]);
            translate([10, -10, -cage_l-10])
                cube([cage_w+10, cage_h - total_rail_height/2, cage_l + 50]);
        }
    }
    cage_face_h = 5;
    translate([0, cage_w, cage_face_h]) {
        rotate([0, 0, -90]){
            difference() {
                rotate([-90, 0, 0]) {
                    cage();
                }
                translate([-10, -10, -cage_l - 1]) {
                    cube([cage_w+20, cage_h+20, cage_l - cage_face_h + 1]);
                }
            }
        }
    }
    translate([cage_w / 2 - 10, cage_w * 1.6, -(shroud_h - 9)]) {
        rotate([0, 0, 90]) {
            difference() {
                fan_shroud();
                translate([-10, 5, (shroud_h - 10)/2])
                    cube([cage_w + 10, cage_h + 20, shroud_h - 8], center=true);
                translate([10, 0, shroud_h / 2])
                    cube([cage_w-10, cage_h+20, shroud_h + 5], center=true);
            }
        }
    }
    translate([20, 15, total_rail_height*3/4]) {
        rotate([0, 90, 0]) {
            rail();
        }
    }
} else {
    translate([0, 0, 30])
        handle(15.525, 15, 1.5, total_rail_height, true);
    translate([-20, 0, 30])
        translate([-total_rail_height, 0, 0])
            handle(15.525, 15, 1.5, total_rail_height, false);

    translate([cage_w/2 + 20, -hinge_t*2 - 26, cage_h/2])
        rotate([-90, 0, 0])
            fan_shroud();
    translate([20, 0, 0])
        cage();
    translate([0, 0, total_rail_height*3/4])
        rotate([0, 90, 0])
            rail();
    translate([-20, 0, hdd_a5 + (.1380 * 25.4)/2])
        rotate([0, 90, 0])
            rail(false);
}
