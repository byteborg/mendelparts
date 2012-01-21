// 8mm SFBS0810 slide bushing holder for y carriage
// carriage mounting holes M4, 15mm apart
$fn=96;
nothing=.001;

module main() {
    difference() {
        union() {
            //translate([0, 0, 0]) cube(size=[25, 25, 3], center=true);
            translate([0, 0, 8]) rotate([90, 0, 0]) cylinder(r=12/2+2, h=10, center=true);
            translate([0, 0, 4]) cube(size=[16, 10, 8], center=true);

        }
        translate([0, 0, 8]) rotate([90, 0, 0]) cylinder(r=10/2, h=15, center=true);
        translate([-15/2+1.5, 0, 0]) cube(size=[1.5, 4, 40], center=true);
        translate([15/2-1.5, 0, 0]) cube(size=[1.5, 4, 40], center=true);
        translate([0, 0, 13]) cube(size=[30, 4, 1.6], center=true);
    }    
}

// translate([15, 0, 1.5-nothing]) 
// difference() {
//     main();
//     translate([0, 0, 21]) cube(size=[40, 40, 40], center=true);
// }

translate([-10, 0, 5])
rotate([90, 0, 0]) 
//difference() {
     main();
    //translate([0, 0, -18.5+nothing]) cube(size=[40, 40, 40], center=true);
//} 
