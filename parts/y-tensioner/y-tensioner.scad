// simple parametric tensioner for Y-axis belt
// print 2 times (left/right)

BOLTD=8.1;          // bolt diameter
BEARD=6.1;          // bearing bolt diameter
SCREWD=3.1;         // screw diameter
XDIM=max(BOLTD, BEARD)*2;

THICK=5;            // thickness
LEN=60;             // overall length

NOTHING=.000001;    // next to nothing
$fn=32;

difference() {
    cube([XDIM, LEN, THICK], center=true);
    translate([0, -LEN/2, 0]) {
        minkowski() {
            cylinder(r=BOLTD/2, h=THICK*2, center=true);
            cube(size=[NOTHING, BOLTD*2, NOTHING], center=true);
        }
        minkowski() {
            cylinder(r=1, h=THICK*2, center=true);
            cube(size=[NOTHING, XDIM*2, 10], center=true);
        }
    }
    translate([0, LEN/2, 0]) {
        minkowski() {
            cylinder(r=BEARD/2, h=THICK*2, center=true);
            cube(size=[NOTHING, BEARD*2, NOTHING], center=true);
        }
        minkowski() {
            cylinder(r=1, h=THICK*2, center=true);
            cube(size=[NOTHING, XDIM*2, NOTHING], center=true);
        }
    }
    rotate([0, 90, 0]) {
        translate([0, -LEN/2+THICK/1.33, 0]) {
            cylinder(r=SCREWD/2, h=XDIM*2, center=true);
        }
        translate([0, LEN/2-THICK/1.33, 0]) {
            cylinder(r=SCREWD/2, h=XDIM*2, center=true);
        }
    }
    
}

//.
