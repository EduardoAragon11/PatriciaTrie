#ifndef PATRICIATRIE_H
#define PATRICIATRIE_H

#include <string>
#include <vector>
#include <algorithm>
#include <cctype>
#include <iostream>

// Nodo del Patricia Trie
struct Node {
    std::string bin;
    Node* left;
    Node* right;
    bool isLeaf;
    std::string value;

    Node(std::string b, bool leaf, std::string val)
            : bin(b), isLeaf(leaf), value(val), left(nullptr), right(nullptr) {}
};

// Clase Patricia Trie
class PatriciaTrie {
private:
    Node* root;

    // Función recursiva para insertar en el trie
    Node* insertTrie(Node* node, const std::string& binario, const std::string& value) {
        if (node == nullptr) {
            return new Node(binario, true, value);
        }

        std::string nodeBin = node->bin;
        int diffBit = firstDifferentBit(binario, nodeBin);

        if (binario == nodeBin) {
            return node;
        }

        if (diffBit == nodeBin.length()) {
            if (binario[diffBit] == '0') {
                node->left = insertTrie(node->left, binario.substr(diffBit), value);
            } else {
                node->right = insertTrie(node->right, binario.substr(diffBit), value);
            }
            return node;
        } else if (diffBit == binario.length()) {
            Node* newNode = new Node(binario, true, value);
            node->bin = nodeBin.substr(diffBit);
            if (nodeBin[diffBit] == '0') {
                newNode->left = node;
            } else {
                newNode->right = node;
            }
            return newNode;
        } else {
            Node* newNode = new Node(binario.substr(0, diffBit), false, "");
            node->bin = nodeBin.substr(diffBit);

            if (binario[diffBit] == '0') {
                newNode->right = node;
                newNode->left = insertTrie(newNode->left, binario.substr(diffBit), value);
            } else {
                newNode->left = node;
                newNode->right = insertTrie(newNode->right, binario.substr(diffBit), value);
            }
            return newNode;
        }
    }

    // Función recursiva para buscar en el trie
    Node* searchTrie(Node* node, const std::string& binario) {
        if (node == nullptr) return nullptr;

        int diffBit = firstDifferentBit(node->bin, binario);
        std::string nodeBin = node->bin;

        if (diffBit == binario.length()) {
            return node;
        } else if (diffBit == nodeBin.length()) {
            if (binario[diffBit] == '0') {
                return searchTrie(node->left, binario.substr(diffBit));
            } else {
                return searchTrie(node->right, binario.substr(diffBit));
            }
        } else {
            return nullptr;
        }
    }

    // Función recursiva para eliminar en el trie
    Node* deleteTrie(Node* node, Node* parent, const std::string& binario, bool& deleted) {
        if (node == nullptr) return nullptr;

        int diffBit = firstDifferentBit(node->bin, binario);

        if (diffBit == binario.length() && node->isLeaf) {
            // Caso: nodo hoja encontrado
            deleted = true;
            delete node;
            return nullptr;
        }

        if (diffBit == node->bin.length()) {
            if (binario[diffBit] == '0') {
                node->left = deleteTrie(node->left, node, binario.substr(diffBit), deleted);
            } else {
                node->right = deleteTrie(node->right, node, binario.substr(diffBit), deleted);
            }
        }

        // Caso: nodo interno con un solo hijo después de la eliminación
        if (node->left == nullptr && node->right != nullptr && !node->isLeaf) {
            Node* temp = node->right;
            delete node;
            return temp;
        } else if (node->right == nullptr && node->left != nullptr && !node->isLeaf) {
            Node* temp = node->left;
            delete node;
            return temp;
        }

        return node;
    }

    // Encontrar el primer bit diferente entre dos claves
    int firstDifferentBit(const std::string& key1, const std::string& key2) {
        int minLength = std::min(key1.length(), key2.length());
        for (int i = 0; i < minLength; ++i) {
            if (key1[i] != key2[i]) return i;
        }
        return minLength;
    }

    // Obtener los resultados desde un prefijo
    std::vector<std::string> resultPreffix(Node* node) {
        std::vector<std::string> result;
        if (node == nullptr) return result;

        if (node->isLeaf) result.push_back(node->value);
        auto leftResult = resultPreffix(node->left);
        auto rightResult = resultPreffix(node->right);

        result.insert(result.end(), leftResult.begin(), leftResult.end());
        result.insert(result.end(), rightResult.begin(), rightResult.end());

        return result;
    }

public:
    // Constructor
    PatriciaTrie() {
        root = new Node("", false, "");
    }

    // Insertar una clave
    void insert(const std::string& bin, const std::string& value) {
        if (bin[0] == '0') {
            root->left = insertTrie(root->left, bin, value);
        } else {
            root->right = insertTrie(root->right, bin, value);
        }
    }

    // Buscar una clave
    std::vector<std::string> search(const std::string& bin) {
        Node* node = nullptr;
        if (bin[0] == '0') {
            node = searchTrie(root->left, bin);
        } else {
            node = searchTrie(root->right, bin);
        }

        std::vector<std::string> result;
        if (node == nullptr) return result;
        return resultPreffix(node);
    }

    // Eliminar una clave
    bool deleteKey(const std::string& bin) {
        bool deleted = false;
        if (bin.empty()) return false;

        if (bin[0] == '0') {
            root->left = deleteTrie(root->left, root, bin, deleted);
        } else {
            root->right = deleteTrie(root->right, root, bin, deleted);
        }

        return deleted;
    }
};

std::string encodeChar(char c) {
    int a;
    std::string binary;

    if (std::isupper(c)) {
        a = c - 'A' + 1; // Mayúsculas
    } else if (std::islower(c)) {
        a = c - 'a' + 27; // Minúsculas (desplazamos el rango)
    } else {
        throw std::invalid_argument("El carácter no es una letra válida.");
    }

    int cont = 0;
    while (a > 0) {
        binary = std::to_string(a % 2) + binary;
        a /= 2;
        cont++;
    }

    while (cont < 6) { // Usamos al menos 6 bits para acomodar ambos rangos
        binary = "0" + binary;
        cont++;
    }

    return binary;
}

// Función para codificar una cadena completa
std::string encodeString(const std::string& word) {
    std::string binary;
    for (char c : word) {
        binary += encodeChar(c);
    }
    return binary;
}

#endif // PATRICIATRIE_H
