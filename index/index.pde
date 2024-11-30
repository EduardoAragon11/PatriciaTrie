
PatriciaTrie trie;
String input = ""; // Entrada del usuario

void setup() {
    size(1800, 1000);
    trie = new PatriciaTrie();
}

void draw() {
    background(255);
    textSize(16);
    fill(0);
    text("Input: " + input, 50, 50);
    text("Encoded: " + encodeString(input), 50, 80);
    trie.draw();
}

void keyPressed() {
    if (key == '\n' || key == '\r') {
        if (!input.isEmpty()) {
            trie.insert(encodeString(input), input);
            input = "";
        }
    } else if (key == BACKSPACE && input.length() > 0) {
        input = input.substring(0, input.length() - 1);
    } else if (key != CODED) {
        input += key;
    }
}
