// two arm character reaches toward mouse with whichever arm can reach it
color LIGHT_YELLOW = color(255, 255, 100, 150);
color LIGHT_PURPLE = color(255, 100, 255, 200);
boolean increase = true;

Arm[] arms = new Arm[4];
Arm body;
Target target;
Vec2 body_root;
boolean reached = false;
int num_reached = 0;
int bounce = 0;
boolean bounce_ready = false;
float dt = 0;
int root_target_x = 0;
int root_start_x = 0;
float c1 = 0.04, c2 = 4, c3 = -100;
Camera camera;

void setup() {
    size(1280, 720, P3D);
    background(255);
    frameRate(30);
    camera = new Camera();
    // initialize the body
    body_root = new Vec2(width/2, height-100);
    body = new Arm(2, body_root, 31);
    // set body joint limits
    body.links[0].a_max = -3*PI/8;
    body.links[0].a_min = -5*PI/8;
    body.links[1].a_max = 1*PI/8;
    body.links[1].a_min = -1*PI/8;
    // initialize the arms accross the bottom of the screen
    for (int i = 0; i < arms.length; i++) {
        arms[i] = new Arm(4, new Vec2(0, 0), 20);
    }
    // set joint limits of first arm links smaller
    float da = PI/16;
    arms[0].links[0].a_max_0 = 0;
    arms[0].links[0].a_min_0 = -PI/4 + da;
    arms[1].links[0].a_max_0 = -PI/4 - da;
    arms[1].links[0].a_min_0 = -PI/2 + da;
    arms[2].links[0].a_max_0 = -PI/2 - da;
    arms[2].links[0].a_min_0 = -3*PI/4 + da;
    arms[3].links[0].a_max_0 = -3*PI/4 - da;
    arms[3].links[0].a_min_0 = -PI;
    // initialize the target
    target = new Target(50);
}

void draw() {
    camera.Update(1.0/frameRate);
    dt = 1/frameRate;
    // background light blue
    background(100, 200, 255);
    noStroke();
    noCursor();
    lights();

    // draw the floor as a sand colored cube
    fill(255, 255, 200);
    pushMatrix();
    translate(width/2, height-50, 0);
    box(500, 100, 100);
    popMatrix();

    // update the body
    body.update(body_root);
    // draw the body
    body.draw();

    // update arm angle limits
    for (int i = 0; i < arms.length; i++) {
        arms[i].links[0].update_angle_limits(body.links[0].a, body.links[1].a);
    }


    // update the arms
    for (int i = 0; i < arms.length; i++) {
        arms[i].update(body.eef);
    }
    // draw the arms
    for (int i = 0; i < arms.length; i++) {
        arms[i].draw();
    }
    // draw the target
    target.draw();


    // check if any eef is touching the target
    num_reached = 0;
    for (int i = 0; i < arms.length; i++) {
        if (arms[i].reached_target(target)) {
            num_reached += 1;
        }
    }
    if (num_reached > 0) {
        reached = true;
    } else {
        reached = false;
    }
    // if not reached, bounce
    if (!reached) {
        if (bounce_ready) {
            // set start x to nearest 100 of root rel
            float root_rel = body.root.x - width/2;
            root_start_x = round(root_rel / 100)*100;
            if (mouseX < body.root.x - 100) {
                root_target_x = root_start_x - 100;
                // limit root target x
                bounce = 1;
                bounce_ready = false;
                if (root_target_x < -200) {
                    root_target_x = -200;
                    bounce = 0;
                }
            } else if (mouseX > body.root.x + 100) {
                root_target_x = root_start_x + 100;
                // limit root target x
                bounce = 1;
                bounce_ready = false;
                if (root_target_x > 200) {
                    root_target_x = 200;
                    bounce = 0;
                }
            }
        }
    } else {
        if(bounce == 0) root_target_x = root_start_x;
        // shrink the target r with dt
        float old_r = target.r;
        target.r -= num_reached*dt*2;
        // limit target r to 0
        if (target.r < 0) {
            target.r = 0;
        }
        body.links[0].r2 += old_r - target.r;
        // limit r2 to 45
        if (body.links[0].r2 > 45) {
            body.links[0].r2 = 45;
        }
        body.links[1].r1 = body.links[0].r2;
    }

    // bounce the body root
    if (bounce == 0) {
        body.links[0].r1 += 20*dt;
        if (body.links[0].r1 > 45) {
            body.links[0].r1 = 45;
            bounce_ready = true;
        } else {
            bounce_ready = false;
        }
    }
    if (bounce > 0) {
        // shorten the base link quickly
            body.links[0].r1 -= 100*dt;
            if (body.links[0].r1 < 31) {
                body.links[0].r1 = 31;
                // bounce = 2;
                bounce_ready = false;
            }
            // set the parabola parameters
            if (root_start_x == 200) {
                if (root_target_x == 100) {
                    c1 = 0.04;
                    c2 = -12;
                    c3 = 700;
                } 
            } else if (root_start_x == 100) {
                if (root_target_x == 0) {
                    c1 = 0.04;
                    c2 = -4;
                    c3 = -100;
                } else if (root_target_x == 200) {
                    c1 = 0.04;
                    c2 = -12;
                    c3 = 700;
                }
            } else if (root_start_x == 0) {
                if (root_target_x == -100) {
                    c1 = 0.04;
                    c2 = 4;
                    c3 = -100;
                } else if (root_target_x == 100) {
                    c1 = 0.04;
                    c2 = -4;
                    c3 = -100;
                }
            } else if (root_start_x == -100) {
                if (root_target_x == -200) {
                    c1 = 0.04;
                    c2 = 12;
                    c3 = 700;
                } else if (root_target_x == 0) {
                    c1 = 0.04;
                    c2 = 4;
                    c3 = -100;
                }
            } else if (root_start_x == -200) {
                if (root_target_x == -100) {
                    c1 = 0.04;
                    c2 = 12;
                    c3 = 700;
                }
            }
            // update x based on dt
            float dx = 100*dt;
            boolean left = (root_target_x - root_start_x < 0);
            if (left) {
                dx *= -1;
            }
            body.root.x += dx;
            // limit x to target x
            float root_rel = body.root.x - width/2;
            if (left && root_rel <= root_target_x) {
                body.root.x = root_target_x + width/2;
                bounce = 0;
                bounce_ready = false;
            } else if (!left && root_rel >= root_target_x) {
                body.root.x = root_target_x + width/2;
                bounce = 0;
                bounce_ready = false;
            }
            float x = body.root.x - width/2;
            // update y based on x
            float y = c1*x*x + c2*x + c3;
            // limit y to -100
            if (y > -100) {
                y = -100;
                // print start x and target x and root rel
                println("start x: " + root_start_x + " target x: " + root_target_x + " root rel: " + root_rel);
            }
            body.root.y = height+y;
            // print x and y
            // println("x: " + x + " y: " + y);
    }

    // // modulate the length of the base link
    // if (increase) {
    //     body.links[0].l += 1;
    //     if (body.links[0].l > 200) {
    //         increase = false;
    //     }
    // } else {
    //     body.links[0].l -= 1;
    //     if (body.links[0].l < 30) {
    //         increase = true;
    //     }
    // }
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

void keyPressed() {
    camera.HandleKeyPressed();
}

void keyReleased() {
    camera.HandleKeyReleased();
}