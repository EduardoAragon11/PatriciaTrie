class Node {
    String bin;
    Node left, right;
    boolean isLeaf;
    String value;

    Node(String b, boolean leaf, String val) {
        bin = b;
        isLeaf = leaf;
        value = val;
        left = null;
        right = null;
    }
}
