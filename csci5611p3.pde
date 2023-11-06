// two arm character reaches toward mouse with whichever arm can reach it
color LIGHT_YELLOW = color(255, 255, 100);
int a0 = -90;
boolean increase = true;
void setup() {
    size(1280, 720, P3D);
    background(255);
    frameRate(30);
}

void draw() {
    background(255);
    // draw the body as a large light yellow sphere
    noStroke();
    lights();
    fill(LIGHT_YELLOW);
    pushMatrix();
    // translate to center
    translate(width/2, height/2, 0);
    sphere(100);
    popMatrix();

    // change angle by 1 degree
    if (increase) {
        a0++;
        if (a0 == 90) {
            increase = false;
        }
    } else {
        a0--;
        if (a0 == -90) {
            increase = true;
        }
    }

    // draw one arm as a cylinder with sphere on the ends
    pushMatrix();
    translate(width/2, height/2, 0);
    translate(-100, 0, 0);
    // rotate 45 degrees
    rotateZ(radians(a0));

    pushMatrix();
    // rotate 90 degrees
    rotateY(radians(90));
    // draw the upper arm
    translate(0, 0, -50);
    draw_cylinder(30, 20, 20, 100);
    // draw spheres at the ends
    translate(0, 0, 50);
    sphere(20);
    translate(0, 0, -100);
    sphere(20);
    popMatrix();

    popMatrix();

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