public class Mountain {
    public float s = 100;
    public float x = 0;
    public float z = 0;

    public Mountain(float s, float x, float z) {
        this.s = s;
        this.x = x;
        this.z = z;
    }

    public void draw() {
        pushMatrix();
        translate(x, height-105, z);
        // fill dark gray
        fill(140, 140, 140);
        // draw as stacked boxes
        box(s, 10, s);
        float s2 = s;
        while (s2 >= 40) {
            s2 -= 15;
            translate(0, -10, 0);
            box(s2, 10, s2);
        }
        popMatrix();
    }

    public boolean collision(float cx, float cz, float r) {
        // check if circle is intersecting with mountain
        if (cx + r > x - s/2 && cx - r < x + s/2 && cz + r > z - s/2 && cz - r < z + s/2) {
            return true;
        }
        return false;
    }
}