String convertLettersToNumbers(String input) {
  // Mapa de letras para números (A = 0, B = 1, ..., Z = 25)
  Map<String, String> letterToNumber = {
    'A': '26', 'B': '1', 'C': '2', 'D': '3', 'E': '4',
    'F': '5', 'G': '6', 'H': '7', 'I': '8', 'J': '9',
    'K': '10', 'L': '11', 'M': '12', 'N': '13', 'O': '14',
    'P': '15', 'Q': '16', 'R': '17', 'S': '18', 'T': '19',
    'U': '20', 'V': '21', 'W': '22', 'X': '23', 'Y': '24', 'Z': '25'
  };

  String result = '';

  // Percorrer cada caractere da string
  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    // Se for uma letra, converte para o número correspondente
    if (letterToNumber.containsKey(char)) {
      result += letterToNumber[char]!;
    } else {
      // Se não for letra, apenas copia o caractere
      result += char;
    }
  }

  return result;
}
// Função para reverter números para letras
String convertNumbersToLetters(String input) {
  // Mapa de números para letras (0 = A, 1 = B, ..., 25 = Z)
  Map<String, String> numberToLetter = {
    '26': 'A', '1': 'B', '2': 'C', '3': 'D', '4': 'E',
    '5': 'F', '6': 'G', '7': 'H', '8': 'I', '9': 'J',
    '10': 'K', '11': 'L', '12': 'M', '13': 'N', '14': 'O',
    '15': 'P', '16': 'Q', '17': 'R', '18': 'S', '19': 'T',
    '20': 'U', '21': 'V', '22': 'W', '23': 'X', '24': 'Y', '25': 'Z'
  };

  String result = '';
  int i = 0;

  // Percorrer cada caractere da string
  while (i < input.length) {
    // Verificar se os dois próximos caracteres formam um número de dois dígitos
    if (i < input.length - 1 && numberToLetter.containsKey(input.substring(i, i + 2))) {
      result += numberToLetter[input.substring(i, i + 2)]!;
      i += 2;
    } else if (numberToLetter.containsKey(input[i])) {
      result += numberToLetter[input[i]]!;
      i += 1;
    } else {
      // Se for número, apenas copia o caractere
      result += input[i];
      i += 1;
    }
  }

  return result;
}

String formatSerialKey(String serialKey) {
    // Remove os hífens e converte a string para letras maiuscula
    String formattedKey = serialKey.replaceAll('-', '').toUpperCase();
    return formattedKey;
}

String getFromEighthDigit(String serial) {
  if (serial.length <= 8) {
    return serial; // Caso a string tenha menos ou igual a 7 dígitos, retorna ela mesma
  }
  return serial.substring(8); // Retorna a partir do 8º dígito
}