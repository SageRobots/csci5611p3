public class Circle {
    public float x, z, r;
    public color c = color(0, 150, 255);
    public Circle() {
        x = 0;
        z = 0;
        r = 50;
    }
    public Circle(float x, float z, float r) {
        this.x = x;
        this.z = z;
        this.r = r;
    }

    public void draw() {
        fill(c);
        pushMatrix();
        translate(x, height-104, z);
        rotateX(PI/2);
        circle(0, 0, 2*r);
        popMatrix();
    }
}

public class Agent {
    // body is circle
    public Circle body;
    private ArrayList<Integer> path = new ArrayList();
    public Vec2 dir = new Vec2(1, 0);
    public Vec2 new_dir = new Vec2(1, 0);
    public boolean rotating = false;

    public Agent() {
        body = new Circle();
    }
    public Agent(float x, float z, float r) {
        body = new Circle(x, z, r);
    }

    public void update(float dt) {
        if (path.size() > 0) {
            // check if we can move to the next node
            if (path.size() > 1) {
                int nextNode = path.get(1);
                boolean valid = true;
                // check line box intersection
                float x1 = body.x;
                float z1 = body.z;
                float x2 = prm.nodes[nextNode].x;
                float z2 = prm.nodes[nextNode].z;
                for (int k = 0; k < mountains.length; k++) {
                    if (mountains[k].collision_line(x1, z1, x2, z2)) valid = false;
                }
                if (valid) {
                    // remove the current node from the path
                    path.remove(0);
                }
            }
            // move along the path
            float speed = 30;
            if (rotating) {
                speed /= 3.0;
            }
            // get the last node on the path
            int lastNode = path.get(0);
            // get the position of the last node
            float lastX = prm.nodes[lastNode].x;
            float lastZ = prm.nodes[lastNode].z;
            // move speed*dt towards the last node
            float dx = lastX - body.x;
            float dz = lastZ - body.z;
            float dist = sqrt(dx*dx + dz*dz);
            if (dist > speed*dt) {
                body.x += speed*dt*dx/dist;
                body.z += speed*dt*dz/dist;
            } else {
                // reached the last node
                // remove the last node from the path
                path.remove(0);
            }
            // update the direction of the agent
            new_dir.x = dx/dist;
            new_dir.y = dz/dist;
            // limit the rate of direction change
            float max_angle = 0.05f;
            float angle = acos(dot(dir, new_dir));
            // determine the direction of rotation
            float cross = dir.x*new_dir.y - dir.y*new_dir.x;
            if (cross < 0) {
                angle = -angle;
            }
            if (angle > max_angle) {
                // rotate towards the new direction
                dir = rotate_point(new Vec2(0,0), dir, max_angle);
                rotating = true;
            } else if (angle < -max_angle) {
                // rotate towards the new direction
                dir = rotate_point(new Vec2(0,0), dir, -max_angle);
                rotating = true;
            } else {
                // set the direction to the new direction
                dir.x = new_dir.x;
                dir.y = new_dir.y;
                rotating = false;
            }
        }
    }

    public void draw() {
        // draw a sphere at the agent's position
        fill(body.c);
        pushMatrix();
        translate(body.x, height-100, body.z);
        sphere(body.r);
        // translate in dir
        translate(body.r*dir.x, 0, body.r*dir.y);
        // draw a smaller sphere
        sphere(body.r/2);
        popMatrix();
    }
}