// byteborg's adjustable Prusa Y-axis endstop flag

SCREWD=3.2; // for M3 screws
NUTD=5.2;

XDIM=35; // x dimensioning
HINGEW=1.5; // hinge width
HINGEH=4.5; // hinge height
FLAGL=30; // flag length

$fn=16;

module hingedflag() {
	translate([-HINGEW/2,0,0]) cube([HINGEW,XDIM*2,HINGEH], center=true); // hinge back
	translate([-HINGEW/2,XDIM-HINGEW,-HINGEH/2]) cube([HINGEW*3,HINGEW,HINGEH]); // hinge bar
	translate([-HINGEW/2,-XDIM,-HINGEH/2]) cube([HINGEW*3,HINGEW,HINGEH]); // hinge bar
	translate([HINGEW*2,0,0]) cube([HINGEW,XDIM*2,HINGEH], center=true); // hinge front
	translate([HINGEW*2,-1.5/2,-HINGEH/2]) cube([FLAGL,1.5,4.5]); // flag
	translate([HINGEW*2.5,0,0]) rotate([0,0,-45]) cube([3.5,3.5,4.5], center=true); // screw counterpart
}

difference() {
	union() {
		cube([10,25,6]);
		translate([10,12,3]) hingedflag();
	}
	translate([0,0,-10]) union() {
		for(i = [5:.5:9])
			translate([5,i,0]) cylinder(r=SCREWD/2, h=20);
		for(i = [20:.5:16])
			translate([5,i,0]) cylinder(r=SCREWD/2, h=20);
	}
	translate([-9.5,12.5,6/2]) rotate([0,90,0]) {
		cylinder(r=SCREWD/2, h=20);
		translate([0,0,20-3]) rotate([0,0,30]) cylinder(r=NUTD/2, h=3, $fn=0, $fa=60);
	}
}
