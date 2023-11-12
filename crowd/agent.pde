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

    public Agent() {
        body = new Circle();
    }
    public Agent(float x, float z, float r) {
        body = new Circle(x, z, r);
    }

    public void draw() {
        body.draw();
    }
}