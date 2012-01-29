difference() {
    union() {
    	cube([10,10,7]);
    	translate([5,0,0]) cylinder(r=5,h=7,$fn=64);
    }
    translate([5, 12, 5]) rotate([0, 0, 45]) cube(size=[10, 10, 10], center=true);
}