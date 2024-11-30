import java.util.List;
import java.util.ArrayList;

PatriciaTrie trie;
String input = "";
boolean isInsertMode = true;
List<String> results; // Lista de resultados
String noResultMessage = "No matches found."; // Mensaje para resultados vacíos

void setup() {
    size(1900, 1000);
    trie = new PatriciaTrie();
    results = new ArrayList<>();
}

void draw() {
    background(240); // Fondo gris claro
    textSize(16);
    fill(0);
    text("Mode: " + (isInsertMode ? "Insert" : "Search"), 50, 30);
    text("Input: " + input, 50, 50);
    text("Encoded: " + encodeString(input), 50, 80);

    if (!isInsertMode) {
        text("Search Results:", 50, 110);
        if (results.isEmpty()) {
            fill(255, 0, 0); // Rojo para mensajes de error
            text(noResultMessage, 50, 140);
        } else {
            int yOffset = 140;
            fill(0); // Negro para resultados
            for (String res : results) {
                text("- " + res, 50, yOffset);
                yOffset += 20;
            }
        }
    }

    // Dibujar el trie
    if (trie.root != null) {
        trie.drawTree(trie.root, width / 2, 100, width / 4, 0);
    }
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
        results.clear(); // Limpiar resultados al cambiar de modo
        input = "";
    } else {
        input += key;
    }
}
