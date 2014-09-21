// extruder blower vane
// karsten rohrbach (byteborg) 2014
// CC-BY-NC 3.0
$fn=90;
qq=.01;

translate([0, 0, -4+qq]) fanmount();
vane();

module vane() {
    difference() {
        union() {
            // hotend
            hull() {
                translate([10/2-3, 0, 0]) linear_extrude(height=qq) circle(r=(30-2)/2, $fn=180);
                translate([6, 0, 38]) scale([1, .2, 1]) linear_extrude(height=qq) circle(r=10);
            }
            // tip
            hull() {
                linear_extrude(height=qq) circle(r=(40-2)/2, $fn=180);
                translate([-27, 0, 40]) scale([.55, 1, 1]) linear_extrude(height=qq) circle(r=6);
            }
        }   
        union() {
            // hotend
            hull() {
                translate([10/2-3, 0, 0]) linear_extrude(height=qq) circle(r=(30-4)/2, $fn=180);
                translate([6, 0, 38+qq]) scale([.8, .1, 1]) linear_extrude(height=qq) circle(r=10);
            }
            // tip
            hull() {
                translate([0, 0, -qq]) linear_extrude(height=qq) circle(r=(40-4)/2, $fn=180);
                translate([-27, 0, 40+qq]) scale([.4, .8, 1]) linear_extrude(height=qq) circle(r=6);
            }
        }   
    }
    // for measurement
    // tip bottom
    %translate([-30, -5, 0]) cube(size=[10, 10, 100], center=false);
    // hotend
    %translate([0, 0, 40+10/2]) rotate([0, 90, 0]) cylinder(r=5, h=100, center=true); 
    // carriage
    %translate([20, -50, 0]) cube(size=[10, 100, 100], center=false);
}

module fanmount(thickness=4) {
    difference() {
        linear_extrude(height=thickness) {
            difference() {
                // body
                minkowski() {
                    square(40-(4*2), center=true);
                    circle(r=4);
                }
                // mounting holes
                for(dx=[-16,16]) for (dy=[-16,16]) translate([dx, dy, 0]) circle(r=4.3/2);
                // flow hole
                //circle(r=(40-2)/2, $fn=360);
            }
        }
        translate([0, 0, -qq*2]) cylinder(r1=(40-2)/2, r2=(40-4)/2, h=thickness+qq*4, center=false, $fn=360);
    }
}
