// Planetary gear bearing (customizable)
// http://www.thingiverse.com/thing:138222
// CC-BY-SA by terrym, whose source code does not carry copyright notices
// remixed by Karsten "byteborg" Rohrbach

// TODO: check M nut&head diameters

include <MCAD/constants.scad>
include <MCAD/motors.scad>
// use <ruler.scad>
// %ruler();

q=.1;

NEMA_BOLT_DIST = 1.220*mm_per_inch;
NEMA_BOLT_DIA = 3.6;
NEMA_PILOT_DIA = 0.866*mm_per_inch;
NEMA_DIM = NEMA_BOLT_DIST + NEMA_BOLT_DIA + 5 + 4; // see motors.scad, too small

BASE_Z=5;

CRANK_Z=3;
CRANK_D=NEMA_DIM-7;
CRANK_TOL=1.5;
CRANK_CLEARANCE=17;

M4_HEAD_D=6;
M4_HEAD_Z=4;
M4_NUT_D=7.5;

M5_NUT_D=9.5;
M5_NUT_Z=4;

PLATE_DIST=5;

// outer diameter of ring
//D=51.7;
D=NEMA_DIM;
// thickness
T=10;
// clearance
tol=0.2;
number_of_planets=3;
number_of_teeth_on_planets=7;
approximate_number_of_teeth_on_sun=7;
// pressure angle
P=45;//[30:60]
// number of teeth to twist across
nTwist=.5;
// width of hexagonal hole.  For hex safts.
w=6.7;
// Shaft radius.  For round saft with a flat.
sd=5;
// Shaft thinkness at flat  For round saft with a flat..
st=4;
// Shaft type: 0=hex, 1=round w/flat.
stype=1;
// Planet axile diameter.
pad=4;

DR=0.5*1;// maximum depth ratio of teeth

m=round(number_of_planets);
np=round(number_of_teeth_on_planets);
ns1=approximate_number_of_teeth_on_sun;
k1=round(2/m*(ns1+np));
k= k1*m%2!=0 ? k1+1 : k1;
ns=k*m/2-np;
echo(ns);
nr=ns+2*np;
pitchD=0.9*D/(1+min(PI/(2*nr*tan(P)),PI*DR/nr));
pitch=pitchD*PI/nr;
echo(pitch);
helix_angle=atan(2*nTwist*pitch/T);
echo(helix_angle);

phi=$t*360/m;

// devel_assembly();
output_assembly();

module devel_assembly() {
	// %stepper();
	*%base();
	*%top();
	%planetary();
	crank_bottom();
	crank_top();
}

module output_assembly() {
	translate([-(NEMA_DIM+PLATE_DIST)/2, -(NEMA_DIM+PLATE_DIST)/2, 0]) base();
	translate([(NEMA_DIM+PLATE_DIST)*1.5, -(NEMA_DIM+PLATE_DIST)/2, (T+BASE_Z*2)]) rotate([180, 0, 0]) top();
	translate([(NEMA_DIM+PLATE_DIST)/2, -(NEMA_DIM+PLATE_DIST)/2, -BASE_Z]) planetary();
	translate([(NEMA_DIM+PLATE_DIST)/2, 0, 0]) {
		translate([(NEMA_DIM+PLATE_DIST)/2, (NEMA_DIM+PLATE_DIST)/2, -(BASE_Z-CRANK_Z)]) crank_bottom();
		translate([-(NEMA_DIM+PLATE_DIST)/2, (NEMA_DIM+PLATE_DIST)/2, T+BASE_Z+CRANK_Z]) rotate([180, 0, 0]) crank_top();
	}
}

module base() {
	difference() {
		translate([0, 0, BASE_Z/2])
		cube(size=[NEMA_DIM, NEMA_DIM, BASE_Z], center=true);
		// stepper();
		translate([0, 0, T/2+BASE_Z-CRANK_Z-CRANK_TOL]) cylinder(r=(CRANK_D+CRANK_TOL)/2, h=T, center=true, $fn=96);
		nema_holes();
		cylinder(r=NEMA_PILOT_DIA/2+.5, h=10, center=true, $fn=64);
	}
}

module top() {
	difference() {
		translate([0, 0, T+BASE_Z*1.5])
		cube(size=[NEMA_DIM, NEMA_DIM, BASE_Z], center=true);
		// stepper();
		translate([0, 0, T+BASE_Z-CRANK_TOL]) cylinder(r=(CRANK_D+CRANK_TOL)/2, h=T, center=true, $fn=96);
		cylinder(r=(sd+CRANK_TOL)/2, h=100, center=true, $fn=64);
		nema_holes();
	}
}

module crank_bottom(args) {
	translate([0, 0, BASE_Z-CRANK_Z/2])
	difference() {
		union() {
			cylinder(r=CRANK_D/2, h=CRANK_Z, center=true, $fn=96);
			// translate([0, 0, (T+CRANK_Z)/2-q]) cylinder(r=CRANK_D/2-2, h=T, center=true, $fn=96);
		}
		cylinder(r=(sd+CRANK_TOL)/2, h=100, center=true, $fn=64);
		// planet holes
		for(i=[1:m])
			rotate([0,0,i*360/m+phi])
				translate([pitchD/2*(ns+np)/nr,0,0])
					rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi]) {
						cylinder(r=pad/2,h=T+1,center=true,$fn=100); // hole
						translate([0, 0, -M4_HEAD_Z/2]) cylinder(r=M4_NUT_D/2, h=M4_HEAD_Z, center=true, $fn=6); // head
						translate([0, 0, CRANK_Z/2+T/2]) cylinder(r=CRANK_CLEARANCE/2, h=T+CRANK_TOL, center=true, $fn=96); // clearance
					}
		translate([0, 0, CRANK_Z/2+T/2]) cylinder(r=CRANK_CLEARANCE/2, h=T+q, center=true, $fn=96); // sun clearance
		translate([0, 0, CRANK_Z-CRANK_TOL]) difference() {
			cylinder(r=CRANK_D/2+q, h=CRANK_Z, center=true, $fn=96);
			cylinder(r=CRANK_D/2-CRANK_TOL, h=CRANK_Z+q, center=true, $fn=96);
		}
	}
}

module crank_top() {
	translate([0, 0, BASE_Z-CRANK_Z/2])
	difference() {
		union() {
			translate([0, 0, T+CRANK_Z]) cylinder(r=CRANK_D/2, h=CRANK_Z, center=true, $fn=96);
			translate([0, 0, (T+CRANK_Z)/2+q]) cylinder(r=CRANK_D/2-2, h=T, center=true, $fn=96);
		}
		cylinder(r=(sd)/2, h=100, center=true, $fn=64);
		translate([0, 0, T+M5_NUT_Z-q]) cylinder(r=M5_NUT_D/2, h=M5_NUT_Z, center=true, $fn=6);
		// planet holes
		for(i=[1:m])
			rotate([0,0,i*360/m+phi])
				translate([pitchD/2*(ns+np)/nr,0,0])
					rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi]) {
						cylinder(r=pad/2,h=100,center=true,$fn=100); // hole
						translate([0, 0, T+CRANK_Z*2-M4_HEAD_Z]) cylinder(r=M4_HEAD_D/2, h=M4_HEAD_Z, center=true, $fn=96); // head
						translate([0, 0, CRANK_Z/2+T/2]) cylinder(r=CRANK_CLEARANCE/2, h=T+CRANK_TOL, center=true, $fn=96); // clearance
					}
		translate([0, 0, CRANK_Z/2+T/2]) cylinder(r=CRANK_CLEARANCE/2, h=T+q, center=true, $fn=96); // sun clearance
		translate([0, 0, T+CRANK_TOL/2]) difference() {
			cylinder(r=CRANK_D/2+q, h=CRANK_Z, center=true, $fn=96);
			cylinder(r=CRANK_D/2-CRANK_TOL-.5, h=CRANK_Z+q, center=true, $fn=96);
		}
	}
}

module planetary() {
	translate([0,0,T/2+BASE_Z]){
		difference(){ // This makes the outer ring.
			//cylinder(r=D/2,h=T,center=true,$fn=100);
			cube(size=[NEMA_DIM, NEMA_DIM, T], center=true);
			herringbone(nr,pitch,P,DR,-tol,helix_angle,T+0.2);
			// difference(){
			// 	translate([0,-D/2,0])rotate([90,0,0])monogram(h=10);
			// 	cylinder(r=D/2-0.25,h=T+2,center=true,$fn=100);
			// }
			nema_holes();
		}
		rotate([0,0,(np+1)*180/ns+phi*(ns+np)*2/ns])
		difference(){ // This makes the sun.
			mirror([0,1,0])
				herringbone(ns,pitch,P,DR,tol,helix_angle,T);
			if(stype==0)
				cylinder(r=w/sqrt(3),h=T+1,center=true,$fn=6);
			else
				difference(){ // This makes a hole for a flat shaft.
					cylinder(r=sd/2,h=T+1,center=true,$fn=100);
					translate([st-(sd/2),-(sd/2),-(T+1)/2])
						cube([sd, sd, T+1]);	// This is the flat in the shaft hole.
				}
		}
		// Now make the planets.
		for(i=[1:m])
			rotate([0,0,i*360/m+phi])
				translate([pitchD/2*(ns+np)/nr,0,0])
					rotate([0,0,i*ns/m*360/np-phi*(ns+np)/np-phi])
						difference(){ // make an axial hole in each planet.
							herringbone(np,pitch,P,DR,tol,helix_angle,T);
							cylinder(r=pad/2,h=T+1,center=true,$fn=100);	// This is the hole.
						}
	}
}


// Makes the teeth on the inside of the outer ring.
module monogram(h=1)
linear_extrude(height=h,center=true)
translate(-[3,2.5])union(){
	difference(){
		square([4,5]);
		translate([1,1])square([2,3]);
	}
	square([6,1]);
	translate([0,2])square([2,1]);
}

module herringbone(
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=28,
	depth_ratio=1,
	clearance=0,
	helix_angle=0,
	gear_thickness=5){
union(){
	gear(number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance,
		helix_angle,
		gear_thickness/2);
	mirror([0,0,1])
		gear(number_of_teeth,
			circular_pitch,
			pressure_angle,
			depth_ratio,
			clearance,
			helix_angle,
			gear_thickness/2);
}}

module gear (
	number_of_teeth=15,
	circular_pitch=10,
	pressure_angle=28,
	depth_ratio=1,
	clearance=0,
	helix_angle=0,
	gear_thickness=5,
	flat=false){
pitch_radius = number_of_teeth*circular_pitch/(2*PI);
twist=tan(helix_angle)*gear_thickness/pitch_radius*180/PI;

flat_extrude(h=gear_thickness,twist=twist,flat=flat)
	gear2D (
		number_of_teeth,
		circular_pitch,
		pressure_angle,
		depth_ratio,
		clearance);
}

module flat_extrude(h,twist,flat){
	if(flat==false)
		linear_extrude(height=h,twist=twist,slices=twist/6)children(0);
	else
		children(0);
}

module gear2D (
	number_of_teeth,
	circular_pitch,
	pressure_angle,
	depth_ratio,
	clearance){
pitch_radius = number_of_teeth*circular_pitch/(2*PI);
base_radius = pitch_radius*cos(pressure_angle);
depth=circular_pitch/(2*tan(pressure_angle));
outer_radius = clearance<0 ? pitch_radius+depth/2-clearance : pitch_radius+depth/2;
root_radius1 = pitch_radius-depth/2-clearance/2;
root_radius = (clearance<0 && root_radius1<base_radius) ? base_radius : root_radius1;
backlash_angle = clearance/(pitch_radius*cos(pressure_angle)) * 180 / PI;
half_thick_angle = 90/number_of_teeth - backlash_angle/2;
pitch_point = involute (base_radius, involute_intersect_angle (base_radius, pitch_radius));
pitch_angle = atan2 (pitch_point[1], pitch_point[0]);
min_radius = max (base_radius,root_radius);

intersection(){
	rotate(90/number_of_teeth)
		circle($fn=number_of_teeth*3,r=pitch_radius+depth_ratio*circular_pitch/2-clearance/2);
	union(){
		rotate(90/number_of_teeth)
			circle($fn=number_of_teeth*2,r=max(root_radius,pitch_radius-depth_ratio*circular_pitch/2-clearance/2));
		for (i = [1:number_of_teeth])rotate(i*360/number_of_teeth){
			halftooth (
				pitch_angle,
				base_radius,
				min_radius,
				outer_radius,
				half_thick_angle);
			mirror([0,1])halftooth (
				pitch_angle,
				base_radius,
				min_radius,
				outer_radius,
				half_thick_angle);
		}
	}
}}

module halftooth (
	pitch_angle,
	base_radius,
	min_radius,
	outer_radius,
	half_thick_angle){
index=[0,1,2,3,4,5];
start_angle = max(involute_intersect_angle (base_radius, min_radius)-5,0);
stop_angle = involute_intersect_angle (base_radius, outer_radius);
angle=index*(stop_angle-start_angle)/index[len(index)-1];
p=[[0,0], // The more of these the smoother the involute shape of the teeth.
	involute(base_radius,angle[0]+start_angle),
	involute(base_radius,angle[1]+start_angle),
	involute(base_radius,angle[2]+start_angle),
	involute(base_radius,angle[3]+start_angle),
	involute(base_radius,angle[4]+start_angle),
	involute(base_radius,angle[5]+start_angle)];

difference(){
	rotate(-pitch_angle-half_thick_angle)polygon(points=p);
	square(2*outer_radius);
}}

// Mathematical Functions
//===============

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
//source: http://www.mathhelpforum.com/math-help/geometry/136011-circle-involute-solving-y-any-given-x.html

function involute_intersect_angle (base_radius, radius) = sqrt (pow (radius/base_radius, 2) - 1) * 180 / PI;

// Calculate the involute position for a given base radius and involute angle.

function involute (base_radius, involute_angle) =
[
	base_radius*(cos (involute_angle) + involute_angle*PI/180*sin (involute_angle)),
	base_radius*(sin (involute_angle) - involute_angle*PI/180*cos (involute_angle))
];


// =====
module stepper() {
    stepper_motor_mount(17);
    nema_holes();
}
module nema_holes() {
    for (x=[1,-1]) for (y=[1,-1])
    translate([x*NEMA_BOLT_DIST/2, y*NEMA_BOLT_DIST/2, 0])
    cylinder(r=NEMA_BOLT_DIA/2, h=100, center=true, $fn=32);
}
//.

