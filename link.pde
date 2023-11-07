public class Arm {
    Link[] links;
    Target target;
    Vec2 eef = new Vec2(0, 0);
    Vec2 root = new Vec2(0, 0);

    public Arm(int num_links, Vec2 start, Vec2 target) {
        this.root = start;
        links = new Link[num_links];
        this.target = new Target(target);
        for (int i = 0; i < num_links; i++) {
            links[i] = new Link(start, 0);
            links[i].l = 100 - i * 10;
            // r1 is previous link's r2
            if (i > 0)
                links[i].r1 = links[i - 1].r2;
            else {
                links[i].r1 = 20;
                // set angle limits 0 to 180
                links[i].a_max = 0;
                links[i].a_min = -PI;
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
    public void update() {
        // set target position to mouse position
        target.pos = new Vec2(mouseX, mouseY);
        for (int i = links.length - 1; i >= 0; i--) {
            links[i].update(target.pos, eef);
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

    // draw the arm
    public void draw() {
        for (int i = 0; i < links.length; i++) {
            links[i].draw();
        }
        target.draw();
    }

}

public class Link {
    Vec2 start = new Vec2(0, 0);
    Vec2 center = new Vec2(0, 0);
    float a = 0;
    float a_max = PI / 2;
    float a_min = -PI / 2;
    float l = 50;
    Vec2 end = new Vec2(0, 0);
    float r1 = 20;
    float r2 = 20;

    public Link(Vec2 start, float a) {
        this.start = start;
        this.a = a;
    }

    public Link() {
    }

    // update the link
    public void update(Vec2 target, Vec2 eef) {
        Vec2 start_target = target.subtract_new(start);
        Vec2 start_end = eef.subtract_new(start);
        float dot_prod = dot(start_target.normalize(), start_end.normalize());
        dot_prod = constrain(dot_prod, -1.0, 1.0);
        float da = acos(dot_prod);
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
        fill(LIGHT_YELLOW);
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
    Vec2 pos = new Vec2(0, 0);
    float r = 18.0;

    public Target(Vec2 pos) {
        this.pos = pos;
    }

    public Target() {
    }

    // draw the target
    public void draw() {
        fill(0, 255, 255);
        pushMatrix();
        translate(pos.x, pos.y, 0);
        sphere(r);
        popMatrix();
    }
}