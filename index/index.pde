PatriciaTrie trie;
String input = "";
boolean isInsertMode = true;
String[] results; // Arreglo de resultados
String noResultMessage = "No matches found."; // Mensaje para resultados vacíos

void setup() {
    size(1800, 1000);
    trie = new PatriciaTrie();
    results = new String[0]; // Inicializar resultados vacíos
}

void draw() {
    background(255);
    textSize(16);
    fill(0);
    text("Mode: " + (isInsertMode ? "Insert" : "Search"), 50, 30);
    text("Input: " + input, 50, 50);
    text("Encoded: " + encodeString(input), 50, 80);
    
    if (!isInsertMode) {
        text("Search Results:", 50, 110);
        if (results.length == 0) {
            text(noResultMessage, 50, 140); // Mostrar mensaje si no hay resultados
        } else {
            int yOffset = 140;
            for (String res : results) {
                text("- " + res, 50, yOffset); // Mostrar cada resultado
                yOffset += 20; // Incrementar espacio entre líneas
            }
        }
    }
    trie.draw();
}

void keyPressed() {
    if (key == '\n' || key == '\r') { // Enter key
        if (!input.isEmpty()) {
            if (isInsertMode) {
                trie.insert(encodeString(input), input); // Insertar en el trie
            } else {
                results = trie.search(encodeString(input)); // Buscar en el trie
            }
            input = "";
        }
    } else if (key == BACKSPACE && input.length() > 0) {
        input = input.substring(0, input.length() - 1);
    } else if (key == CODED) {
        // Ignorar teclas codificadas
    } else if (key == ' ') {
        isInsertMode = !isInsertMode;
        results = new String[0]; // Limpiar resultados al cambiar de modo
        input = "";
    } else {
        input += key;
    }
}
