class Validaciones {
  static String? validarVacio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor Complete el Campo';
    }
    return null;
  }

  static String? validarCelular(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor Complete el Campo';
    }
    if (value.length < 9) {
      return 'El número debe tener al menos 10 dígitos';
    }
    return null;
  }

  static String? validarNumerico(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor Complete el Campo';
    }
    if (value.length < 2) {
      return 'El número debe tener al menos 3 dígitos';
    }
    return null;
  }

  static String? validarCoordenadas(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese dos números.';
    }
    final numbers = value.split(',');
    if (numbers.length != 2) {
      return 'Por favor, ingrese exactamente dos números separados por una coma.';
    }
    String firstNumber = numbers[0].trim();
    if (!firstNumber.startsWith('+') && !firstNumber.startsWith('-')) {
      return 'El primer número debe comenzar con "+" o "-".';
    }
    for (var number in numbers) {
      if (double.tryParse(number.trim()) == null) {
        return 'Por favor, ingrese números válidos.';
      }
    }
    return null;
  }
}
