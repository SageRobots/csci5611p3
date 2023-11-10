public class Node {
    public float x, y;
    public int num_neighbors;
    public Node[] neighbors = new Node[10];
    Node() {
        x = 0;
        y = 0;
        num_neighbors = 0;
    }

    public void add_neighbor(Node n) {
        neighbors[num_neighbors] = n;
        num_neighbors++;
    }
}

public class PRM {
    PRM() {
    }

    public void build() {
        generate_nodes();
        connect_nodes();
    }
}