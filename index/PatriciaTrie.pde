class PatriciaTrie {
    Node root;

    PatriciaTrie() {
        root = new Node("", false, "");
    }

    // Inserta una clave binaria con su valor
    void insert(String bin, String value) {
        bin = encodeString(bin);
        if(bin.charAt(0) == '0'){
            root.left = insertTrie(root.left,bin,value);
        }
        else {
            root.right = insertTrie(root.right,bin,value);
        }
    }
    
    Node insertTrie (Node node, String binario, String value){
        if(node == null){
            return new Node(binario, true, value);
        }
        String nodeBin = node.bin;
        int diffBit = firstDifferentBit(binario, nodeBin);
        if(binario == nodeBin) return node;
        if(diffBit == nodeBin.length()){
            if(binario.charAt(diffBit) == '0') node.left = insertTrie(node.left, binario.substring(diffBit), value);
            else node.right = insertTrie(node.right, binario.substring(diffBit), value);
            return node;
        }
        else if (diffBit == binario.length()) {
            Node newNode = new Node(binario, true, value);
            node.bin = node.bin.substring(diffBit);
            if(nodeBin.charAt(diffBit) == '0') newNode.left = node;
            else newNode.right = node;
            return newNode;
        }
        else {
            Node newNode = new Node(binario.substring(0,diffBit), false, "");
            node.bin = node.bin.substring(diffBit);
            if(binario.charAt(diffBit) == '0'){
                newNode.right = node;
                newNode.left = insertTrie(newNode.left, binario.substring(diffBit), value);
            }
            else {
                newNode.left = node;
                newNode.right = insertTrie(newNode.right, binario.substring(diffBit), value);
            }
            return newNode;
        }
    }

    // Encuentra el primer bit diferente entre dos claves
    int firstDifferentBit(String key1, String key2) {
        int minLength = min(key1.length(), key2.length());
        for (int i = 0; i < minLength; i++) {
            if (key1.charAt(i) != key2.charAt(i)) return i;
        }
        return minLength;
    }

    // Dibujar el Patricia Tree
    void drawTree(Node node, float x, float y, float xOffset) {
        if (node == null) return;

        fill(255);
        circle(x, y, 30);
        fill(0);
        if (node.isLeaf) {
            text(node.value, x - 10, y + 5);
        } else {
            text("Bit " + node.bin, x - 10, y + 5);
        }

        if (node.left != null) {
            line(x, y + 15, x - xOffset, y + 75);
            drawTree(node.left, x - xOffset, y + 100, xOffset / 2);
        }

        if (node.right != null) {
            line(x, y + 15, x + xOffset, y + 75);
            drawTree(node.right, x + xOffset, y + 100, xOffset / 2);
        }
    }

    void draw() {
        drawTree(root, width / 2, 50, width / 4);
    }
}
