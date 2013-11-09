D=26;
H=3;
HOLE=18;
q=.1;
$fn=96;

union(){
    import("repaired.stl");
    translate([(D+q)/2, (D+q)/2, H/2]) {
        difference() {
            cylinder(r=(D-q)/2, h=H, center=true);
            cylinder(r=HOLE/2, h=H*4, center=true);
        }
    }
}
