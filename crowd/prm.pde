public class Node {
    public int id;
    public float x, z;
    public int num_neighbors;
    public int max_neighbors = 20;
    public Node[] neighbors = new Node[max_neighbors];
    public boolean visited = false;
    public int parent = -1;

    Node() {
        x = 0;
        z = 0;
        num_neighbors = 0;
    }

    public void add_neighbor(Node n) {
        if (num_neighbors == max_neighbors) return;
        neighbors[num_neighbors] = n;
        num_neighbors++;
    }

    public void draw() {
        int h_offset = 101;
        // fill orange
        color ORANGE = color(255, 165, 0, 20);
        fill(ORANGE);
        noStroke();
        // draw circle
        pushMatrix();
        translate(x, height-h_offset, z);
        rotateX(PI/2);
        circle(0, 0, 10);
        popMatrix();
        // draw lines to neighbors
        for (int i = 0; i < num_neighbors; i++) {
            stroke(ORANGE);
            strokeWeight(1);
            line(x, height-h_offset, z, neighbors[i].x, height-h_offset, neighbors[i].z);
        }
    }
}

public class PRM {
    public Node[] nodes = new Node[100];
    public int num_nodes = 0;
    private ArrayList<Integer> path = new ArrayList();

    PRM() {
    }

    public void build(Mountain[] mountains, int num_mountains) {
        generate_nodes(mountains, num_mountains);
        connect_nodes(mountains, num_mountains);
        // run BFS
        run_BFS();
    }

    private void generate_nodes(Mountain[] mountains, int num_mountains) {
        // create agent node
        nodes[0] = new Node();
        nodes[0].x = agent.body.x;
        nodes[0].z = agent.body.z;
        nodes[0].id = 0;
        num_nodes++;
        // create water node
        nodes[1] = new Node();
        nodes[1].x = water.x;
        nodes[1].z = water.z;
        nodes[1].id = 1;
        num_nodes++;
        for (int i = 2; i < 100; i++) {
            nodes[i] = new Node();
            boolean valid;
            do {
                valid = true;
                // x between -500 and 500
                float r = agent.body.r;
                nodes[i].x = random(-500 + r, 500 - r) + width/2;
                nodes[i].z = random(-1000 + r, 0 - r);
                // check if node is in a mountain
                for (int j = 0; j < num_mountains; j++) {
                    if(mountains[j].collision(nodes[i].x, nodes[i].z, r)) valid = false;
                }
                // check if node is too close to another node
                for (int j = 0; j < num_nodes; j++) {
                    if (i != j) {
                        if (dist(nodes[i].x, nodes[i].z, nodes[j].x, nodes[j].z) < 50) valid = false;
                    }
                }
            } while(!valid);
            // set id
            nodes[i].id = i;
            num_nodes++;
        }
    }

    private void connect_nodes(Mountain[] mountains, int num_mountains) {
        for (int i = 0; i < num_nodes; i++) {
            for (int j = 0; j < num_nodes; j++) {
                if (i != j) {
                    boolean valid = true;
                    // check if the node is close enough to connect
                    if (dist(nodes[i].x, nodes[i].z, nodes[j].x, nodes[j].z) > 200) valid = false;
                    // check if there is a mountain between the nodes
                    for (int k = 0; k < num_mountains; k++) {
                        if (mountains[k].collision_line(nodes[i].x, nodes[i].z, nodes[j].x, nodes[j].z)) valid = false;
                    }
                    if (valid) {
                        nodes[i].add_neighbor(nodes[j]);
                        nodes[j].add_neighbor(nodes[i]);
                    }
                }
            }
        }
    }

    //BFS
    void run_BFS(){
        int start = 0;
        int goal = 1;
        ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
        path = new ArrayList(); //Reset path

        println("\nBeginning Search");
        
        nodes[start].visited = true;
        fringe.add(start);
        println("Adding node", start, "(start) to the fringe.");
        println(" Current Fringe: ", fringe);
        
        while (fringe.size() > 0){
            int currentNode = fringe.get(0);
            fringe.remove(0);
            if (currentNode == goal){
                println("Goal found!");
                break;
            }
            for (int i = 0; i < nodes[currentNode].num_neighbors; i++){
                int j = nodes[currentNode].neighbors[i].id;
                if (!nodes[j].visited){
                    nodes[j].visited = true;
                    nodes[j].parent = currentNode;
                    fringe.add(j);
                    println("Added node", j, "to the fringe.");
                    println(" Current Fringe: ", fringe);
                }
            } 
        }
        
        print("\nReverse path: ");
        int prevNode = nodes[goal].parent;
        path.add(0,goal);
        print(goal, " ");
        while (prevNode >= 0){
            print(prevNode," ");
            path.add(0,prevNode);
            prevNode = nodes[prevNode].parent;
        }
        print("\n");
    }

    public void draw() {
        for (int i = 0; i < num_nodes; i++) {
            nodes[i].draw();
        }
        // draw path
        stroke(0, 255, 0);
        strokeWeight(3);
        for (int i = 0; i < path.size()-1; i++) {
            line(nodes[path.get(i)].x, height-101, nodes[path.get(i)].z, nodes[path.get(i+1)].x, height-101, nodes[path.get(i+1)].z);
        }
        noStroke();
    }
}