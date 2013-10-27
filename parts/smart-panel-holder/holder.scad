// holder block for graphic lcd controller
// Copyright 2013 Karsten W. Rohrbach
// karsten@rohrbach.de
// CC-BY-NC 3.0

$fa = 4;
$fs = .1;

module scaffold() {
    rotate([180, 0, 0])
    translate([-168, -150, -13]) import("bottomcase.stl");  // put in place from thing:87250
}


module ear() {
    difference() {
        union() {
            cylinder(r=15, h=7, center=true);
            // translate([-15, -15/2, 0]) cube(size=[30, 15, 7], center=true);
            translate([-40, -15, 7/2]) rotate([180, 0, 90])
            linear_extrude(height=7) polygon(
                points=[
                    [0,0],
                    [0,40],
                    [24,40]
                ],
                paths=[[0,1,2,0]]
            );
        }
        rotate([0, 0, 40]) {
            cylinder(r=9/2, h=10, center=true);
            translate([0, 9, 0]) cube(size=[9, 20, 20], center=true);
        }
    }
}
// ear();

module fin() {
    difference() {
        union() {
            translate([0, 0, (15+9/2)/2]) cube(size=[7, 20, (15+15+9/2)], center=true);
            translate([0, -10, 0]) rotate([0, 90, 0]) cylinder(r=(15+15), h=7, center=true);
            translate([0, 10, 0]) rotate([0, 90, 0]) cylinder(r=(15+15), h=7, center=true);
        }
        translate([0, 0, -50]) cube(size=[100, 100, 100], center=true);
        translate([0, 0, 15+15]) rotate([90, 0, 0]) cylinder(r=9/2, h=200, center=true);
        translate([0, -15, 0]) rotate([0, 90, 0]) scale([1, .5, 1]) cylinder(r=18, h=10, center=true);
        translate([0, 15, 0]) rotate([0, 90, 0]) scale([1, .5, 1]) cylinder(r=18, h=10, center=true);
    }
    %translate([0, 0, 15+15]) rotate([90, 0, 0]) cylinder(r=9/2, h=200, center=true);
}
// fin();

module holder() {
    difference() {
        union() {
            translate([8/2, 8/2, 0]) minkowski() {
                cube(size=[108-8, 95-8, 3-1]);
                cylinder(r=8/2, h=1, center=true);
            }
            translate([100, -10, 15-.5]) rotate([90, 0, -90]) ear();
            translate([24.5, -10, 15-.5]) rotate([90, 0, -90]) ear();
            translate([7.3/2, 50, 0-.5]) rotate([0, 0, 0]) fin();
        }
        translate([28, 7, -4]) cube(size=[52, 18, 10]);
        translate([30, 60, 0]) cylinder(r=20, h=10, center=true);
        translate([108-30, 60, 0]) cylinder(r=20, h=10, center=true);
    }
}

module main() {
    %scaffold();
    holder();
}
main();


//.
