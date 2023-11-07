// two arm character reaches toward mouse with whichever arm can reach it
color LIGHT_YELLOW = color(255, 255, 100);
boolean increase = true;

Arm[] arms = new Arm[16];

void setup() {
    size(1280, 720, P3D);
    background(255);
    frameRate(30);
    // initialize the arms accross the bottom of the screen
    for (int i = 0; i < arms.length; i++) {
        arms[i] = new Arm(4, new Vec2(width/(arms.length-1)*(i), height), new Vec2(0, 0));
    }
    // right_arm = new Arm(4, new Vec2(width/2 + 100, height/2), new Vec2(0, 0));
    // initialize the left arm
    // left_arm = new Arm(4, new Vec2(width/2 - 100, height/2), new Vec2(0, 0));
}

void draw() {
    background(255);
    noStroke();
    lights();

    // draw the body as a large light yellow sphere
    // fill(LIGHT_YELLOW);
    // pushMatrix();
    // // translate to center
    // translate(width/2, height/2, 0);
    // sphere(100);
    // popMatrix();

    // update the arms
    for (int i = 0; i < arms.length; i++) {
        arms[i].update();
    }
    // draw the arms
    for (int i = 0; i < arms.length; i++) {
        arms[i].draw();
    }

}

// https://vormplus.be/full-articles/drawing-a-cylinder-with-processing
void draw_cylinder( int sides, float r1, float r2, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // top
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r1;
        float y = sin( radians( i * angle ) ) * r1;
        vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
    // bottom
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r2;
        float y = sin( radians( i * angle ) ) * r2;
        vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
    // draw body
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
        float x1 = cos( radians( i * angle ) ) * r1;
        float y1 = sin( radians( i * angle ) ) * r1;
        float x2 = cos( radians( i * angle ) ) * r2;
        float y2 = sin( radians( i * angle ) ) * r2;
        vertex( x1, y1, -halfHeight);
        vertex( x2, y2, halfHeight);
    }
    endShape(CLOSE);
}