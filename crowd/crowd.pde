Mountain[] mountains = new Mountain[20];
Camera camera;

Circle water = new Circle();
Agent agent = new Agent();
PRM prm = new PRM();
float agent_r = 15;
boolean paused = true;

void setup() {
    size(1280, 720, P3D);
    camera = new Camera();
    frameRate(60);

    for (int i = 0; i < mountains.length; i++) {
        float s = random(50, 250);
        float x = random(-500 + s/2 + agent_r*4, 500 - s/2 - agent_r*4) + width/2;
        float z = random(-1000 + s/2 + agent_r*4, 0 - s/2 - agent_r*4);
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
    r = agent_r;
    agent.body.r = r;
    agent.body.c = color(255, 0, 0);
    do {
        agent.body.x = random(-500 + r, 500 - r) + width/2;
        agent.body.z = random(-1000 + r, 0 - r);
    } while (collision(agent.body.x, agent.body.z, r));

    // initialize the PRM
    prm.build(mountains, mountains.length);
}

void draw() {
    // start paused
    if (paused) {
        return;
    }
    float dt = 1.0/frameRate;
    camera.Update(dt);
    // move the camera closer to the agent
    float dx = agent.body.x - camera.position.x;
    float dy = height - 300 - camera.position.y;
    float dz = agent.body.z - camera.position.z;
    float cam_speed = 30*dt;
    float mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (mag > cam_speed) {
        dx *= cam_speed/mag;
        dy *= cam_speed/mag;
        dz *= cam_speed/2.0/mag;
        camera.position.x += dx;
        camera.position.y += dy;
        camera.position.z += dz;
    }
    // compute target phi pointing at agent
    float target_phi = -atan2(agent.body.z - camera.position.z, height - 100 - camera.position.y) - PI/2.0;
    // println(target_phi);
    // point the camera towards the agent
    float da = 0.00003*dt*mag;
    if (camera.phi < target_phi - da) {
        camera.phi += da;
    } else if (camera.phi > target_phi + da) {
        camera.phi -= da;
    }
    // align the camera to yz plane
    if (camera.theta > 0.1*dt) {
        camera.theta -= 0.1*dt;
    } else if (camera.theta < -0.1*dt) {
        camera.theta += 0.1*dt;
    }


    // update agent
    agent.update(dt);

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

    // draw PRM
    prm.draw();

    // draw blue circle for water
    water.draw();

    // draw agent
    agent.draw();

}

void keyPressed() {
    if (key == ' ') {
        paused = !paused;
    }
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