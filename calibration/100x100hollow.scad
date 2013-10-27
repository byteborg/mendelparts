HEIGHT=10;
WIDTH=100;
// THICKNESS=2;

translate([0, 0, HEIGHT/2]) difference() {
    cube(size=[WIDTH, WIDTH, HEIGHT], center=true);
    // #cube(size=[WIDTH-THICKNESS, WIDTH-THICKNESS, HEIGHT+2], center=true);
}
