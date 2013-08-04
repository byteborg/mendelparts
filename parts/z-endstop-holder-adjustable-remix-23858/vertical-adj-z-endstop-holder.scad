// PRUSA Mendel
// Vertical Adjustable Opto Z Endstop Holder
// Used to attach endstops to 8mm rods
// GNU GPL v3
// Shannon Little from Geoff Drake from original idea by Josef Průša
// Tags: endstop, opto_endstop, adjustable_endstop, mendel, prusa, mount, openscad, opto, z_axis_endstop, z-axis, axis, part
// Version 1.0

// This is a derivative of http://www.thingiverse.com/thing:15448

/**
 * @id vertical-adjustable-z-endstop-holder
 * @name Vertical Adjustable Z Endstop Holder
 * @category Printed
 * @using 2 m3x25xhex
 * @using 1 m3x35xhex
 * @using 2 m3nut
 * @using 3 m3nylock
 * @using 2 m3washer
 * @using 2 4-40nut
 * @using 2 4-40x5/8
 * @using 1 spring
 */

// % Background Modifier
// # Debug Modifier
// ! Root Modifier
// * Disable Modifier


// The M3 bolt holes should be as close to the actual bolt diameter as possible so the bolts wiggle as little as possible (this is critical to keep the opto from pivoting around the center bolt)
// You may need to drill the hole out just slightly so the bolts barely fit (I used Harbor Freight drill bit #32, which measures 2.91mm or 0.114in)
m3Diameter = 3.8;
m3NutDiameter = 7.0;						// You may need to tweak this for your machine
m8Diameter = 8.8;
outerDiameter = m8Diameter / 2 + 3.3;
openingSize = m8Diameter - 1.5;

optoMountBoltDiameter = 4.35;				// This is a little larger than necessary to allow some wiggle room on installing the opto pcb
optoMountNutDiameter = 7.8; 				// This is sized for a 4-40 nut, use the above m3NutDiameter value for M3 nuts

armLength = 31;
armWidth = 9;
holderHeight = 12;
holderAdditionalWidth = 1;
springDiameter = 5.9;
springHolderDepth = 1;
cornerRound = 3;
boltOffset = 4;
boltSpacing = 10;


// Uncomment these individually to export each part for printing

//thumbscrew();
rotate([180, 0, 0]) endstop();
//holder();

// Comment these out when printing the parts, this view only shows the parts in assembled positions

// endstop();
// translate([1, armWidth - 5, 19]) rotate([0, 0, 180]) holder();
// translate([-boltOffset, -1, -10]) rotate([180, 0, 0]) thumbscrewLowPoly();						// OpenSCAD was choking on the higher poly thumbscrews so these are low poly ones just for previewing, when printing use the normal high poly ones above
// translate([-boltOffset - boltSpacing * 2, -1, -10]) rotate([180, 0, 0]) thumbscrewLowPoly();
// showAssemblyHardware();










module showAssemblyHardware() {
	translate([-boltOffset, -1, -10]) {
		translate([0, 0, -35]) hexBolt(3, 25);
		translate([0, 0, 4]) hexNut(3, 25);
		translate([0, 0, 23]) hexNylock(3, 25);
	}

	translate([-boltOffset - boltSpacing, -1, -10]) {
		translate([0, 0, 80]) rotate([180, 0, 0]) hexBolt(3, 25);
		translate([0, 0, 6]) rotate([180, 0, 0]) hexNylock(3, 25);
		translate([0, 0, 43]) color("silver") linear_extrude(height = 10, center = false, convexity = 10, twist = 3000, $fn = 15) translate([2.3, 0, 0]) circle(r = 0.2);
	}

	translate([-boltOffset - boltSpacing * 2, -1, -10]) {
		translate([0, 0, -35]) hexBolt(3, 25);
		translate([0, 0, 4]) hexNut(3, 25);
		translate([0, 0, 23]) hexNylock(3, 25);
	}
}


// These are not really accurate, they are just for showing how to assemble the endstop
module hexBolt(diameter = 3, height = 30) {
	color("silver")
	union() {
		cylinder(h = 1.5, r = 1.5 + diameter / 2, $fn = 6);
		cylinder(h = height, r = diameter / 2, $fn = 20);
	}
}


module hexNut(diameter = 3) {
	color("silver")
	difference() {
		cylinder(h = 1.5, r = 1.5 + diameter / 2, $fn = 6);
		translate([0, 0, -0.5]) cylinder(h = 3, r = diameter / 2, $fn = 20);
	}
}


module hexNylock(diameter = 3) {
	color("silver")
	difference() {
		union() {
			cylinder(h = 1.5, r = 1.5 + diameter / 2, $fn = 6);
			translate([0, 0, 1.5]) sphere(r = diameter / 2 + 0.6, $fn = 20);
		}

		translate([0, 0, -0.5]) cylinder(h = diameter * 2, r = diameter / 2, $fn = 20);
		translate([0, 0, -diameter]) cube(size = diameter * 2, center = true);
	}
}


module endstop() {
	difference() {
		// Outline
		union() {
			translate([outerDiameter, outerDiameter, -10]) cylinder(h = 20, r = outerDiameter, $fn = 50);									// Round clamp
			translate([outerDiameter, 0, -10]) cube([15.5, outerDiameter * 2,20]);														// Cube clamp
			translate([-armLength + 1, outerDiameter - m8Diameter / 2, 0]) rotate([90, 0, 0]) cube([armLength + 15, 10, armWidth]);		// Arm
            translate([17, 3, 5]) rotate([90, 0, 0]) cylinder(h = armWidth - 0.3, r = 5.77, $fn = 6);                                   // Nut trap
            translate([17, 3, -5+.01]) rotate([90, 0, 0]) cylinder(h = armWidth - 0.3, r = 5.77, $fn = 6);                                   // Nut trap
		}

		// Clamp
		translate([9, outerDiameter - openingSize / 2, -10.1]) 	cube([18, openingSize, 22]);								// Endstop opening slot
		translate([outerDiameter, outerDiameter, -10.1]) 		cylinder(h = 25, r = m8Diameter / 2, $fn = 25);				// Endstop rod clamp opening
		translate([outerDiameter - 3, -outerDiameter - armWidth + 1, -11]) rotate([0, 0, 12]) cube([25, 10, 22]);			// Nut trap slant
        translate([17 - 0.3, 17, 5])    rotate([90, 0, 0])      cylinder(h = 20, r = m3Diameter / 2, $fn = 10);             // Clamp bolt opening (2 are here on purpose to make it oval)
        translate([17 - 0.3, 17, -5])    rotate([90, 0, 0])      cylinder(h = 20, r = m3Diameter / 2, $fn = 10);             // Clamp bolt opening (2 are here on purpose to make it oval)
        translate([17 + 0.3, 17, 5])    rotate([90, 0, 0])      cylinder(h = 20, r = m3Diameter / 2, $fn = 10);             // Clamp bolt opening
        translate([17 + 0.3, 17, -5])    rotate([90, 0, 0])      cylinder(h = 20, r = m3Diameter / 2, $fn = 10);             // Clamp bolt opening
        translate([17, 0.5, 5])         rotate([90, 0, 0])      cylinder(h = 15, r = m3NutDiameter / 2, $fn = 6);           // Clamp nut trap opening
        translate([17, 0.5, -5])         rotate([90, 0, 0])      cylinder(h = 15, r = m3NutDiameter / 2, $fn = 6);           // Clamp nut trap opening

		// Arm
		translate([-boltOffset, outerDiameter - m8Diameter / 2 - armWidth / 2, -13.5]) 					cylinder(h = 20, r = m3Diameter / 2, $fn = 10);				// Inner adjustment bolt hole
		translate([-boltOffset, outerDiameter - m8Diameter / 2 - armWidth / 2, 7]) 					cylinder(h = 20, r = m3NutDiameter / 2, $fn = 6);			// Inner adjustment nut trap hole
		translate([-boltOffset - boltSpacing, outerDiameter - m8Diameter / 2 - armWidth / 2, -5]) 		cylinder(h = 20, r = m3Diameter / 2, $fn = 10);				// Center spring bolt hole
		translate([-boltOffset - boltSpacing, outerDiameter - m8Diameter / 2 - armWidth / 2, -1]) 		cylinder(h = 4, r = m3NutDiameter / 2, $fn = 6);			// Center spring bolt nut trap hole
		translate([-boltOffset - boltSpacing * 2, outerDiameter - m8Diameter / 2 - armWidth / 2, -13.5]) 	cylinder(h = 20, r = m3Diameter / 2, $fn = 10);				// Outer adjustment bolt hole
		translate([-boltOffset - boltSpacing * 2, outerDiameter - m8Diameter / 2 - armWidth / 2, 7]) 	cylinder(h = 20, r = m3NutDiameter / 2, $fn = 6);			// Outer adjustment nut trap hole

		// Arm end rounding
		translate([-armLength + 1 + cornerRound / 2 - 0.01, outerDiameter - m8Diameter / 2 - armWidth + cornerRound / 2 - 0.01, holderHeight / 2]) rotate([90, 0, 0]) 	curve(cornerRound, holderHeight + 2);
		translate([-armLength + 1 + cornerRound / 2 - 0.01, outerDiameter - m8Diameter / 2 - cornerRound / 2 + 0.01, holderHeight / 2]) rotate([90, 0, -90]) 			curve(cornerRound, holderHeight + 2);
	}
}


module holder() {
	holderOffsetX = -5;
	optoMountHoleZ = holderHeight - 5;	// holderHeight / 2 use this to place in center

	difference() {
		union() {
			translate([-holderAdditionalWidth, 0, 0])cube([armLength + holderAdditionalWidth, armWidth, holderHeight]);
		}

		translate([1 + boltOffset, armWidth / 2, -1]) 													cylinder(h = 4.2, r = m3Diameter / 2, $fn = 10);									// Inner arm bolt guide
		translate([1 + boltOffset + boltSpacing, armWidth / 2, -1]) 									cylinder(h = 2 + holderHeight, r = m3Diameter / 2, $fn = 10);						// Center arm bolt hole
		translate([1 + boltOffset + boltSpacing, armWidth / 2, holderHeight - springHolderDepth])	 	cylinder(h = springHolderDepth + 2, r = springDiameter / 2, $fn = 14);				// Center spring hole
		translate([1 + boltOffset + boltSpacing * 2, armWidth / 2, -1]) 								cylinder(h = 4.2, r = m3Diameter / 2, $fn = 10);									// Outer arm bolt guide

		translate([1 + boltOffset, armWidth + 2, optoMountHoleZ]) rotate([90, 0 ,0])						cylinder(h = armWidth + 4, r = optoMountBoltDiameter / 2, $fn = 10);			// Inner opto bolt hole
		translate([1 + boltOffset, armWidth + 0.2, optoMountHoleZ]) rotate([90, 90, 0])						cylinder(h = 3.1, r = optoMountNutDiameter / 2, $fn = 6);						// Inner opto nut trap hole
		translate([1 + boltOffset + boltSpacing * 2, armWidth + 2, optoMountHoleZ]) rotate([90, 0 ,0])		cylinder(h = armWidth + 4, r = optoMountBoltDiameter / 2, $fn = 10);			// Outer opto bolt hole
		translate([1 + boltOffset + boltSpacing * 2, armWidth + 0.2, optoMountHoleZ]) rotate([90, 90, 0])	cylinder(h = 3.1, r = optoMountNutDiameter / 2, $fn = 6);						// Outer opto nut trap hole

		// Arm end rounding
		translate([-holderAdditionalWidth + cornerRound / 2 - 0.01, armWidth - cornerRound / 2 + 0.01, holderHeight / 2]) 	rotate([90, 0, -90]) 	curve(cornerRound, holderHeight + 2);
		translate([armLength - cornerRound / 2 + 0.01, armWidth - cornerRound / 2 + 0.01, holderHeight / 2]) 				rotate([90, 0, 180]) 	curve(cornerRound, holderHeight + 2);
	}
}


module curve(rad = 6, height = 3) {
	difference() {
		translate([-rad / 4, 0,  rad / 4]) cube([rad / 2, height, rad / 2], center = true);
		rotate([90, 0, 0]) translate([0.005, -0.005 , 0]) cylinder(r = rad / 2, h = height + 1, center = true, $fn = 15);
	}
}


module thumbscrew() {
	difference() {
		knurled_cyl(4, 15, 2, 2, 1, 2, 0);
		cylinder(r = m3Diameter / 2, h = 4, $fn = 10);
		translate([0, 0, 2]) cylinder(h = 3, r = m3NutDiameter / 2, $fn = 6);
	}
}


module thumbscrewLowPoly() {
	difference() {
		knurled_cyl(4, 15, 6, 6, 1, 2, 0);
		cylinder(r = m3Diameter / 2, h = 4, $fn = 10);
		translate([0, 0, 2]) cylinder(h = 3, r = m3NutDiameter / 2, $fn = 6);
	}
}




// ****************************** All the needed libraries are included below ******************************







/*
 * knurledFinishLib.scad
 *
 * Written by aubenc @ Thingiverse
 *
 * This script is licensed under the Public Domain license.
 *
 * http://www.thingiverse.com/thing:9095
 *
 * Usage:
 *
 *    knurled_cyl( Knurled cylinder height,
 *                 Knurled cylinder outer diameter,
 *                 Knurl polyhedron width,
 *                 Knurl polyhedron height,
 *                 Knurl polyhedron depth,
 *                 Cylinder ends smoothed height,
 *                 Knurled surface smoothing amount );
 */
module knurled_cyl(chg, cod, cwd, csh, cdp, fsh, smt)
{
    cord=(cod+cdp+cdp*smt/100)/2;
    cird=cord-cdp;
    cfn=round(2*cird*PI/cwd);
    clf=360/cfn;
    crn=ceil(chg/csh);

    intersection()
    {
        shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);

        translate([0,0,-(crn*csh-chg)/2])
          knurled_finish(cord, cird, clf, csh, cfn, crn);
    }
}

module shape(hsh, ird, ord, fn4, hg)
{
        union()
        {
            cylinder(h=hsh, r1=ird, r2=ord, $fn=fn4, center=false);

            translate([0,0,hsh-0.002])
              cylinder(h=hg-2*hsh+0.004, r=ord, $fn=fn4, center=false);

            translate([0,0,hg-hsh])
              cylinder(h=hsh, r1=ord, r2=ird, $fn=fn4, center=false);
        }

}

module knurled_finish(ord, ird, lf, sh, fn, rn)
{
    for(j=[0:rn-1])
    assign(h0=sh*j, h1=sh*(j+1/2), h2=sh*(j+1))
    {
        for(i=[0:fn-1])
        assign(lf0=lf*i, lf1=lf*(i+1/2), lf2=lf*(i+1))
        {
            polyhedron(
                points=[
                     [ 0,0,h0],
                     [ ord*cos(lf0), ord*sin(lf0), h0],
                     [ ird*cos(lf1), ird*sin(lf1), h0],
                     [ ord*cos(lf2), ord*sin(lf2), h0],

                     [ ird*cos(lf0), ird*sin(lf0), h1],
                     [ ord*cos(lf1), ord*sin(lf1), h1],
                     [ ird*cos(lf2), ird*sin(lf2), h1],

                     [ 0,0,h2],
                     [ ord*cos(lf0), ord*sin(lf0), h2],
                     [ ird*cos(lf1), ird*sin(lf1), h2],
                     [ ord*cos(lf2), ord*sin(lf2), h2]
                    ],
                triangles=[
                     [0,1,2],[2,3,0],
                     [1,0,4],[4,0,7],[7,8,4],
                     [8,7,9],[10,9,7],
                     [10,7,6],[6,7,0],[3,6,0],
                     [2,1,4],[3,2,6],[10,6,9],[8,9,4],
                     [4,5,2],[2,5,6],[6,5,9],[9,5,4]
                    ],
                convexity=5);
         }
    }
}

