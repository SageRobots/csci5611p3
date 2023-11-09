Mountain[] mountains = new Mountain[20];
Camera camera;
float x, z, r;

void setup() {
    size(1280, 720, P3D);
    for (int i = 0; i < mountains.length; i++) {
        float s = random(50, 250);
        float x = random(-500 + s/2, 500 - s/2) + width/2;
        float z = random(-1000 + s/2, 0 - s/2);
        mountains[i] = new Mountain(s, x, z);
    }
    camera = new Camera();

    frameRate(60);
}

void draw() {
    camera.Update(1.0/frameRate);

    // sky blue background
    ambientLight(128, 128, 128);
    directionalLight(128, 128, 128, 1, 1, 0);
    lightSpecular(255, 255, 255);
    background(0, 200, 255);
    noStroke();

    // large sand colored box for base
    fill(255, 255, 200);
    pushMatrix();
    translate(width/2, height-50, -500);
    box(1000, 100, 1000);
    popMatrix();

    // draw mountains
    for (int i = 0; i < mountains.length; i++) {
        mountains[i].draw();
    }

    // draw blue circle for water
    fill(0, 100, 255);
    do {
        r = 50;
        x = random(-500 + r, 500 - r) + width/2;
        z = random(-1000 + r, 0 - r);
        pushMatrix();
        translate(x, height-100, z);
        rotateX(PI/2);
        circle(0, 0, r);
        popMatrix();
    } while (collision(x, z, r));

}

void keyPressed() {
    camera.HandleKeyPressed();
}

void keyReleased() {
    camera.HandleKeyReleased();
}

boolean collision(float x, float z, float r) {
    for (int i = 0; i < mountains.length; i++) {
        if (mountains[i].collision(x, z, r)) {
            return true;
        }
    }
    return false;
}