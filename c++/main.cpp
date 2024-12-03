#include "PatriciaTrie.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <chrono>
#include <random>

// Función para medir tiempo de ejecución
template <typename Func, typename... Args>
long long measureExecutionTime(Func func, Args&&... args) {
    auto start = std::chrono::high_resolution_clock::now();
    func(std::forward<Args>(args)...);
    auto end = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
}

// Función para generar una clave aleatoria
std::string generateRandomKey(size_t length = 10) {
    static const char charset[] =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz";
    static std::default_random_engine rng(std::random_device{}());
    static std::uniform_int_distribution<size_t> dist(0, sizeof(charset) - 2);

    std::string key;
    for (size_t i = 0; i < length; ++i) {
        key += charset[dist(rng)];
    }
    return key;
}

// Función para verificar si el trie está vacío
bool isEmpty(PatriciaTrie& trie) {
    return trie.search("0").empty() && trie.search("1").empty();
}

// Función para vaciar el trie
void clearTree(PatriciaTrie& trie) {
    trie = PatriciaTrie();
}

// Función para ejecutar pruebas de rendimiento
void runTests() {
    std::ofstream outFile("execution_times.csv");
    outFile << "Size,Operation,Time\n";

    for (size_t size : {10000, 100000, 1000000}) {
        PatriciaTrie trie;
        std::vector<std::string> keys;

        // Generar claves aleatorias y medir tiempos de inserción
        for (size_t i = 0; i < size; ++i) {
            std::string key = generateRandomKey(8);
            keys.push_back(key);

            long long time = measureExecutionTime([&]() {
                trie.insert(encodeString(key), key);
            });
            outFile << size << ",Insert," << time << "\n";
        }
        
        // Medir tiempos de búsqueda
        for (const auto& key : keys) {
            long long time = measureExecutionTime([&]() {
                trie.search(encodeString(key));
            });
            outFile << size << ",Search," << time << "\n";
        }

        // Medir tiempos de eliminación
        for (const auto& key : keys) {
            long long time = measureExecutionTime([&]() {
                trie.deleteKey(encodeString(key));
            });
            outFile << size << ",Delete," << time << "\n";
        }
    }

    outFile.close();
    std::cout << "Pruebas completadas. Resultados guardados en 'execution_times.csv'.\n";
}

int main() {
    PatriciaTrie trie;
    int choice;
    std::string input, value;

    do {
        std::cout << "\n--- Patricia Tree Menu ---\n";
        std::cout << "1. Insertar clave\n";
        std::cout << "2. Buscar clave\n";
        std::cout << "3. Eliminar clave\n";
        std::cout << "4. Verificar si esta vacio\n";
        std::cout << "5. Vaciar el arbol\n";
        std::cout << "6. Ejecutar pruebas de rendimiento\n";
        std::cout << "7. Salir\n";
        std::cout << "Ingrese su eleccion: ";
        std::cin >> choice;

        switch (choice) {
            case 1: // Insertar clave
                std::cout << "Ingrese la clave (texto): ";
                std::cin >> input;
                std::cout << "Ingrese el valor asociado: ";
                std::cin >> value;
                trie.insert(encodeString(input), value);
                std::cout << "Clave '" << input << "' insertada con éxito.\n";
                break;

            case 2: // Buscar clave
                std::cout << "Ingrese la clave a buscar (texto): ";
                std::cin >> input;
                {
                    auto results = trie.search(encodeString(input));
                    if (results.empty()) {
                        std::cout << "Clave '" << input << "' no encontrada.\n";
                    } else {
                        std::cout << "Valores asociados a '" << input << "': ";
                        for (const auto& res : results) {
                            std::cout << res << " ";
                        }
                        std::cout << "\n";
                    }
                }
                break;

            case 3: // Eliminar clave
                std::cout << "Ingrese la clave a eliminar (texto): ";
                std::cin >> input;
                if (trie.deleteKey(encodeString(input))) {
                    std::cout << "Clave '" << input << "' eliminada con éxito.\n";
                } else {
                    std::cout << "Clave '" << input << "' no encontrada.\n";
                }
                break;

            case 4: // Verificar si está vacío
                if (isEmpty(trie)) {
                    std::cout << "El árbol está vacío.\n";
                } else {
                    std::cout << "El árbol no está vacío.\n";
                }
                break;

            case 5: // Vaciar el árbol
                clearTree(trie);
                std::cout << "El árbol ha sido vaciado.\n";
                break;

            case 6: // Ejecutar pruebas de rendimiento
                std::cout << "Ejecutando pruebas de rendimiento...\n";
                runTests();
                break;

            case 7: // Salir
                std::cout << "Saliendo del programa. ¡Adiós!\n";
                break;

            default:
                std::cout << "Opción no válida. Intente nuevamente.\n";
        }

    } while (choice != 7);

    return 0;
}
