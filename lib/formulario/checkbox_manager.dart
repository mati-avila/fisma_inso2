class CheckboxManager {
  Map<String, List<String>> seleccionadosPorCategoria = {
    "Beneficio Social": [],
    "Vacunas": [],
    "Factores de Riesgo": [],
    "Discapacidad": [],
    "Enfermedades": [],
  };

  final Map<String, List<String>> categorias = {
    "Discapacidad": [
      "Dificultad para ver",
      "Dificultad para oir o hablar",
      "Dificultad para moverse",
      "Dificultad en el aprendizaje",
      "Perdida de sencibilidad en las manos o pies",
      "Utilizacion de algun soporte de oxigeno"
    ],
    "Enfermedades": [
      "Diabetes (DBT)",
      "Hipertensión Arterial(HTA)",
      "Obesidad (O)"
    ],
    "Beneficio Social": [
      "AUH",
      "Garrafa Social",
      "Apoyo alimentario",
      "Comedores",
      "Otros"
    ],
    "Vacunas": [
      "Hepatitis B",
      "Triple Viral ",
      "Pentavalente",
      'Antineumocócica',
      'Vacuna contra la Gripe'
    ],
    "Factores de Riesgo": [
      "Antecedentes de Suicidio",
      "Violencia Familiar",
      "Consumo Problemático",
      "Enfermedad Crónica / Hereditaria",
      "Adolescente que no estudia ni trabaja",
      'Trastornos alimentarios',
      "Trabajo infantil"
    ]
  };

  Map<String, String> resultados = {
    "Beneficio Social": '',
    "Vacunas": '',
    "Factores de Riesgo": '',
    "Discapacidad": '',
    "Enfermedades": ''
  };

  void onCheckboxChanged(String categoria, String valor, bool isSelected) {
    if (isSelected) {
      seleccionadosPorCategoria[categoria]!.add(valor);
    } else {
      seleccionadosPorCategoria[categoria]!.remove(valor);
    }
  }

  void generarResultados() {
    resultados.forEach((key, value) {
      resultados[key] = seleccionadosPorCategoria[key]!.join(', ');
    });
  }
}
