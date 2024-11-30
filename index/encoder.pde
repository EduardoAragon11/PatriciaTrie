String encodeString(String word) {
    String binary = "";
    for (char c : word.toCharArray()) {
        binary += encodeChar(c);
    }
    return binary;
}

String encodeChar(char c) {
    int a = Character.toLowerCase(c) - 'a' + 1;
    String binary = "";
    int cont = 0;
    while (a > 0) {
        binary = (a % 2) + binary;
        a /= 2;
        cont++;
    }
    while (cont < 5) {
        binary = "0" + binary;
        cont++;
    }
    return binary;
}
