import java.util.List;
import java.util.ArrayList;

class PatriciaTrie {
    Node root;

    PatriciaTrie() {
        root = new Node("", false, "");
    }

    void insert(String bin, String value) {
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
        if(binario.equals(nodeBin)) return node;
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
    
    List<String> search (String bin){
        Node node;
        if(bin.charAt(0) == '0'){
            node = searchTrie(root.left,bin);
        }
        else {
            node = searchTrie(root.right,bin);
        }
        List<String> result = new ArrayList<String>();
        if(node == null) return result;
        else {
            return resultPreffix (node);
        }
    }
    
    List<String> resultPreffix(Node node){
        List<String> result = new ArrayList<String>();
        if(node == null) return result;
        if(node.isLeaf) result.add(node.value);
        result.addAll(resultPreffix(node.left));
        result.addAll(resultPreffix(node.right));
        return result;
    }
    
    Node searchTrie(Node node, String binario){
        if(node == null) return null;
        int diffBit = firstDifferentBit(node.bin, binario);
        String nodeBin = node.bin;
        if (diffBit == binario.length()) {
            return node;
        }
        else if(diffBit == nodeBin.length()){
            if(binario.charAt(diffBit) == '0') return searchTrie(node.left, binario.substring(diffBit));
            else return searchTrie(node.right, binario.substring(diffBit));
        }
        else {
            return null;
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
    void drawTree(Node node, float x, float y, float xOffset, int level) {
        if (node == null) return;

        if (node.left != null) {
            line(x, y, x - xOffset, y + 75);
            drawTree(node.left, x - xOffset, y + 75, xOffset / 2, level + 1);
        }

        if (node.right != null) {
            line(x, y, x + xOffset, y + 75);
            drawTree(node.right, x + xOffset, y + 75, xOffset / 2, level + 1);
        }
        fill(255);
        circle(x, y, 20 - level);
        fill(0);
        if (node.isLeaf) {
            text(node.value, x - 4 * node.value.length(), y + 30);
        } else {
            text(node.bin, x - 3 * node.bin.length(), y + 30);
        }
        
    }

    void draw() {
        drawTree(root, width / 2, 50, width / 4, 0);
    }
}
