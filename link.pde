public class Arm {
    Link[] links;
    Vec2 eef = new Vec2(0, 0);
    Vec2 root = new Vec2(0, 0);

    public Arm(int num_links, Vec2 start, float r) {
        this.root = start;
        links = new Link[num_links];
        for (int i = 0; i < num_links; i++) {
            links[i] = new Link(start, 0);
            links[i].l = 100 - i * 10;
            // r1 is previous link's r2
            if (i > 0)
                links[i].r1 = links[i - 1].r2;
            else {
                links[i].r1 = r;
                // set angle limits 0 to 180
                links[i].a_max = 0;
                links[i].a_min = -PI;
                links[i].a = -PI / 2;
            }
            // r2 is % of r1
            links[i].r2 = links[i].r1 * 0.8;
            start = links[i].end;
        }
        fk();
    }

    public Arm() {
    }

    // update the arm
    public void update(Vec2 root) {
        this.root = root;
        // set target position to mouse position
        for (int i = links.length - 1; i >= 0; i--) {
            links[i].update(new Vec2(mouseX, mouseY), eef);
            fk();
        }
    }

    // forward kinematics
    public void fk() {
        float a = 0;
        for (int i = 0; i < links.length; i++) {
            if (i == 0) {
                links[i].start = root;
                a = links[i].a;
            } else {
                links[i].start = links[i - 1].end;
                a += links[i].a;
            }
            links[i].end = new Vec2(cos(a) * links[i].l, sin(a) * links[i].l).add_new(links[i].start);
        }
        // set the end effector position
        eef = links[links.length - 1].end;
    }

    // check if arm reached target
    public boolean reached_target(Target target) {
        float d = dist(eef.x, eef.y, mouseX, mouseY);
        if (d < target.r)
            return true;
        else
            return false;
    }

    // draw the arm
    public void draw() {
        for (int i = 0; i < links.length; i++) {
            links[i].draw();
        }
    }

}

public class Link {
    Vec2 start = new Vec2(0, 0);
    Vec2 center = new Vec2(0, 0);
    float a = 0;
    float a_max = PI / 2;
    float a_min = -PI / 2;
    float a_max_0, a_min_0;
    float l = 50;
    Vec2 end = new Vec2(0, 0);
    float r1 = 20;
    float r2 = 20;
    float acc = 0.1;

    public Link(Vec2 start, float a) {
        this.start = start;
        this.a = a;
    }

    public Link() {
    }

    // update the angle limits
    public void update_angle_limits(float a0, float a1) {
        this.a_min = a_min_0 + (a0 + PI/2) + a1;
        this.a_max = a_max_0 + (a0 + PI/2) + a1;
        // print a_min, a_max, amin_0, amax_0, a0, a1
        // println("a_min: " + a_min + " a_max: " + a_max + " a_min_0: " + a_min_0 + " a_max_0: " + a_max_0 + " a0: " + a0 + " a1: " + a1);
    }

    // update the link
    public void update(Vec2 target, Vec2 eef) {
        // make acc inversely proportional to volume
        acc = 200.0 / (r1 * r1 * r1);
        Vec2 start_target = target.subtract_new(start);
        Vec2 start_end = eef.subtract_new(start);
        float dot_prod = dot(start_target.normalize(), start_end.normalize());
        dot_prod = constrain(dot_prod, -1.0, 1.0);
        float da = acos(dot_prod);
        // limit da to acc
        da = constrain(da, -acc, acc);
        if (cross(start_target, start_end) < 0)
            a += da;
        else
            a -= da;
        // limit the angle
        a = constrain(a, a_min, a_max);
    }

    // draw the link
    public void draw() {
        // set fill light yellow
        // fill(LIGHT_YELLOW);
        fill(LIGHT_PURPLE);
        // draw a sphere at the start
        pushMatrix();
        translate(start.x, start.y);
        sphere(r1);
        popMatrix();

        // draw a sphere at the end
        pushMatrix();
        translate(end.x, end.y);
        sphere(r2);
        popMatrix();

        // draw a cylinder between the start and the end
        pushMatrix();
        // compute center x and y
        center.x = (start.x + end.x) / 2;
        center.y = (start.y + end.y) / 2;
        translate(center.x, center.y);
        float angle = atan2(end.y - start.y, end.x - start.x);
        rotateZ(angle);
        rotateY(PI/2);
        draw_cylinder(30, r1, r2, l);
        popMatrix();

    }
}

// a class to represent the target
class Target {
    float r = 18.0;

    public Target(float r) {
        this.r = r;
    }

    public Target() {
    }

    // draw the target
    public void draw() {
        fill(LIGHT_YELLOW);
        // fill(100, 100, 100, 10);
        pushMatrix();
        translate(mouseX, mouseY, 0);
        sphere(r);
        popMatrix();
    }
}