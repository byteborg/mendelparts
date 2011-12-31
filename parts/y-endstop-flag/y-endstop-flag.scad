// byteborg's Prusa Y-axis endstop flag

SCREWD=3.2; // for M3 screws

$fn=50;
difference() {
	union() {
		cube([10,25,3]);
		translate([0,25/2-1.5/2,0]) difference() {
			cube([30,1.5,4.5]);
			translate([0,-4,3]) rotate([0,-45,0]) cube([10,10,10]);
		}
	}
	translate([0,0,-10]) union() {
		for(i = [5:.5:9])
			translate([5,i,0]) cylinder(r=SCREWD/2, h=20);
		for(i = [20:.5:16])
			translate([5,i,0]) cylinder(r=SCREWD/2, h=20);
	}
}
