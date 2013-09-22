// byteborg's direct drive extruder 0.2
// License: CC NC-BY-SA 3.0
// "parts that don't exist can't break"

include <MCAD/constants.scad>
include <MCAD/motors.scad>
include <MCAD/nuts_and_bolts.scad>
use <ruler.scad>

FILAMENT = 3;  // 3mm filament

CANAL_DIA = (FILAMENT+1);

NEMA_BOLT_DIST = 1.220*mm_per_inch;
NEMA_BOLT_DIA = 3.6;
NEMA_PILOT_DIA = 0.866*mm_per_inch;
NEMA_DIM = NEMA_BOLT_DIST + NEMA_BOLT_DIA + 5 + 4; // see motors.scad, too small
MOUNT_THICK = 5;

BASE_X = 70;
BASE_Y = NEMA_DIM;
BASE_THICK = 7;

FEED_PLATE_X = 15+2;
FEED_BASE_DIA = 15;
FEED_BASE_Z = 5;
FEED_OFFSET = 6/2+3/2;  // hobbed bolt + filament

P_X = 15; // pressure clamp overall part thickness in motor-axis direction
P_Y = 8; // spring lever thickness
P_KY = 13; // bearing lever thickness
P_VIS_ANGLE = 18; // angle in visualization, adjust until bearing touches filament
P_A = 60+P_VIS_ANGLE; // lever angle
P_K = NEMA_BOLT_DIST/2-2; // bearing lever length
P_L = NEMA_BOLT_DIST+P_Y/2;  // lever length

BB_X = FEED_PLATE_X+FEED_OFFSET*2; //16+4;
BB_Y = 5+1;
BB_Z = NEMA_DIM/2+BB_X/2;

SPRING_DIA = 10;
M3_DIA = 3.6;
M4_DIA = 4.6;
M4_HEAD = 7.5;
M5_DIA= 5.6;

S_ROUND = (NEMA_DIM-NEMA_BOLT_DIST); // final shape corner rounding radius

q=.001;

// plate
%ruler();
main();
translate([BASE_X+S_ROUND, -S_ROUND, 0]) rotate([0, -90, -60-90]) pressure();
translate([20, -20, 0]) rotate([0, 0, -45])  bearing_clip();

// pressure for visualization
%translate([BASE_X/2-P_X/2, NEMA_DIM/2+NEMA_BOLT_DIST/2, NEMA_DIM/2+BASE_THICK+NEMA_BOLT_DIST/2]) pressure(1);


module main() {
    difference() {
        union () {
            base();
            translate([BASE_X/2-10, BASE_Y/2, NEMA_DIM/2+BASE_THICK]) {
                //%rotate([0, 90, 0]) stepper();
                motor_mount();
            }
        }
        translate([0, FEED_OFFSET, 0]) {
            // hotend mount
            translate([BASE_X/2, BASE_Y/2, BASE_THICK+1]) rotate([180, 0, 0])
                peek_reprapsource_holes();
            // filament canal
            translate([BASE_X/2, BASE_Y/2, 0]) {
                %cylinder(r=FILAMENT/2, h=200, center=true, $fn=16);  // filament
                cylinder(r=CANAL_DIA/2, h=200, center=true, $fn=64);  // round hole!
            }
        }
        shape_x();
        shape_z();
        // patch for nema17 pilot
        translate([BASE_X/2-13, BASE_Y/2, NEMA_DIM/2+BASE_THICK])
        rotate([0, 90, 0]) cylinder(r=NEMA_PILOT_DIA/2+.5, h=10, center=true);
    }
}



module shape_x() {
    translate([0, NEMA_DIM/2, BASE_THICK+NEMA_DIM/2])
    difference() {
        cube(size=[300, 300, 300], center=true);
        hull() {
            for(i=[0, 1])
            mirror([0, i, 0]) {
                translate([0, -NEMA_BOLT_DIST/2, NEMA_BOLT_DIST/2]) {
                    rotate([0, 90, 0])
                    cylinder(r=S_ROUND/2, h=200, center=true, $fn=16);
                    translate([0, 10, -10+S_ROUND/2]) cube(size=[200, 20, 20], center=true);
                    translate([0, 10-S_ROUND/2, -100]) cube(size=[200, 20, 200], center=true);
                }
            }
        }
    }
}

module shape_z() {
    translate([BASE_X/2, BASE_Y/2, 0])
    difference() {
        cube(size=[200, 200, 200], center=true);

        linear_extrude(height=300, center=true)
        minkowski() {
            square([BASE_X-S_ROUND, BASE_Y-S_ROUND], center=true);
            circle(r=S_ROUND/2, center=true, $fn=16);
        }
        // hull() {
        //     for(i=[-1,1]) {
        //         translate([(BASE_X-BASE_Y)/2*i, 0, 0])
        //         rotate([0, 0, 360/48/2])
        //         cylinder(r=BASE_Y/2, h=201, center=true, $fn=48);
        //     }
        // }
    }
}

module motor_mount() {
    difference() {
        translate([MOUNT_THICK/2, 0, -NEMA_DIM/2+NEMA_DIM/4.5/2])
            cube(size=[MOUNT_THICK, NEMA_DIM, NEMA_DIM/4.5], center=true);
        // union() {
        //     //translate([20, NEMA_DIM/2, NEMA_DIM/2])
        //     rotate([0, 90, 0])
        //     linear_extrude(height=MOUNT_THICK) {
        //         minkowski() {
        //             square(size=[NEMA_DIM-5, NEMA_DIM-5], center=true);
        //             circle(r=5/2, center=true, $fn=4);
        //         }
        //     }
        //     translate([MOUNT_THICK/2, 0, -NEMA_DIM/2+10/2])
        //         cube(size=[MOUNT_THICK, NEMA_DIM, 10], center=true);
        // }
        // // pilot hole
        // translate([-5, 0, 0]) rotate([0, 90, 0])
        // linear_extrude(height=BASE_THICK*2) {
        //     minkowski() {
        //         square(size=[NEMA_PILOT_DIA-5+2, NEMA_PILOT_DIA-5+2], center=true);
        //         circle(r=5/2, center=true, $fn=4);
        //     }
        // }
        // mounting holes
        for (x=[-1, 1]) for (y=[-1, 1]) {
            translate([0, NEMA_BOLT_DIST/2*x, NEMA_BOLT_DIST/2*y])
            rotate([0, 90, 0])
            cylinder(r=NEMA_BOLT_DIA/2, h=50, center=true, $fn=8);
        }
    }
}


module pressure() {
    // %translate([P_X, 0, 0]) {
    //     rotate([180, 0, 180])
    //         cube(size=[P_X, P_Y, NEMA_DIM/2]);
    //     rotate([0, -45, 90])
    //         cube(size=[P_Y, P_X, P_L]);
    // }
    rotate([90, P_VIS_ANGLE, 90]) {
        difference() {
            union() {
                linear_extrude(height=P_X) {
                    union() {
                        polygon(
                            points=[
                                [0, 0],
                                [0, -P_K],
                                [P_KY, -P_K],
                                [P_KY, 0],
                                [cos(P_A)*P_Y, sin(P_A)*P_Y],
                                [cos(P_A)*P_Y-cos(90-P_A)*P_L, sin(P_A)*P_Y+sin(90-P_A)*P_L],
                                [-cos(90-P_A)*P_L, sin(90-P_A)*P_L]
                            ]
                        );
                        // containment for mounting screw
                        circle(r=5, $fn=32);
                        // round bearing end
                        translate([P_KY/2, -P_K, 0]) circle(r=P_KY/2, $fn=32);
                    }
                }
            }
            // bearing
            translate([P_KY/2, -P_K, P_X/2-7/2]) {
                %608zz();
                608zz(1);
                cylinder(r=7.9/2, h=40, center=true); // tight fit!
            }
            // screw to motor
            cylinder(r=NEMA_BOLT_DIA/2, h=40, center=true, $fn=12);
            // spring hole
            rotate([0, 0, -90+P_A])
            translate([-P_L+P_Y, 0, P_X/2])
            rotate([90, 0, 0]) {
                cylinder(r=SPRING_DIA/2, h=7, center=true);
                cylinder(r=M4_DIA/2*1.2, h=40, center=true, $fn=16);
            }
            // filament canal
            translate([-NEMA_BOLT_DIST/2+FEED_OFFSET-1, 0, P_X/2]) rotate([0, 90, 90+P_VIS_ANGLE])
                translate([0, -1, -50])
                linear_extrude(height=100)
                hull() {
                    for(i=[-1,1]) translate([0, 2*i, 0])
                    circle(r=CANAL_DIA/2, $fn=16);
                }
                // cylinder(r=CANAL_DIA/2, h=100, center=true);
        }
    }
}

SPB_Z = NEMA_DIM;
SPB_Y = NEMA_DIM/4.5;

module base() {
    difference() {
        union() {
            cube(size=[BASE_X, BASE_Y, BASE_THICK+q]);
            translate([BASE_X/2, BASE_Y/2+FEED_OFFSET, BASE_THICK-q]) {
                difference() {
                    union() {
                        // feed plate
                        translate([0, 0, NEMA_DIM/2])
                            // rotate([0, 0, 0]) cylinder(r=FEED_PLATE_X/2, h=NEMA_DIM, center=true);
                            cube(size=[FEED_PLATE_X, FEED_PLATE_X, NEMA_DIM], center=true);
                        // feed base
                        translate([0, 0, FEED_BASE_Z/2-q])
                        cylinder(r1=FEED_BASE_DIA/2, r2=FEED_PLATE_X/2, h=FEED_BASE_Z, center=true);
                        hull() {
                            // bearing block
                            // translate([FEED_PLATE_X/2+BB_Y/2, -FEED_OFFSET, BB_Z/2])
                            // cube(size=[BB_Y, BB_X, BB_Z], center=true);
                            // spring block pillar bearing side
                            translate([FEED_PLATE_X/2+BB_Y/2, -FEED_OFFSET-(BASE_Y-SPB_Y)/2, SPB_Z/2])
                            cube(size=[BB_Y, SPB_Y, SPB_Z+q], center=true);
                            translate([FEED_PLATE_X/2+BB_Y/2, -FEED_OFFSET+(BASE_Y-SPB_Y)/2, SPB_Z/2])
                            cube(size=[BB_Y, SPB_Y, SPB_Z+q], center=true);
                        }
                        // spring block pillar motor side
                        translate([-10+MOUNT_THICK/2, -FEED_OFFSET-NEMA_DIM/2+NEMA_DIM/4.5/2, NEMA_DIM/2])
                        cube(size=[MOUNT_THICK, NEMA_DIM/4.5, NEMA_DIM], center=true);
                        // spring block
                        translate([BB_Y/2, -FEED_OFFSET-NEMA_DIM/2+NEMA_DIM/4.5/2, NEMA_DIM-NEMA_DIM/4.5/2])
                        cube(size=[FEED_PLATE_X+BB_Y, NEMA_DIM/4.5, NEMA_DIM/4.5], center=true);
                    }
                    // space on transport side
                    translate([0, -FEED_OFFSET, NEMA_DIM/2]) rotate([0, 90, 0]) {
                        cylinder(r=10/2, h=20, center=true);  // hobbed bolt
                        cylinder(r=5/2+.5, h=100, center=true);  // motor axle
                        translate([0, 0, -9]) cylinder(r=14/2, h=10, center=true);  // groove for set screw
                    }
                    // space for pressure side
                    translate([-(7.7+3/2)/2, FEED_PLATE_X/2+6/2+3/2-0, NEMA_DIM/2]) rotate([0, 90, 0])
                    hull() 608zz(3);
                    translate([-P_X/2, -FEED_OFFSET+NEMA_BOLT_DIST/2, NEMA_DIM/2+NEMA_BOLT_DIST/2])
                    scale(1.065)
                    hull()pressure();
                    // bearing
                    translate([FEED_PLATE_X/2+1, -FEED_OFFSET, NEMA_DIM/2]) rotate([0, 90, 0])
                    hull() 625zz(.3);

                    // cutaway = half - hobbed bolt r
                    translate([0, 0, NEMA_DIM-10/2]) cube(size=[FEED_PLATE_X+q, FEED_PLATE_X+q, NEMA_DIM], center=true);
                    // motor mount screws, fugly hack
                    translate([0, -FEED_OFFSET, NEMA_DIM/2])
                    for (x=[-1, 1]) for (y=[-1, 1]) {
                        translate([0, NEMA_BOLT_DIST/2*x, NEMA_BOLT_DIST/2*y])
                        rotate([0, 90, 0])
                        cylinder(r=NEMA_BOLT_DIA/2, h=150, center=true, $fn=8);
                    }
                    // spring hole -- FIXME: placed pseudo-manually
                    translate([0, -FEED_OFFSET+NEMA_BOLT_DIST/2, NEMA_DIM/2+NEMA_BOLT_DIST/2])
                    rotate([-P_VIS_ANGLE-90+P_A, 0, 0])
                    translate([0, -NEMA_BOLT_DIST+P_Y/2, -9])
                    cylinder(r=M4_HEAD/2, h=10, $fn=16, center=true);
                }
            }
        } // union
        // screw holes
        translate([BASE_X/2, BASE_Y/2, BASE_THICK/2])
        for (i=[-1,1]) {
            translate([50/2*i, 0, 0]) {
                cylinder(r=M5_DIA/2, h=BASE_THICK+2, center=true, $fn=16);
                translate([0, 0, BASE_THICK/2-METRIC_NUT_THICKNESS[5]])
                rotate([0, 0, 60/2]) scale([1,1,2]) nutHole(4, tolerance=.1);
                // cylinder(r=M5_DIA/2+3, h=BASE_THICK, center=true);
            }
        }
    } // diff
}

%translate([FEED_PLATE_X+BASE_X/2, BASE_Y/2, BASE_THICK+NEMA_DIM/2]) rotate([0, 90, 0]) bearing_clip();

module bearing_clip() {
    difference() {
        hull() {
            linear_extrude(height=4){
                circle(r=24/2, $fn=96);
                for (m=[1, -1]) {
                    translate([m*NEMA_BOLT_DIST/2, m*NEMA_BOLT_DIST/2, 0]) {
                        circle(r=11/2, $fn=32);
                    }
                }
            }
        }
        cylinder(r=12/2, h=10, center=true, $fn=64);
        for (m=[1, -1]) {
            translate([m*NEMA_BOLT_DIST/2, m*NEMA_BOLT_DIST/2, 0]) {
                cylinder(r=NEMA_BOLT_DIA/2, h=150, center=true, $fn=8);
                translate([0, 0, 4]) cylinder(r=7/2, h=4, center=true, $fn=32);
            }
        }
    }
}

module stepper() {
    stepper_motor_mount(17);
    // hobbed bolt
    translate([0, 0, 13/2+1.5]) difference() {
        cylinder(r=8/2, h=13, center=true);
        translate([0, 0, 13/2-4.5])
        rotate_extrude()
        translate([6, 0, 0])
        circle(r=6/2, $fn=16, center=true);
    }
}

module 608zz(beef=0) {
    linear_extrude(height=7+beef)
    difference() {
        circle(r=(22+beef)/2);
        circle(r=(8-beef)/2);
    }
}

module 625zz(beef=0) {
    linear_extrude(height=5+beef)
    difference() {
        circle(r=(16+beef)/2);
        circle(r=(5-beef)/2);
    }
}

module peek_reprapsource_holes ()
{
    extruder_recess_d=10.8;
    extruder_recess_h=20;
    m3_diameter = 3.6;
    base_thickness = BASE_THICK;
    wade_block_depth = BASE_Y;

    // Recess in base
    translate([0,0,-1])
    cylinder(r=extruder_recess_d/2,h=extruder_recess_h+1);

    // Mounting holes to affix the extruder into the recess.
    translate([5,0,min(extruder_recess_h/2, base_thickness-2)])
    rotate([-90,0,0])
    cylinder(r=m3_diameter/2-0.5,/*tight*/,h=wade_block_depth+2,center=true);
    translate([-5,0,min(extruder_recess_h/2, base_thickness-2)])
    rotate([-90,0,0])
    cylinder(r=m3_diameter/2-0.5,/*tight*/,h=wade_block_depth+2,center=true);

    //cylinder(r=m4_diameter/2-0.5/* tight */,h=wade_block_depth+2,center=true);
}


//.
