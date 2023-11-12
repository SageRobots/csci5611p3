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

    public boolean collision_line(float x1, float z1, float x2, float z2) {
        // create box
        Box box = new Box();
        box.x = x;
        box.y = z;
        box.w = s + agent.body.r*2;
        box.h = box.w;
        // create line segment
        LineSegment seg = new LineSegment();
        seg.x1 = x1;
        seg.y1 = z1;
        seg.x2 = x2;
        seg.y2 = z2;

        // check if line intersects with mountain
        return segment_box(seg, box);
    }
}

public class LineSegment {
    public int id;
    public float x1, y1, x2, y2;
    public float xmin, xmax;
    public float ymin, ymax;
    public boolean in1, in2;

    public LineSegment() {
        id = 0;
        x1 = 0;
        y1 = 0;
        x2 = 0;
        y2 = 0;
        xmin = 0;
        xmax = 0;
        ymin = 0;
        ymax = 0;
    }
}

public class Box {
    public int id;
    public float x, y, w, h;
    public float xmin, xmax;
    public float ymin, ymax;
    public boolean in1, in2;

    public Box() {
        id = 0;
        x = 0;
        y = 0;
        w = 0;
        h = 0;
        xmin = 0;
        xmax = 0;
        ymin = 0;
        ymax = 0;
    }
}

int orientation(float x1, float y1, float x2, float y2, float x3, float y3) {
    // check if the points are clockwise, counterclockwise, or collinear
    float val = (y2-y1)*(x3-x1) - (y3-y1)*(x2-x1);
    if (val == 0) return 0; // collinear
    return (val > 0) ? 1 : 2; // clockwise or counterclockwise
}

boolean segment_segment(LineSegment l1, LineSegment l2) { 
    // check if the segments intersect
    float x1 = l1.x1;
    float y1 = l1.y1;
    float x2 = l1.x2;
    float y2 = l1.y2;
    float x3 = l2.x1;
    float y3 = l2.y1;
    float x4 = l2.x2;
    float y4 = l2.y2;
    // compute orientations
    int dir1 = orientation(x1, y1, x3, y3, x4, y4);
    int dir2 = orientation(x2, y2, x3, y3, x4, y4);
    int dir3 = orientation(x1, y1, x2, y2, x3, y3);
    int dir4 = orientation(x1, y1, x2, y2, x4, y4);
    if (dir1 != dir2 && dir3 != dir4) return true;
    // special collinear cases are debatably not collisions
    // not used since they don't help with pinball
    return false;
}

boolean segment_box(LineSegment l, Box b) {
    // create 4 segments from box
    LineSegment[] segments = new LineSegment[4];
    segments[0] = new LineSegment();
    segments[0].x1 = b.x - b.w/2;
    segments[0].y1 = b.y - b.h/2;
    segments[0].x2 = b.x + b.w/2;
    segments[0].y2 = b.y - b.h/2;

    segments[1] = new LineSegment();
    segments[1].x1 = b.x + b.w/2;
    segments[1].y1 = b.y - b.h/2;
    segments[1].x2 = b.x + b.w/2;
    segments[1].y2 = b.y + b.h/2;

    segments[2] = new LineSegment();
    segments[2].x1 = b.x + b.w/2;
    segments[2].y1 = b.y + b.h/2;
    segments[2].x2 = b.x - b.w/2;
    segments[2].y2 = b.y + b.h/2;

    segments[3] = new LineSegment();
    segments[3].x1 = b.x - b.w/2;
    segments[3].y1 = b.y + b.h/2;
    segments[3].x2 = b.x - b.w/2;
    segments[3].y2 = b.y - b.h/2;

    // check l against the segments
    for (int i = 0; i < 4; i++) {
        if (segment_segment(l, segments[i])) {
            return true;
        }
    }

    // check if segment end points are both inside the box
    if (l.x1 >= b.x - b.w/2 && l.x1 <= b.x + b.w/2 && l.y1 >= b.y - b.h/2 && l.y1 <= b.y + b.h/2) {
        return true;
    }
    return false;
}