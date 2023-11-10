Mountain[] mountains = new Mountain[20];
Camera camera;

Circle water = new Circle();
Agent agent = new Agent();

void setup() {
    size(1280, 720, P3D);
    camera = new Camera();
    frameRate(60);

    for (int i = 0; i < mountains.length; i++) {
        float s = random(50, 250);
        float x = random(-500 + s/2, 500 - s/2) + width/2;
        float z = random(-1000 + s/2, 0 - s/2);
        mountains[i] = new Mountain(s, x, z);
    }

    // initialize water
    // find a place to put the water that doesn't intersect the mountains
    float r = water.r;
    do {
        water.x = random(-500 + r, 500 - r) + width/2;
        water.z = random(-1000 + r, 0 - r);
    } while (collision(water.x, water.z, r));

    // initialize agent
    r = 15;
    agent.body.r = r;
    agent.body.c = color(255, 0, 0);
    do {
        agent.body.x = random(-500 + r, 500 - r) + width/2;
        agent.body.z = random(-1000 + r, 0 - r);
    } while (collision(agent.body.x, agent.body.z, r));
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
    water.draw();

    // draw agent
    agent.draw();

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