// bearing for chinese "wonderful wire cable" filament spindles

$fn=192;
nothing=.00001;
difference()
{
	union ()
	{
        // %cylinder(10, 21.7, 22.7, center=true);
        // %translate ([0,0,-8])cylinder(3, 30, 30);
		cylinder(r=26/2, h=8, center=true);
		translate([0, 0, -5-nothing]) cylinder(r=30/2, h=2, center=true);
	}
    // %translate ([0,0,-7.5]) cylinder (15,11.5,11.5);
	translate([0, 0, 4]) cylinder(r1=22/2, r2=22.5/2, h=18, center=true);
	cylinder(r=19/2, h=20, center=true);
}